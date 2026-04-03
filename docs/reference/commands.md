---
diataxis_type: reference
title: Commands Reference
description: Complete reference for all sigint slash commands
---

# Commands Reference

All sigint slash commands with their arguments, options, and behavior.

## /sigint:start

Begin a new market research session with structured elicitation.

| Property | Value |
|----------|-------|
| **Arguments** | `[<topic>]` |
| **Allowed tools** | Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion |
| **Atlatl tools** | capture_memory, recall_memories, enrich_memory, blackboard_create, blackboard_write, blackboard_read, blackboard_alert, blackboard_pending_alerts, blackboard_ack_alert |
| **Delegates to** | research-orchestrator agent |

**Behavior:** Conducts 8-section elicitation (decision context, audience, scope, competitive context, priorities, success criteria, constraints), synthesizes research brief, creates `./reports/<topic-slug>/state.json`, spawns research-orchestrator with prioritized dimensions.

**Flags:**
- `--quick` -- Abbreviated elicitation (decision context, top 3 priorities, timeline only)

---

## /sigint:augment

Deep-dive into a specific area of current research.

| Property | Value |
|----------|-------|
| **Arguments** | `<area> [--methodology <type>]` |
| **Allowed tools** | Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion |
| **Atlatl tools** | capture_memory, recall_memories, enrich_memory, blackboard_create, blackboard_write, blackboard_read, blackboard_alert, blackboard_pending_alerts, blackboard_ack_alert |
| **Delegates to** | dimension-analyst agent (via research-orchestrator in augment mode) |

**Areas:** `competitive landscape`, `market sizing`, `trends`, `customer research`, `technology assessment`, `financial analysis`, `regulatory review`, `trend modeling`

**Methodology types:** `competitive`, `sizing`, `trends`, `customer`, `tech`, `financial`, `regulatory`, `trend_modeling`

---

## /sigint:update

Refresh data and findings for existing research using swarm orchestration.

| Property | Value |
|----------|-------|
| **Arguments** | `[--topic <slug>] [--area <area>] [--since <date>] [--no-delta] [--dimensions <dim1,dim2,...>]` |
| **Allowed tools** | Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion |
| **Atlatl tools** | capture_memory, recall_memories, enrich_memory, blackboard_create, blackboard_write, blackboard_read, blackboard_alert, blackboard_pending_alerts, blackboard_ack_alert |
| **Delegates to** | research-orchestrator agent (update mode) |

**Behavior:** Loads prior state, spawns dimension-analysts for specified dimensions, runs delta detection protocol (classifying findings as NEW/UPDATED/CONFIRMED/POTENTIALLY_REMOVED/TREND_REVERSAL), merges findings with reconciliation, generates delta report.

---

## /sigint:report

Generate comprehensive research report.

| Property | Value |
|----------|-------|
| **Arguments** | `[--format <type>] [--audience <type>] [--sections <list>]` |
| **Allowed tools** | Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion |
| **Atlatl tools** | capture_memory, recall_memories, enrich_memory, blackboard_create, blackboard_write, blackboard_read |
| **Delegates to** | report-synthesizer agent |

**Formats:** `markdown` (default), `html`, `both`

**Audiences:** `executives`, `pm`, `investors`, `dev`, `all`

**Sections:** `executive-summary`, `market-overview`, `market-sizing`, `competitive`, `trends`, `swot`, `recommendations`, `risk`, `appendix` (or `all`)

---

## /sigint:issues

Create GitHub issues from research findings.

| Property | Value |
|----------|-------|
| **Arguments** | `[--repo <owner/repo>] [--dry-run] [--labels <list>]` |
| **Allowed tools** | Read, Write, Bash, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet, AskUserQuestion, ToolSearch |
| **Atlatl tools** | capture_memory, recall_memories, enrich_memory, blackboard_create, blackboard_write, blackboard_read |
| **GitHub tools** | issue_write, issue_read |
| **Delegates to** | issue-architect agent |

**Issue categories:** `enhancement`/`feature`, `enhancement`, `research`, `action-item`

**Priority levels:** P0 (critical), P1 (high), P2 (medium), P3 (low)

---

## /sigint:resume

Resume a previous research session.

| Property | Value |
|----------|-------|
| **Arguments** | `[<topic>] [--list]` |
| **Allowed tools** | Read, Write, Grep, Glob, AskUserQuestion |
| **Atlatl tools** | inject_context, recall_memories |

**Behavior:** Follows the harness initialization protocol -- reads `research-progress.md` first to understand prior work state. Scans `./reports/*/state.json` for sessions, recalls Atlatl memories for context. With `--list`, displays table of all sessions.

---

## /sigint:status

Show current research session state and progress.

| Property | Value |
|----------|-------|
| **Arguments** | `[--verbose]` |
| **Allowed tools** | Read, Grep, Glob |
| **Atlatl tools** | blackboard_read |

**Behavior:** Finds active session, loads state.json, checks blackboard for live team status, calculates progress metrics, displays dashboard with findings coverage and suggested next actions.

---

## /sigint:init

Initialize or reload Atlatl memory context.

| Property | Value |
|----------|-------|
| **Arguments** | `[--full] [--topic <topic>]` |
| **Allowed tools** | Bash, Glob, Grep, Read, Write |
| **Atlatl tools** | recall_memories |

**Behavior:** Searches Atlatl memories with sigint-research tags, loads cascading configuration (project > global > defaults), creates project config if missing, displays context summary.

## See also

- [Agents Reference](agents.md)
- [Research Workflow](../how-to/research-workflow.md)
