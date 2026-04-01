---
name: update
description: Refresh existing research with latest data using swarm orchestration and delta detection. Delegates to the research-orchestrator agent in update mode.
argument-hint: "[--topic <slug>] [--area <area>] [--since <date>] [--no-delta] [--dimensions <dim1,dim2,...>]"
---

# Sigint Update Skill (Swarm Orchestration)

This skill refreshes existing research by delegating to the research-orchestrator agent in update mode. The orchestrator spawns dimension-analysts for the specified dimensions, runs codex review gates, performs delta detection against prior findings, and updates state.

## Arguments

Parse `$ARGUMENTS` before any other processing:

- `--topic <topic-slug>` — Optional: specify which research session to update. Required when multiple sessions exist.
- `--area <area>` — Optional: specific area to update (maps to a dimension)
- `--since <date>` — Optional: only fetch data since this date
- `--no-delta` — Disable delta detection. By default, delta detection is enabled for all updates.
- `--dimensions <dim1,dim2,...>` — Optional: comma-separated dimensions to update. Default: all dimensions from prior research.

---

## Phase 0: Pre-flight

### Step 0.1: Locate Active Research Session

Find the active research state:
```
Glob("./reports/*/state.json")
```

If no state.json found: inform user "No active research session found. Use `/sigint:start` to begin." and stop.

If multiple sessions found:
- If `--topic` was provided: use that topic-slug
- Otherwise: list all sessions and ask user to specify

### Step 0.2: Load Prior State

Read `./reports/{topic-slug}/state.json` (where `topic-slug` is resolved from `--topic` argument, single-session auto-detect, or user selection). Extract:
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
  TOPIC: {topic}
  TOPIC_SLUG: {topic-slug}
  DIMENSIONS: {resolved dimensions list}
  SINCE_DATE: {--since value or null}
  DELTA_ENABLED: {false if --no-delta, otherwise true}
  PRIOR_STATE: {summary of prior state — finding count, dimensions, last updated}
  ELICITATION: {prior elicitation JSON from state.json}

  Execute the update orchestration:
  1. Initialize team and blackboard (Phase 0) — reuse topic-slug
  2. Skip elicitation — load from ELICITATION above
  3. Write elicitation to blackboard for analysts
  4. Spawn dimension-analysts for DIMENSIONS (Phase 2)
  5. Verify methodology plans (Phase 2.5)
  6. Run post-findings codex review gates (Phase 2.75)
  7. Run delta detection BEFORE merge (Delta Protocol) — classify findings as NEW/UPDATED/CONFIRMED/POTENTIALLY_REMOVED
  8. Reconcile merge (Phase 3.4) — replace updated, archive removed, add new. Do NOT append blindly.
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

## Output

After orchestrator completes:
- Updated findings in `./reports/{topic-slug}/state.json` with new lineage entry
- Delta report at `./reports/{topic-slug}/YYYY-MM-DD-delta.md` (if delta enabled)
- Updated `./reports/{topic-slug}/research-progress.md`
- Quarantined findings (if any) at `./reports/{topic-slug}/quarantine.json`
- Summary of what changed: new, updated, confirmed, removed findings
- Trend reversals highlighted
- Next steps: `/sigint:report`, `/sigint:augment`
