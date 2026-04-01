---
name: schedule
description: Create Desktop Scheduled Tasks for recurring research updates. Wraps /sigint:update with cron-style scheduling.
argument-hint: "<dimensions> --interval <cron-expression> --topic <topic-slug>"
---

# Sigint Schedule Skill

This skill creates Desktop Scheduled Tasks that run `/sigint:update` on a recurring schedule. It enables continuous research monitoring by automatically refreshing findings at configured intervals.

## Arguments

Parse `$ARGUMENTS`:

- `$1` — Dimensions to update (comma-separated, e.g., "competitive,trends"). Default: all dimensions from active session.
- `--interval <cron>` — Cron expression for scheduling (e.g., `"0 9 * * MON"` = every Monday at 9am). Required.
- `--topic <slug>` — Topic slug to update. Default: auto-detect from active session.
- `--list` — List all active sigint schedules.
- `--cancel <schedule-id>` — Cancel a scheduled task.

---

## Phase 0: Validate Prerequisites

### Step 0.1: Verify Active Research Session

```
Glob("./reports/*/state.json")
```

If `--topic` specified, verify `./reports/{topic-slug}/state.json` exists.
If not specified, auto-detect. If multiple sessions, ask user to specify.
If none, stop: "No active research session. Run `/sigint:start` first."

### Step 0.2: Load Session State

Read `./reports/{topic-slug}/state.json`. Extract:
- `topic`, `topic_slug`
- `elicitation.dimensions` (for default dimension list)
- `lineage[]` (to show history)

---

## Phase 1: Handle List/Cancel

### If `--list`

Check for existing scheduled tasks:
```bash
# List Claude Code Desktop scheduled tasks matching sigint
# The exact API depends on Claude Code Desktop task management
```

Display:
```
Active Sigint Schedules:
| ID | Topic | Dimensions | Interval | Last Run | Next Run |
|----|-------|-----------|----------|----------|----------|
```

### If `--cancel <id>`

Cancel the specified scheduled task and remove from state.json schedule tracking.

---

## Phase 2: Create Scheduled Task

### Step 2.1: Resolve Dimensions

Priority:
1. `$1` argument (if provided)
2. All dimensions from `elicitation.dimensions`

### Step 2.2: Generate Task Prompt

Build the prompt that will run on schedule:

```
Run /sigint:update --dimensions {dimensions} --topic {topic-slug} --delta
```

### Step 2.3: Create Desktop Scheduled Task

```bash
# Create via Claude Code Desktop scheduled task API
# The task prompt runs /sigint:update with the configured dimensions
```

**Scheduling tiers (priority order):**

| Tier | Use Case | Implementation |
|------|----------|---------------|
| Desktop Scheduled Task | Daily/weekly research updates | **Primary** — persists, local file + MCP access |
| CronCreate (in-session) | Poll during active research | Secondary — 3-day TTL, session-scoped |

Desktop tasks are preferred because they:
- Persist across restarts (unlike CronCreate's 3-day TTL)
- Have full local file and MCP access
- Run the full swarm orchestration pipeline

### Step 2.4: Record Schedule in State

Update `./reports/{topic-slug}/state.json`:
```json
{
  "schedules": [
    {
      "id": "{schedule-id}",
      "dimensions": ["competitive", "trends"],
      "interval": "0 9 * * MON",
      "created": "{ISO_DATE}",
      "last_run": null,
      "status": "active"
    }
  ]
}
```

### Step 2.5: Confirm to User

```
Scheduled research update created:
  Topic: {topic}
  Dimensions: {list}
  Interval: {cron expression} ({human readable})
  Next run: {estimated next run time}

The update will run /sigint:update --delta automatically, including:
- Fresh web research for specified dimensions
- Delta detection against prior findings
- Codex review gates for quality verification
- Progress file updates

Manage schedules: /sigint:schedule --list, /sigint:schedule --cancel <id>
```

---

## Output

- Scheduled task created and confirmed
- Schedule recorded in state.json
- Instructions for managing schedules
