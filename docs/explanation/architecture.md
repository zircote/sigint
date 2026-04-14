---
diataxis_type: explanation
title: Architecture
description: How sigint's swarm orchestration and coordination systems work
---

# Architecture

Sigint uses a swarm-orchestrated architecture where a research-orchestrator coordinates parallel dimension-analysts via the task system and file-based state.

## Agent hierarchy

```
research-orchestrator
  ├── dimension-analyst (1 per priority, max 5 concurrent)
  │   └── source-chunker (for large documents)
  ├── report-synthesizer (post-research)
  └── issue-architect (post-report)
```

The research-orchestrator is the only agent that spawns other agents. Commands delegate to exactly one agent -- they never execute research directly.

## Harness pattern

The research-orchestrator follows the Anthropic long-running agent harness pattern. The key artifact is `research-progress.md`, written on every phase transition. This file serves as the cross-session continuity mechanism:

- When `/sigint:resume` is called, the harness reads `research-progress.md` first to reconstruct prior work state before taking any action
- Each phase transition appends a timestamped entry with mode, dimensions, findings counts, and next steps
- The file is never overwritten -- prior entries form an audit trail

This pattern ensures that a research session interrupted mid-pipeline (by context exhaustion, network failure, or user pause) can be resumed from the last completed phase rather than restarted from scratch.

## Codex review gates

Four blocking gates enforce quality at pipeline boundaries. Each gate spawns a codex review agent that evaluates data against specific criteria. If the gate fails, affected findings are quarantined -- moved to `quarantine.json` and removed from the active pipeline.

| Gate | Trigger Point | Review Criteria |
|------|--------------|-----------------|
| **Post-findings** | After each dimension-analyst completes | Evidence sufficiency, source validity, methodology coverage, provenance completeness, fabrication detection |
| **Post-merge** | After findings from all dimensions are consolidated | Cross-dimension consistency, duplicate detection, gap identification, overall coherence |
| **Post-report** | After report generation | Claim traceability, no hallucinated statistics, balanced representation, source attribution |
| **Post-issues** | After issue generation | Issue-finding linkage, acceptance criteria completeness, priority justification |

The gates are blocking -- the pipeline does not advance until the review passes or quarantined items are removed. This prevents unverified claims from propagating into reports and issues.

### Quarantine mechanism

When a codex gate fails, the flagged findings are written to `quarantine.json` with metadata: the finding ID, originating dimension, rejection reason, gate name, and timestamp. The original finding object is preserved for potential manual review. Quarantined findings are removed from the active findings set before the pipeline continues.

## Provenance enforcement

Every finding in the pipeline must carry a provenance record:

```json
{
  "claim": "The specific factual claim",
  "sources": [
    {
      "url": "https://...",
      "fetched_at": "ISO timestamp",
      "snippet": "Exact supporting text from source",
      "alive": true
    }
  ],
  "derivation": "direct_quote|synthesis|extrapolation",
  "confidence_basis": "2 independent sources, both <6mo old"
}
```

Dimension-analysts populate provenance during research. Codex review gates verify it. Findings without provenance are flagged by the post-findings gate. This ensures every claim in the final report traces back to a retrievable, timestamped source.

## Delta detection protocol

When the research-orchestrator runs in update mode (via `/sigint:update`), it classifies new findings against prior state before merging:

| Classification | Meaning | Merge Action |
|---------------|---------|--------------|
| **NEW** | No match in previous findings | Add to findings array |
| **UPDATED** | Match found, details changed | Replace prior finding in-place |
| **CONFIRMED** | Match found, substantially unchanged | Keep prior, update `last_confirmed` |
| **POTENTIALLY_REMOVED** | Prior finding not matched by new research | Move to `archived_findings[]` |
| **TREND_REVERSAL** | Matched finding with changed trend direction (e.g., INC to DEC) | High-priority alert + update |

Matching uses dimension + title similarity (>0.8 threshold). Sequential IDs like `f_competitive_3` are for human readability, not stable matching.

### Delta detail and newsworthiness (v0.9.0+)

UPDATED findings carry a `delta_detail` object that sub-classifies the change and signals newsworthiness for downstream consumers (report generators, article writers):

| Field | Purpose |
|-------|---------|
| `changed_fields` | Which mutable fields differ (summary, confidence, trend, tags, entities, sources, market_dynamic, provenance) |
| `change_category` | Dominant change type: `substantive`, `temporal`, `confidence_shift`, `source_refresh`, or `metadata` |
| `newsworthiness` | `high` (report), `medium` (mention if relevant), `low` (skip) |
| `newsworthiness_basis` | One sentence explaining the rating |
| `summary_diff` | Brief description of what changed in the summary, or null |
| `confidence_change` | `{previous, current}` values, or null |
| `trend_change` | `{previous, current}` values, or null |

The lineage entry's `delta_from_previous` includes a structured `update_breakdown` by change category and a `newsworthy_count` (= new + high-newsworthiness updates + trend reversals).

The delta detection generates a dated delta report (`YYYY-MM-DD-delta.md`) and delta findings JSON (`findings_delta_YYYY-MM-DD.json`). The markdown report includes a **Newsworthy Changes** section consolidating all items worth reporting, plus sub-categorized Updated Findings sections. The JSON file is validated against `schemas/delta-findings.jq`.

## Structured Data Protocol

All JSON file operations across sigint use `jq` via Bash. The `Edit` tool and `Write` tool are prohibited for JSON files. This is enforced by the Structured Data Protocol (`protocols/STRUCTURED-DATA.md`), derived from the `/refactor:xq` reliability patterns.

The protocol mandates:

1. **Write-then-validate**: Every JSON write is immediately followed by schema validation using the corresponding `schemas/*.jq` file
2. **Retry-and-correct**: If validation fails, diagnose, fix with jq, and re-validate (max 2 retries). Invalid data never proceeds through the pipeline.
3. **File persistence**: All findings written to validated JSON files. Files are the sole durable store.
4. **Safe interpolation**: Shell variables enter jq via `--arg`/`--argjson`, never via string interpolation.

Twelve schema validators exist in `schemas/`: state, findings, elicitation, methodology-plan, reflection, quarantine, merged-findings, report-metadata, issues, team-status, conflicts, and sigint-config.

## File-based coordination

All inter-agent coordination uses file-based state in the `reports/{topic_slug}/` directory. Each research session produces structured JSON files that serve as the shared state between the orchestrator and its analysts.

### State files

| File | Written by | Read by | Content |
|------|-----------|---------|---------|
| `state.json` | orchestrator | all agents | Full session state including elicitation |
| `methodology_plan_{dim}.json` | dimension-analyst | orchestrator | Planned frameworks per dimension |
| `findings_{dimension}.json` | dimension-analyst | orchestrator, report-synthesizer | Structured findings with sources and gaps |
| `findings_{dim}_conflicts.json` | dimension-analyst | orchestrator | Cross-dimension contradictions |
| `merged_findings.json` | orchestrator | report-synthesizer | Consolidated post-merge findings |

Agents signal completion via TaskUpdate and SendMessage.

## Source chunking (RLM)

When a dimension-analyst encounters a document exceeding ~15K tokens, it delegates to the source-chunker agent. The chunker:

1. Detects content type (prose, structured data, JSON, regulatory text)
2. Partitions into overlapping chunks appropriate to the content type
3. Spawns parallel chunk-analyst agents (max 5 concurrent)
4. Deduplicates findings from overlapping regions
5. Returns synthesized findings to the calling analyst

This enables analysis of documents that would otherwise exceed a single agent's context window.

## Research flow

1. `/sigint:start` conducts elicitation, creates state.json
2. research-orchestrator creates session directory, writes elicitation to state.json
3. Parallel dimension-analysts read elicitation, load skill methodologies, conduct web research
4. Each analyst writes findings to validated JSON files, signals orchestrator on completion
5. Post-findings codex review gate runs per dimension; failures quarantined
6. Orchestrator merges all findings into state.json (with delta detection in update mode)
7. Post-merge codex review gate checks cross-dimension consistency
8. `/sigint:report` spawns report-synthesizer, which reads state.json + dimension findings files
9. Post-report codex review gate verifies claim traceability
10. `/sigint:issues` spawns issue-architect to atomize findings into GitHub issues
11. Post-issues codex review gate verifies issue-finding linkage

## See also

- [Agents Reference](../reference/agents.md)
- [Protocols Reference](../reference/protocols.md)
- [Skills Reference](../reference/skills.md)
- [Research Methodology](methodology.md)
