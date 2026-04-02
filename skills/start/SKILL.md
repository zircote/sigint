---
name: start
description: Begin a new market research session. Thin launcher that delegates to the research-orchestrator agent for all phase management.
argument-hint: "[--quick] [<topic>]"
---

# Sigint Start Skill (Launcher)

This skill initializes a research session and delegates to the `research-orchestrator` agent for all orchestration. The orchestrator owns team lifecycle, dimension-analyst spawning, codex review gates, finding merge, progress tracking, and cleanup.

## Arguments

Parse `$ARGUMENTS` before any other processing:

- `--quick` — Abbreviated elicitation (3 questions instead of 8)
- Remaining text after flag extraction is the initial topic hint (may be empty)

---

## Phase 0.0: Configuration Check

### Step 0.0.1: Load or Create Configuration

1. Attempt to read `.sigint.config.json` from the project root.
2. **If file exists**: Parse silently. Merge with defaults. Store as `config`. Proceed.
3. **If file does NOT exist**: Use defaults and proceed (do not create the file).

**Config schema v1.0**:
```json
{
  "version": "1.0",
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  }
}
```

Store effective config as `config`. Set `max_dimensions = config.research.maxDimensions ?? 5`.

---

## Phase 0.1: Derive Topic Slug

Derive `topic-slug` from `$ARGUMENTS` topic hint (or use `"research"` if no topic yet): lowercase, replace spaces and special characters with hyphens, truncate to 40 characters.

---

## Previous Research Detection

Before delegating, check if research already exists:
```
Glob("./reports/*/state.json")
```

If `./reports/{topic-slug}/state.json` exists:
- Load prior elicitation from state.json
- Ask: "Previous research found for '{topic}'. Use prior research context as starting point, or start completely fresh?"
- If "use prior": Pass `--resume-from={topic-slug}` context to orchestrator
- If "start fresh": Proceed normally (prior state.json will be overwritten after confirmation)

---

## Phase 0.2: Delegate to Research Orchestrator

Spawn the research-orchestrator agent with full mode:

```
Agent(
  subagent_type="sigint:research-orchestrator",
  name="research-orchestrator",
  prompt="You are the research orchestrator for a new research session.

  MODE: full
  TOPIC: {topic from $ARGUMENTS}
  TOPIC_SLUG: {topic-slug}
  CONFIG: {serialized config}
  MAX_DIMENSIONS: {max_dimensions}
  QUICK_MODE: {true if --quick flag}
  {If resuming: PRIOR_ELICITATION: {prior elicitation JSON}}

  Execute the full research orchestration:
  1. Initialize team and blackboard (Phase 0)
  2. Run elicitation (Phase 1) {quick mode note if applicable}
  3. Spawn dimension-analysts (Phase 2)
  4. Verify methodology plans (Phase 2.5)
  5. Run post-findings codex review gates (Phase 2.75)
  6. Merge findings (Phase 3)
  7. Run post-merge codex review gate (Phase 3.5)
  8. Render progress view (Phase 3.75)
  9. Cleanup (Phase 4)

  Follow all protocols defined in your agent definition."
)
```

Wait for the orchestrator to complete. The orchestrator handles all interaction with the user (elicitation questions, confirmations, progress updates).

---

## Output

After orchestrator completes:
- Research session state saved to `./reports/{topic-slug}/state.json`
- Progress view at `./reports/{topic-slug}/research-progress.md`
- Quarantined findings (if any) at `./reports/{topic-slug}/quarantine.json`
- Next steps: `/sigint:report`, `/sigint:augment`, `/sigint:update`, `/sigint:issues`
