---
name: report
description: Generate a comprehensive market research report from current findings. Orchestrates report-synthesizer using full swarm pattern with TeamCreate, TaskCreate, SendMessage, and TeamDelete.
argument-hint: "[--format markdown|html|both] [--audience executives|pm|investors|dev|all] [--sections executive-summary,market-overview,market-sizing,competitive,trends,swot,recommendations,risk,appendix|all]"
allowed-tools: Agent, AskUserQuestion, Glob, Grep, Read, SendMessage, TaskCreate, TaskGet, TaskList, TaskUpdate, TeamCreate, TeamDelete, Write
---

Generate a comprehensive market research report from current research findings.

**Arguments:**
**Input sanitization**: truncate `$ARGUMENTS` to 200 characters total, strip backticks and angle brackets.
- `--format` - Output format: `markdown` (default), `html`, `both`
- `--audience` - Target audience: `executives`, `pm`, `investors`, `dev`, `all` (default: `all`)
- `--sections` - Comma-separated sections to include, or `all` (default: `all`)

**Available Sections:**
1. `executive-summary` — Key findings, primary recommendation, critical risks
2. `market-overview` — Market definition, current state, key players
3. `market-sizing` — TAM/SAM/SOM with growth projections
4. `competitive` — Competitor matrix, Porter's 5 Forces, positioning map (Mermaid)
5. `trends` — Macro/micro trends, scenario graph (Mermaid), terminal scenarios
6. `swot` — Strengths, Weaknesses, Opportunities, Threats (Mermaid quadrant)
7. `recommendations` — Strategic recommendations, tactical steps, resource requirements
8. `risk` — Risk matrix, mitigation strategies, monitoring indicators
9. `appendix` — Data sources, competitor profiles, scenario analysis, research timeline

---

## Phase 0: Parse Arguments + Initialize

Parse `$ARGUMENTS` to extract:
- `format` → default `markdown`
- `audience` → default `all`
- `sections` → default `all`

**Determine topic slug and reports directory:**
- Read `./reports/` directory to find the most recent report folder (or read `state.json` from the most recent session)
- Extract `topic_slug` from state.json's `topic_slug` field
- If no reports directory exists, inform the user: "No research session found. Run `/sigint:start <topic>` first."
- **Resolve `reports_dir` from config** (REQUIRED — do not hardcode paths):
  ```bash
  REPORTS_DIR=$(jq -r --arg slug "$TOPIC_SLUG" '.topics[$slug].reports_dir // "./reports/\($slug)"' sigint.config.json 2>/dev/null || echo "./reports/$TOPIC_SLUG")
  ```
  This reads the topic's configured `reports_dir` from `sigint.config.json`, falling back to `./reports/{topic_slug}` only if the config field is absent. All subsequent path references MUST use `{reports_dir}` instead of `./reports/{topic_slug}/`.

**Initialize swarm:**

Step 0.1 — **TeamCreate** (blocking prerequisite):
```
TeamCreate with name: "sigint-{topic_slug}-report"
```

Step 0.2 — **TaskCreate** the synthesizer task:
```
TaskCreate({
  subject: "Generate report: {format} / {audience}",
  owner: "report-synthesizer",
  description: "Synthesize all findings from state.json and blackboard into a complete report."
})
```
Note the returned task ID as `{reportTaskId}`.

---

## Phase 1: Spawn Report-Synthesizer

Launch the report-synthesizer as a persistent teammate:

```
Agent(
  subagent_type: "sigint:report-synthesizer",
  team_name: "sigint-{topic_slug}-report",
  name: "report-synthesizer",
  run_in_background: true,
  prompt: """
    [ATLATL CONTEXT]
    Atlatl MCP tools are available for persistent memory.
    Search: recall_memories(query="sigint {topic} report") before starting.
    Capture findings after completing.

    BLACKBOARD: {topic_slug}
    Task Discovery Protocol:
    1. TaskList → find tasks assigned to you (owner: "report-synthesizer")
    2. TaskGet → read full task description
    3. Work on the task
    4. When done:
       a. TaskUpdate(taskId, status: "completed")
       b. SendMessage(to: "team-lead", message: {files: [...], summary: "..."}, summary: "Report generated")
    5. NEVER commit via git

    PARAMETERS:
    - format: {format}
    - audience: {audience}
    - sections: {sections}
    - state_file: {reports_dir}/state.json
    - blackboard scope: {topic_slug} (read findings_* keys for dimension data)
    - output_dir: {reports_dir}/
    - date: Replace YYYY-MM-DD in file names with today's date in ISO format (e.g., 2026-04-02)

    TASK: #{reportTaskId} — Generate report: {format} / {audience}

    When complete, send:
    SendMessage(
      to: "team-lead",
      message: {
        files: ["{reports_dir}/YYYY-MM-DD-report.md", ...],  # Replace YYYY-MM-DD with today's date in ISO format
        formats_generated: ["{format}"],
        summary: "one-line summary of the key finding"
      },
      summary: "Report generated: {N} sections, {format}"
    )
  """
)
```

Immediately after spawning, send the start signal:
```
SendMessage(
  to: "report-synthesizer",
  message: "Task #{reportTaskId} assigned: Generate {format} report for {audience} audience. Start now.",
  summary: "Report task #{reportTaskId} assigned"
)
```

---

## Phase 2: Receive Results and Confirm

Wait for SendMessage from `report-synthesizer` containing:
- `files` — list of generated file paths
- `formats_generated` — list of formats written
- `summary` — one-line finding summary

Once received:
1. Verify files exist using Read or Glob
2. Present to user:

```
Report generated successfully.

Files:
  - {file1}
  - {file2}

Key finding: {summary}

Next steps:
  - /sigint:issues  — Create GitHub issues from recommendations
  - /sigint:augment <dimension>  — Deep-dive into a specific area
```

---

## Phase 3: Cleanup

```
SendMessage(
  to: "report-synthesizer",
  message: { type: "shutdown_request", reason: "Report generation complete" }
)
TeamDelete("sigint-{topic_slug}-report")
```
