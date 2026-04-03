---
diataxis_type: reference
title: Agents Reference
description: Complete reference for all sigint agents
---

# Agents Reference

Sigint uses 5 specialized agents for research orchestration, analysis, reporting, and issue creation.

## research-orchestrator

**File**: `agents/research-orchestrator.md`

Orchestrator agent for sigint research sessions. Owns all phase management: team lifecycle, dimension-analyst spawning, codex review gates, finding merge, progress tracking, delta detection, and cleanup. Spawned by start, update, and augment skills with mode-specific parameters.

| Property | Value |
|----------|-------|
| **Version** | 0.5.0 |
| **Color** | cyan |
| **Model** | inherit |
| **Spawned by** | `/sigint:start`, `/sigint:update`, `/sigint:augment` |

**Tools:** Agent, AskUserQuestion, Bash, Glob, Grep, Read, SendMessage, TaskCreate, TaskGet, TaskList, TaskUpdate, TeamCreate, TeamDelete, Write

**Atlatl tools:** blackboard_ack_alert, blackboard_alert, blackboard_create, blackboard_pending_alerts, blackboard_read, blackboard_write, capture_memory, enrich_memory, recall_memories

**Modes**: `full` (start), `update` (update), `augment` (augment)

**Key capabilities**:
- Blocking codex review gates at 4 pipeline boundaries (post-findings, post-merge, post-report, post-issues)
- Quarantine mechanism for gate failures (`quarantine.json`)
- Delta detection protocol for update mode (NEW/UPDATED/CONFIRMED/POTENTIALLY_REMOVED/TREND_REVERSAL)
- Progress file generation (`research-progress.md`) for cross-session continuity
- Lineage tracking in `state.json` for full provenance chain
- Blackboard dual-write (blackboard + file) as default behavior

---

## dimension-analyst

Focused research on a single market dimension, parameterized by skill.

| Property | Value |
|----------|-------|
| **Version** | 0.4.0 |
| **Color** | yellow |
| **Model** | inherit |
| **Spawned by** | research-orchestrator, `/sigint:augment` |

**Tools:** Bash, Glob, Grep, Read, SendMessage, Skill, TaskCreate, TaskGet, TaskList, TaskUpdate, WebFetch, WebSearch, Write

**Atlatl tools:** blackboard_alert, blackboard_read, blackboard_write, capture_memory, enrich_memory, recall_memories

**Dimension-to-skill mapping:**

| Dimension | Skill | Blackboard Key |
|-----------|-------|---------------|
| competitive | competitive-analysis | `findings_competitive` |
| sizing | market-sizing | `findings_sizing` |
| trends | trend-analysis | `findings_trends` |
| customer | customer-research | `findings_customer` |
| tech | tech-assessment | `findings_tech` |
| financial | financial-analysis | `findings_financial` |
| regulatory | regulatory-review | `findings_regulatory` |
| trend_modeling | trend-modeling | `findings_trend_modeling` |

---

## source-chunker

RLM processor for large documents exceeding context limits.

| Property | Value |
|----------|-------|
| **Version** | 0.4.0 |
| **Color** | blue |
| **Model** | inherit |
| **Spawned by** | research-orchestrator (on behalf of dimension-analyst request) |

**Tools:** Read, Write, WebFetch, Grep, Glob, Agent, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet

**Content-type partitioning:**

| Type | Detection | Chunk Size | Split Strategy |
|------|-----------|-----------|----------------|
| prose | >10K words | 3-5K words | Section headings, 10% overlap |
| structured_data | .csv/.xlsx | 1500 rows | Logical groupings |
| json | .json, API response | 200-500 elements | Top-level array |
| regulatory | Legal text | 2-3K words | Section/article boundaries |

**Threshold:** Documents under ~15K tokens (~60K characters) are returned directly without chunking.

---

## report-synthesizer

Transforms research findings into executive-ready documents with visualizations.

| Property | Value |
|----------|-------|
| **Version** | 0.1.0 |
| **Color** | magenta |
| **Model** | inherit |
| **Spawned by** | `/sigint:report` |

**Tools:** Bash, Glob, Grep, Read, SendMessage, Skill, TaskGet, TaskList, TaskUpdate, WebFetch, Write

**Atlatl tools:** blackboard_read, capture_memory, enrich_memory, recall_memories

**Report sections:** Executive Summary, Market Overview, Market Sizing (TAM/SAM/SOM), Competitive Landscape, Trend Analysis, SWOT Analysis, Recommendations, Risk Assessment, Appendix

**Audience tailoring:** Executives (strategic), Product Managers (features/roadmap), Investors (opportunity/growth), Developers (technical feasibility)

---

## issue-architect

Converts research findings into sprint-sized GitHub issues.

| Property | Value |
|----------|-------|
| **Version** | 0.1.0 |
| **Color** | green |
| **Model** | inherit |
| **Spawned by** | `/sigint:issues` |

**Tools:** Bash, Glob, Grep, Read, SendMessage, TaskGet, TaskList, TaskUpdate, ToolSearch, Write

**Atlatl tools:** capture_memory, enrich_memory, recall_memories

**GitHub tools:** issue_read, issue_write

**Issue categories:** Feature requests, Enhancements, Research tasks, Action items

**Priority framework:** P0 (competitive threat, regulatory), P1 (market opportunity, differentiation), P2 (incremental, optimization), P3 (future, speculative)

## See also

- [Commands Reference](commands.md)
- [Architecture](../explanation/architecture.md)
- [Skills Reference](skills.md)
