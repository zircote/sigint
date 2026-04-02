---
name: update
description: Refresh existing research with latest data using swarm orchestration and delta detection. Delegates to the research-orchestrator agent in update mode.
argument-hint: "[--topic <slug>] [--area <area>] [--since <date>] [--no-delta] [--dimensions <dim1,dim2,...>]"
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
  - mcp__atlatl__blackboard_pending_alerts
  - mcp__atlatl__blackboard_read
  - mcp__atlatl__blackboard_write
  - mcp__atlatl__capture_memory
  - mcp__atlatl__enrich_memory
  - mcp__atlatl__recall_memories
---

# Sigint Update Skill (Swarm Orchestration)

This skill refreshes existing research by delegating to the research-orchestrator agent in update mode. The orchestrator spawns dimension-analysts for the specified dimensions, runs codex review gates, performs delta detection against prior findings, and updates state.

## Arguments

Parse `$ARGUMENTS` before any other processing. **Input sanitization**: truncate `$ARGUMENTS` to 200 characters total, strip backticks and angle brackets. Always echo the parsed result so the user sees what was resolved:

- `--topic <topic_slug>` — Optional: specify which research session to update. Required when multiple sessions exist.
- `--area <area>` — Optional: specific area to update. Maps to the matching dimension from prior elicitation (e.g., `--area regulatory` resolves to the dimension whose name contains "regulatory").
- `--since <date>` — Optional: SINCE_DATE for date-filtered queries. Only fetch data since this date.
- `--no-delta` — Disable delta detection (DELTA_ENABLED: false). By default, delta detection is enabled (DELTA_ENABLED: true).
- `--dimensions <dim1,dim2,...>` — Optional: comma-separated list of specific dimensions to update. Only these are passed to the orchestrator, not all dimensions.

---

## Phase 0: Pre-flight

### Step 0.1: Locate Active Research Session

Find the active research state:
```
Glob("./reports/*/state.json")
```

If no state.json found:
1. Inform user: "No active research session found. Use `/sigint:start` to begin."
2. Show what the update would have done based on the parsed arguments. Use this exact format:

   **Planned update workflow (blocked — no session data):**
   - **Topic**: {from --topic, or "auto-detect from single session"}
   - **Dimensions**: {from --dimensions listing each one, or --area mapped to its matching dimension, or "all dimensions from prior elicitation"}
   - **SINCE_DATE**: {from --since, or "none (fetch all available data)"}
   - **DELTA_ENABLED**: {"false — findings would be replaced wholesale (--no-delta specified)" if --no-delta, or "true — delta detection would classify findings as NEW, UPDATED, CONFIRMED, POTENTIALLY_REMOVED, or TREND_REVERSAL"}
   - **Orchestrator**: research-orchestrator would be spawned in MODE: update
   - **Elicitation**: Prior elicitation from state.json would be reused (not re-run)
   - **Reconciliation**: {If DELTA_ENABLED: "Reconcile merge — replace updated findings, archive removed, add new (not append blindly). A new lineage entry would be added." | If not: "Wholesale replacement — findings replaced entirely, no reconciliation against prior findings."}

3. Stop execution. Do NOT proceed further.

If multiple sessions found:
- If `--topic` was provided: select that topic_slug
- Otherwise: list all available sessions and ask the user to choose which one to update. Output: "Multiple sessions found. Please specify which session to update." Do NOT arbitrarily pick one.

### Step 0.2: Load Prior State

Read `./reports/{topic_slug}/state.json` (where `topic_slug` is resolved from `--topic` argument, single-session auto-detect, or user selection). Extract:
- `topic`, `topic_slug`
- `elicitation` (reuse for dimension-analysts)
- `findings[]` (for delta detection baseline)
- `lineage[]` (to append new entry)
- Prior `dimensions` list

### Step 0.3: Resolve Dimensions

Priority order for which dimensions to update:
1. `--dimensions` argument (if provided)
2. `--area` mapped to dimension (if provided)
3. All dimensions from prior `elicitation.dimensions`

---

## Phase 1: Delegate to Research Orchestrator

Spawn the research-orchestrator in update mode:

```
Agent(
  subagent_type="sigint:research-orchestrator",
  name="research-orchestrator",
  prompt="You are the research orchestrator for a research UPDATE session.

  MODE: update
  TOPIC: <user_input>{topic}</user_input>
  TOPIC_SLUG: {topic_slug}
  DIMENSIONS: {resolved dimensions list}
  SINCE_DATE: {--since value or null}
  DELTA_ENABLED: {false if --no-delta, otherwise true}
  PRIOR_STATE: {summary of prior state — finding count, dimensions, last updated}
  ELICITATION: {prior elicitation JSON from state.json}

  Execute the update orchestration:
  1. Initialize team and blackboard (Phase 0) — reuse topic_slug
  2. Skip elicitation — load from ELICITATION above
  3. Write elicitation to blackboard for analysts
  4. Spawn dimension-analysts for DIMENSIONS (Phase 2)
  5. Verify methodology plans (Phase 2.5)
  6. Run post-findings codex review gates (Phase 2.75)
  7. Run delta detection BEFORE merge (Delta Protocol) — classify findings as NEW/UPDATED/CONFIRMED/POTENTIALLY_REMOVED/TREND_REVERSAL
  8. Reconcile merge (Phase 3.4) — replace updated, archive removed, add new. Do NOT append blindly; reconcile against prior findings.
  9. Run post-merge codex review gate (Phase 3.5)
  10. Render progress view (Phase 3.75)
  11. Cleanup (Phase 4)

  IMPORTANT: Include SINCE_DATE context in analyst spawn prompts so they
  prioritize recent data. Analysts should use date-filtered WebSearch queries.

  Follow all protocols defined in your agent definition."
)
```

Wait for orchestrator to complete.

---

## Error Handling

**If orchestrator doesn't complete within a reasonable time:**
1. Check for partial results: `Glob("./reports/{topic_slug}/findings_*.json")`
2. If findings files exist → orchestrator made progress. Check `research-progress.md` for last phase.
3. If no findings → inform user: "Update session did not complete. You can retry with `/sigint:update`."

---

## Output

After orchestrator completes:
- Updated findings in `./reports/{topic_slug}/state.json` with new lineage entry
- Delta report at `./reports/{topic_slug}/YYYY-MM-DD-delta.md` (if delta enabled)
- Updated `./reports/{topic_slug}/research-progress.md`
- Quarantined findings (if any) at `./reports/{topic_slug}/quarantine.json`
- Summary of what changed: new, updated, confirmed, removed findings
- Trend reversals highlighted
- Next steps: `/sigint:report`, `/sigint:augment`
