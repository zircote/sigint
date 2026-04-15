# CLAUDE.md — sigint

This is the **sigint tool repo** — the plugin that runs market research orchestrations. It is NOT a research output corpus.

## Repo Topology

All paths are relative to the repo root:

- `agents/` — agent definitions (research-orchestrator, dimension-analyst, source-chunker, issue-architect, report-synthesizer)
- `schemas/` — jq validation schemas (state.jq, findings.jq, elicitation.jq, etc.)
- `protocols/` — operational protocols (CONFIG-RESOLUTION.md, STRUCTURED-DATA.md, TREND-INDICATORS.md)
- `skills/` — user-invocable skill definitions (start, update, augment, report, issues, etc.)
- `commands/` — slash command entry points that delegate to skills
- `hooks/` — harness hooks
- `evals/` — evaluation suites for agents and orchestration
- `reports/` — research output (per-topic subdirectories with findings, state, progress)
- `docs/` — explanation and how-to guides

## Consumer repo context

When sigint is installed as a plugin in a different repo (e.g. a research corpus), the orchestrator runs with CWD set to that repo — not this one. All `schemas/`, `protocols/`, and `agents/` references are relative to this repo root. Spawned agents must resolve the plugin root before using these paths. See zircote/sigint#7 for the tracking issue.

## Quality gates

```bash
# Schema validation (every JSON write must be followed by this)
jq -e -f schemas/<schema>.jq <file>.json > /dev/null

# Eval suite
cd evals && ./run.sh
```

## Structured data rule

All JSON file I/O (create, mutate, extract) must use `jq` via Bash per `protocols/STRUCTURED-DATA.md`. `Read` is acceptable for comprehension-only reads. Every write must be schema-validated immediately.
