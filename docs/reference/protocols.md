---
diataxis_type: reference
title: Protocols Reference
description: Cross-cutting protocols for structured data handling and configuration resolution
---

# Protocols Reference

Sigint defines two cross-cutting protocols that all agents and skills must follow. These protocols are not optional -- they are mandatory operating procedures enforced at every pipeline stage.

## Structured Data Protocol

**Source**: `protocols/STRUCTURED-DATA.md` (v2.0)

Defines how all sigint agents handle JSON file operations. Derived from the `/refactor:xq` structured data reliability patterns.

### Core mandate

All `.json` file creation, mutation, and extraction must use `jq` via Bash. The `Edit` tool and `Write` tool are prohibited for JSON operations. Shell string interpolation for JSON construction is prohibited.

### Permitted operations

| Operation | Tool | When |
|-----------|------|------|
| Create JSON file | `jq -n '{...}' > file.json` | Always |
| Mutate JSON file | `jq '.key = "val"' file.json > tmp.$$ && mv tmp.$$ file.json` | Always |
| Extract fields | `jq '.field' file.json` | Always |
| Comprehension-only read | `Read` tool | Understanding file structure, not transforming |

### Variable interpolation

| Type | jq Flag | Example |
|------|---------|---------|
| String | `--arg` | `jq --arg v "$VAL" '.key = $v'` |
| Number/Bool/Object | `--argjson` | `jq --argjson n 42 '.count = $n'` |
| File content | `--rawfile` | `jq --rawfile desc file.txt '.desc = $desc'` |

Never embed shell variables directly in jq expressions.

### Atomic writes

jq cannot write in-place. Always use the temp-file pattern:

```bash
jq '<expr>' file.json > tmp.$$ && mv tmp.$$ file.json
```

### Schema registry

Every JSON file type has a corresponding schema validator in `schemas/`. Validation is mandatory after every write or mutation.

| File Pattern | Schema File | Writer(s) |
|---|---|---|
| `sigint.config.json` | `schemas/sigint-config.jq` | init, migrate |
| `state.json` | `schemas/state.jq` | orchestrator, augment |
| `findings_{dim}.json` | `schemas/findings.jq` | dimension-analyst |
| `elicitation.json` | `schemas/elicitation.jq` | orchestrator |
| `methodology_plan_{dim}.json` | `schemas/methodology-plan.jq` | dimension-analyst |
| `findings_{dim}_reflection.json` | `schemas/reflection.jq` | dimension-analyst |
| `quarantine.json` | `schemas/quarantine.jq` | orchestrator |
| `merged_findings.json` | `schemas/merged-findings.jq` | orchestrator |
| `YYYY-MM-DD-report-metadata.json` | `schemas/report-metadata.jq` | report-synthesizer |
| `YYYY-MM-DD-issues.json` | `schemas/issues.jq` | issue-architect |
| `issues-dry-run.json` | `schemas/issues.jq` | issue-architect |
| `team_status.json` | `schemas/team-status.jq` | orchestrator |
| `conflicts.json` | `schemas/conflicts.jq` | dimension-analyst, orchestrator |
| `findings_hashes.json` | inline (`to_entries \| all(.value \| type == "string")`) | orchestrator |

### Write-then-validate pattern

Every JSON write must be immediately followed by schema validation:

```bash
# Step 1: Write or mutate
jq -n '{...}' > "$FILE"

# Step 2: Validate (mandatory)
jq -e -f "schemas/${SCHEMA}.jq" "$FILE" > /dev/null
```

### Retry-and-correct on validation failure

If schema validation fails, the agent must not continue the pipeline. Instead:

1. **Diagnose**: Run the validator with full output to identify the failing assertion
2. **Correct**: Use jq to fix the data in-place (missing fields, wrong types, missing nested structures)
3. **Re-validate**: Run the schema check again
4. **Retry limit**: Maximum 2 correction attempts. If validation still fails after 2 fixes, log the failure, write a `.invalid` sidecar, and report the error. Do not proceed with invalid data.

---

## Config Resolution Protocol

**Source**: `protocols/CONFIG-RESOLUTION.md` (v2.0)

Defines how sigint resolves configuration for a research session. All skills that need config values must use this protocol.

### Resolution steps

**Step 1: Load config files** (silent, best-effort)

Read both config files if they exist. Silently ignore missing files.

```
project_config = Read("./sigint.config.json")   (or {} if missing/invalid)
global_config  = Read("~/.claude/sigint.config.json")   (or {} if missing/invalid)
```

**Step 2: Version check** (warn-only)

If `project_config.version` is defined and is not `"2.0"`, warn the user to run `/sigint:migrate`. Continue regardless -- the warning is advisory. Config values are still applied.

**Step 3: Resolve all fields**

Apply the cascade for every field:

1. Topic-specific -- `topics[<topic_slug>].<field>` in project config
2. Project defaults -- `defaults.<field>` in project config
3. Global defaults -- `defaults.<field>` in global config
4. Hardcoded default -- built-in value

Store the full resolved object as `config`. Set `max_dimensions = config.research.maxDimensions`.

**Step 4: Load context file** (if applicable)

If `config.context_file` is non-null, read the file. If missing, warn and set `context_content = null`.

### Protocol outputs

After completion, the following are available:

| Output | Type | Description |
|--------|------|-------------|
| `config` | object | Full resolved config |
| `project_config` | object | Raw parsed project config |
| `max_dimensions` | integer | Shorthand for `config.research.maxDimensions` |
| `context_content` | string or null | Contents of the context file |

## See also

- [Configuration Reference](configuration.md)
- [Architecture](../explanation/architecture.md)
- [Troubleshooting: Schema Validation](../how-to/troubleshooting.md#schema-validation-failures)
