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
| **Allowed tools** | Read, Write, Grep, Glob, TaskCreate, TaskUpdate, AskUserQuestion |
| **Delegates to** | research-orchestrator agent |

**Behavior:** Conducts 8-section elicitation (decision context, audience, scope, competitive context, priorities, success criteria, constraints), synthesizes research brief, creates `./reports/<topic-slug>/state.json`, spawns research-orchestrator with prioritized dimensions.

**Flags:**
- `--quick` — Abbreviated elicitation (decision context, top 3 priorities, timeline only)

---

## /sigint:augment

Deep-dive into a specific area of current research.

| Property | Value |
|----------|-------|
| **Arguments** | `<area> [--methodology <type>]` |
| **Allowed tools** | Read, Write, Grep, Glob |
| **Delegates to** | dimension-analyst agent |

**Areas:** `competitive landscape`, `market sizing`, `trends`, `customer research`, `technology assessment`, `financial analysis`, `regulatory review`

**Methodology types:** `competitive`, `sizing`, `trends`, `customer`, `tech`, `financial`, `regulatory`

---

## /sigint:update

Refresh data and findings for existing research.

| Property | Value |
|----------|-------|
| **Arguments** | `[--area <area>] [--since <date>]` |
| **Allowed tools** | Read, Write, Grep, Glob, WebSearch, WebFetch |
| **Delegates to** | Direct execution |

**Behavior:** Identifies stale findings (>30 days), fetches fresh data with date filters, compares with existing findings, recalculates trend directions (INC/DEC/CONST), updates state.json.

---

## /sigint:report

Generate comprehensive research report.

| Property | Value |
|----------|-------|
| **Arguments** | `[--format <type>] [--audience <type>] [--sections <list>]` |
| **Allowed tools** | Read, Write, Grep, Glob |
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
| **Allowed tools** | Read, Write, Bash, Grep, Glob |
| **Delegates to** | issue-architect agent |

**Issue categories:** `enhancement`/`feature`, `enhancement`, `research`, `action-item`

**Priority levels:** P0 (critical), P1 (high), P2 (medium), P3 (low)

---

## /sigint:resume

Resume a previous research session.

| Property | Value |
|----------|-------|
| **Arguments** | `[<topic>] [--list]` |
| **Allowed tools** | Read, Write, Grep, Glob |

**Behavior:** Scans `./reports/*/state.json` for sessions, recalls Atlatl memories for context. With `--list`, displays table of all sessions.

---

## /sigint:status

Show current research session state and progress.

| Property | Value |
|----------|-------|
| **Arguments** | `[--verbose]` |
| **Allowed tools** | Read, Grep, Glob |

**Behavior:** Finds active session, loads state.json, checks blackboard for live team status, calculates progress metrics, displays dashboard with findings coverage and suggested next actions.

---

## /sigint:init

Initialize or reload Atlatl memory context.

| Property | Value |
|----------|-------|
| **Arguments** | `[--full] [--topic <topic>]` |
| **Allowed tools** | Read, Write, Grep, Glob |

**Behavior:** Searches Atlatl memories with sigint-research tags, loads cascading configuration (project > global > defaults), creates project config if missing, displays context summary.

## See also

- [Agents Reference](agents.md)
- [Research Workflow](../how-to/research-workflow.md)
