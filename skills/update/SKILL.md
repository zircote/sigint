---
name: update
description: Refresh existing research with latest data using swarm orchestration and delta detection. Delegates to the research-orchestrator agent in update mode.
argument-hint: "[--area <specific-area>] [--since <date>] [--delta] [--dimensions <dim1,dim2,...>]"
---

# Sigint Update Skill (Swarm Orchestration)

This skill refreshes existing research by delegating to the research-orchestrator agent in update mode. The orchestrator spawns dimension-analysts for the specified dimensions, runs codex review gates, performs delta detection against prior findings, and updates state.

## Arguments

Parse `$ARGUMENTS` before any other processing:

- `--area <area>` — Optional: specific area to update (maps to a dimension)
- `--since <date>` — Optional: only fetch data since this date
- `--delta` — Enable delta detection (compare against prior findings). Default: enabled.
- `--dimensions <dim1,dim2,...>` — Optional: comma-separated dimensions to update. Default: all dimensions from prior research.

---

## Phase 0: Pre-flight

### Step 0.1: Locate Active Research Session

Find the active research state:
```
Glob("./reports/*/state.json")
```

If no state.json found: inform user "No active research session found. Use `/sigint:start` to begin." and stop.

If multiple sessions found: list them and ask user to specify (or use `--area` to resolve).

### Step 0.2: Load Prior State

Read `./reports/{topic-slug}/state.json`. Extract:
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
  DELTA_ENABLED: {true unless --delta=false}
  PRIOR_STATE: {summary of prior state — finding count, dimensions, last updated}
  ELICITATION: {prior elicitation JSON from state.json}

  Execute the update orchestration:
  1. Initialize team and blackboard (Phase 0) — reuse topic-slug
  2. Skip elicitation — load from ELICITATION above
  3. Write elicitation to blackboard for analysts
  4. Spawn dimension-analysts for DIMENSIONS (Phase 2)
  5. Verify methodology plans (Phase 2.5)
  6. Run post-findings codex review gates (Phase 2.75)
  7. Merge findings (Phase 3)
  8. Run post-merge codex review gate (Phase 3.5)
  9. Run delta detection against prior findings (Delta Protocol)
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
