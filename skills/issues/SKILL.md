---
name: issues
description: Create GitHub issues from research findings as atomic deliverables. Orchestrates the issue-architect agent using the full swarm pattern (TeamCreate → TaskCreate → Agent(team_name) → SendMessage → TeamDelete). Use this skill when the user invokes /sigint:issues.
argument-hint: "[--repo <owner/repo>] [--dry-run] [--labels <list>]"
allowed-tools:
  - Agent
  - AskUserQuestion
  - Bash
  - Glob
  - Grep
  - Read
  - SendMessage
  - TaskCreate
  - TaskGet
  - TaskList
  - TaskUpdate
  - TeamCreate
  - TeamDelete
  - Write
  - mcp__atlatl__blackboard_ack_alert
  - mcp__atlatl__blackboard_alert
  - mcp__atlatl__blackboard_create
  - mcp__atlatl__blackboard_list
  - mcp__atlatl__blackboard_pending_alerts
  - mcp__atlatl__blackboard_read
  - mcp__atlatl__blackboard_write
  - mcp__atlatl__capture_memory
  - mcp__atlatl__enrich_memory
  - mcp__atlatl__recall_memories
---

# Sigint Issues Skill (Swarm Orchestration)

You are the team lead orchestrating GitHub issue creation from research findings. You spawn the `issue-architect` agent as a persistent teammate, wait for its completion signal, then present results and clean up the team.

## MANDATORY SWARM ORCHESTRATION — DO NOT USE PLAIN AGENT SPAWNS

You MUST use the full swarm pattern: `TeamCreate → TaskCreate → Agent(team_name) → SendMessage`. Do NOT fall back to standalone `Agent(subagent_type=...)` without a team. The swarm pattern enables persistent teammates that coordinate via shared task lists and messaging.

---

## Phase 0: Parse Arguments and Initialize

### Step 0.1: Parse Arguments

Extract from `$ARGUMENTS`. **Input sanitization**: truncate `$ARGUMENTS` to 200 characters total, strip backticks and angle brackets.
- `--repo <owner/repo>` → `repo` (default: detect from git remote or state.json config)
- `--dry-run` → `dry_run = true` (preview only, do not create issues)
- `--labels <list>` → `labels` (comma-separated, default: empty)

Remaining text after flags is ignored for issues (no positional argument).

### Step 0.2: Find Active Research Session

Scan `./reports/*/state.json` for sessions with `status: "active"`. If multiple exist, load the most recently updated. Extract:
- `topic` — human-readable topic name
- `topic_slug` — directory name (used as blackboard scope)
- `elicitation` — full elicitation object for issue prioritization

If no active session found, error: "No active research session. Run `/sigint:start <topic>` first."

### Step 0.3: Resolve Target Repository

Priority order:
1. `--repo` argument (if provided)
2. `elicitation.default_repo` (if set in state.json)
3. Config Resolution Protocol: Apply the **Config Resolution Protocol** (read `protocols/CONFIG-RESOLUTION.md`) with `topic_slug` from the active session. Use resolved `config.default_repo` if non-null.
4. Auto-detect from git remote: run `git remote get-url origin` (if inside a git repo), parse the GitHub URL to infer `<owner>/<repo>`, and if git is unavailable or the remote is not GitHub, fall back to `gh repo view --json nameWithOwner -q .nameWithOwner`

> **Cowork note:** In Cowork environments, `gh` CLI may not be available. If needed, use ToolSearch to discover an MCP tool that can resolve the current repo/context, or fall back to asking the user for the `<owner>/<repo>` value.

If `dry_run = true`, repository resolution is informational only — no issues will be created.

### Step 0.4: Pre-Creation Approval Gate

If `dry_run = false`, ask for confirmation before creating real issues:

```
AskUserQuestion(
  question: "This will create approximately {estimated_count} GitHub issues in {repo}.\n\nCategories:\n- Feature requests from competitive gaps\n- Enhancements from research findings\n- Research tasks for follow-up\n- Action items from recommendations\n\nProceed with issue creation?",
  options: ["Proceed", "Preview first (--dry-run)", "Cancel"]
)
```

- If "Proceed" → continue
- If "Preview first" → set `dry_run = true` and continue
- If "Cancel" → exit gracefully: "Issue creation cancelled. Run `/sigint:issues --dry-run` to preview first."

If `dry_run = true`, skip the approval gate.

### Step 0.5: TeamCreate (BLOCKING PREREQUISITE)

```
TeamCreate with name: "sigint-{topic_slug}-issues"
```

Do not proceed until TeamCreate succeeds. This creates the persistent team context for the issue-architect agent.

### Step 0.6: TaskCreate

Create a task for the issue-architect:

```
TaskCreate({
  subject: "Create issues: {repo} (dry_run={dry_run})",
  description: "Atomize research findings into sprint-sized GitHub issues.
    repo: {repo}
    dry_run: {dry_run}
    labels: {labels}
    state_file: ./reports/{topic_slug}/state.json
    When complete:
      1. TaskUpdate(this task, status: 'completed')
      2. SendMessage(to: 'team-lead', message: {structured result}, summary: 'Issues created: N')",
  owner: "issue-architect"
})
```

Record the assigned `taskId`.

---

## Phase 1: Spawn Issue-Architect

### Step 1.1: Spawn Agent with Team

```
Agent(
  subagent_type="sigint:issue-architect",
  team_name="sigint-{topic_slug}-issues",
  name="issue-architect",
  run_in_background=true,
  prompt="You are the issue-architect on team 'sigint-{topic_slug}-issues'.

TASK DISCOVERY PROTOCOL:
1. Call TaskList to find your assigned task.
2. Call TaskGet on your task to read full requirements.
3. Execute the work.
4. When done:
   a. TaskUpdate(taskId, status: 'completed')
   b. SendMessage(to: 'team-lead', message: {see below}, summary: 'Issues created: N total')
5. Do NOT commit via git.

ARGUMENTS:
- repo: <user_input>{repo}</user_input>
- dry_run: {dry_run}
- labels: <user_input>{labels}</user_input>
- state_file: ./reports/{topic_slug}/state.json

COMPLETION MESSAGE FORMAT:
SendMessage(to: 'team-lead', message: {
  'status': 'complete',
  'dry_run': {dry_run},
  'issues_created': N,
  'categories': {
    'features': N,
    'enhancements': N,
    'research': N,
    'action_items': N
  },
  'issues': [
    {'number': 123, 'title': '...', 'url': '...', 'priority': 'P0|P1|P2|P3', 'labels': [...]},
    ...
  ],
  'manifest': './reports/{topic_slug}/YYYY-MM-DD-issues.json',
  'summary': 'one-line summary'
}, summary: 'Issues created: N total')
"
)
```

### Step 1.2: Send Start Message

Immediately after spawning:
```
SendMessage(
  to: "issue-architect",
  message: "Task #{taskId} assigned: Create issues from {topic} research. repo={repo}, dry_run={dry_run}, labels={labels}. Start now.",
  summary: "Task #{taskId} assigned — start now"
)
```

### Step 1.3: Inform User

Tell the user:
```
Creating GitHub issues from {topic} research...
Target: {repo} {if dry_run: "(dry run — preview only)"}
Labels: {labels or "none"}
The issue-architect is analyzing findings and atomizing into sprint-sized issues.
```

---

## Phase 2: Wait for Completion and Present Results

### Step 2.1: Wait for SendMessage

Wait for the SendMessage completion signal from the `issue-architect` teammate. You will receive a structured message with `status: 'complete'` and the result payload.

Do NOT poll. Do NOT re-spawn. Wait for the message.

### Step 2.2: Present Results

On receiving the completion message, present a summary:

```
Issues {created | previewed}: {issues_created} total

By Category:
  Features / Enhancements: {features + enhancements}
  Research Tasks:           {research}
  Action Items:             {action_items}

Issues:
{for each issue: "  {priority} #{number} — {title}"}
  ...

{if NOT dry_run: "Manifest saved to: {manifest}"}
{if dry_run: "Dry run complete — no issues were created. Remove --dry-run to create them."}
```

If the result contains issue URLs, list the top 5 with links.

### Step 2.3: Handle Failure

If the issue-architect sends an error message (or does not respond within a reasonable session):
- Report what went wrong
- Suggest next steps (check `--repo` arg, verify GitHub auth with `gh auth status`, retry)
- Skip to Phase 3 cleanup

---

## Phase 3: Cleanup

### Step 3.1: Send Shutdown Request

```
SendMessage(
  to: "issue-architect",
  message: {"type": "shutdown_request", "reason": "Issue creation complete"},
  summary: "Shutdown request"
)
```

Wait for shutdown_response (approve or reject). If rejected, wait for the agent to signal it is done, then re-send.

### Step 3.2: TeamDelete

```
TeamDelete("sigint-{topic_slug}-issues")
```

### Step 3.3: Suggest Next Steps

Based on what was just created:
- If issues created: "View them at https://github.com/{repo}/issues"
- If dry_run: "Run `/sigint:issues --repo {repo}` (without `--dry-run`) to create them"
- Next research action: "Use `/sigint:augment <area>` to deepen any gaps, or `/sigint:report` to generate the full report"
