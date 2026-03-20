---
diataxis_type: reference
title: Agents Reference
description: Complete reference for all sigint agents
---

# Agents Reference

Sigint uses 5 specialized agents for research orchestration, analysis, reporting, and issue creation.

## research-orchestrator

Coordinates parallel market research across multiple dimensions.

| Property | Value |
|----------|-------|
| **Version** | 0.4.0 |
| **Color** | cyan |
| **Model** | inherit |
| **Spawned by** | `/sigint:start` |

**Tools:** Read, Write, Grep, Glob, Agent, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet

**Atlatl tools:** blackboard_create, blackboard_write, blackboard_read, blackboard_alert, blackboard_pending_alerts, blackboard_ack_alert, recall_memories, capture_memory, enrich_memory

**Behavior:** Creates blackboard (TTL 24h), writes elicitation context, spawns parallel dimension-analysts (max 5 concurrent), monitors via blackboard alerts, merges findings into state.json, captures summary to Atlatl.

---

## dimension-analyst

Focused research on a single market dimension, parameterized by skill.

| Property | Value |
|----------|-------|
| **Version** | 0.4.0 |
| **Color** | yellow |
| **Model** | inherit |
| **Spawned by** | research-orchestrator, `/sigint:augment` |

**Tools:** Read, Write, Grep, Glob, WebSearch, WebFetch, Skill, Agent, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet

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

---

## source-chunker

RLM processor for large documents exceeding context limits.

| Property | Value |
|----------|-------|
| **Version** | 0.4.0 |
| **Color** | blue |
| **Model** | inherit |
| **Spawned by** | dimension-analyst |

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

**Tools:** Read, Write, Grep, Glob, WebFetch, Skill

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

**Tools:** Read, Write, Bash, Grep, Glob, ToolSearch

**Issue categories:** Feature requests, Enhancements, Research tasks, Action items

**Priority framework:** P0 (competitive threat, regulatory), P1 (market opportunity, differentiation), P2 (incremental, optimization), P3 (future, speculative)

## See also

- [Commands Reference](commands.md)
- [Architecture](../explanation/architecture.md)
- [Skills Reference](skills.md)
