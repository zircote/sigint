---
diataxis_type: explanation
title: Architecture
description: How sigint's swarm orchestration, blackboard coordination, and memory systems work
---

# Architecture

Sigint uses a swarm-orchestrated architecture where a research-orchestrator coordinates parallel dimension-analysts via an ephemeral blackboard, with long-term knowledge persisted through Atlatl memory.

## Agent hierarchy

```
research-orchestrator
  ├── dimension-analyst (1 per priority, max 5 concurrent)
  │   └── source-chunker (for large documents)
  ├── report-synthesizer (post-research)
  └── issue-architect (post-report)
```

The research-orchestrator is the only agent that spawns other agents. Commands delegate to exactly one agent — they never execute research directly.

## Blackboard coordination

The blackboard is an ephemeral key-value store (TTL 24h) created per research session. It serves as the shared scratchpad between the orchestrator and its analysts.

### Blackboard schema

| Key | Written by | Read by | Content |
|-----|-----------|---------|---------|
| `elicitation` | orchestrator | all analysts | Full elicitation context from state.json |
| `team_status` | orchestrator | status command | `{analysts: {dimension: status, ...}}` |
| `findings_{dimension}` | dimension-analyst | orchestrator, report-synthesizer | Structured findings with sources and gaps |
| `conflicts` | dimension-analyst | orchestrator | Cross-dimension contradictions |

### Alert channels

| Channel | Publisher | Subscriber | Trigger |
|---------|----------|------------|---------|
| `finding_discovered` | analyst | orchestrator | Significant finding (>20% share shift, etc.) |
| `conflict_detected` | analyst | orchestrator | Cross-dimension contradiction |
| `phase_complete` | analyst | orchestrator | Dimension research finished |
| `source_shared` | analyst | other analysts | High-value source useful across dimensions |

## Blackboard vs Atlatl memory

These serve different purposes and should not be confused:

- **Blackboard** = ephemeral session coordination. Inter-agent scratchpad. Dies after 24 hours. Used during active research for team communication.
- **Atlatl memory** = permanent cross-session knowledge. Key findings, decisions, methodology patterns. Survives across sessions. Used for recall when starting related research.

**Rule:** Every finding written to the blackboard should also be captured to Atlatl memory if it has cross-session value.

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
2. research-orchestrator creates blackboard, writes elicitation
3. Parallel dimension-analysts read elicitation, load skill methodologies, conduct web research
4. Each analyst writes findings to blackboard, alerts orchestrator on completion
5. Orchestrator merges all findings into state.json
6. `/sigint:report` → report-synthesizer reads state.json + blackboard findings
7. `/sigint:issues` → issue-architect atomizes findings into GitHub issues

## See also

- [Agents Reference](../reference/agents.md)
- [Skills Reference](../reference/skills.md)
- [Research Methodology](methodology.md)
