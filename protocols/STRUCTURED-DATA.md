---
title: Structured Data Protocol
type: protocol
version: 2.0
---

# Structured Data Protocol

This protocol defines how sigint agents handle JSON file operations. All agents that read, write, mutate, or validate `.json` files MUST follow this protocol. Derived from the `/refactor:xq` structured data reliability skill.

## Scope

**In scope** — all `.json` files produced or consumed by sigint:
- `state.json` — session state with findings, sources, and lineage
- `findings_{dimension}.json` — per-dimension research findings
- `elicitation.json` — user research context
- `quarantine.json` — codex-rejected findings
- `merged_findings.json` — consolidated post-merge findings
- `methodology_plan_{dimension}.json` — skill metadata per dimension
- `sigint.config.json` — project and global configuration
- `YYYY-MM-DD-report-metadata.json` — report generation metadata
- `YYYY-MM-DD-issues.json` / `issues-dry-run.json` — issue manifests
- `team_status.json` — team coordination status
- `conflicts.json` — cross-dimension conflicts
- `findings_hashes.json` — dimension-level SHA-256 hashes for incremental merge skip

**Out of scope:**
- YAML frontmatter in `.md` files (embedded structured data in non-structured files)
- Markdown, HTML, and plain-text files
- `plugin.json` (read-only, never mutated by agents)

## Core Rules

**Use `jq` via Bash for all JSON file operations:**
- Creating new JSON files
- Mutating existing JSON files (adding, updating, deleting keys)
- Extracting specific fields from JSON files
- Validating JSON structure after writes

**Use `Read` tool ONLY for:**
- Comprehension-only reads — understanding overall file structure to inform decisions
- Reading small config files for context (not extracting or transforming)

**NEVER:**
- Use `Write` tool to output JSON content
- Use `Edit` tool to modify JSON key-value pairs
- Construct JSON via shell string interpolation or concatenation
- Embed shell variables directly in jq expressions (use `--arg`/`--argjson`)
- Skip schema validation after a write or mutation

## Prerequisite

Agents using this protocol MUST have `Bash` in their tools list. If Bash is unavailable (e.g., read-only commands), `Read` for comprehension is the only permitted JSON operation.

---

## Schema Registry

Every JSON file type has a corresponding schema validator in `schemas/`. Schema validation is **MANDATORY** after every write or mutation — not optional, not best-effort.

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

### Mandatory Write-Then-Validate Pattern

Every JSON file write or mutation MUST be immediately followed by schema validation. This is the **required** two-step pattern — a write without validation is incomplete:

```bash
# Step 1: Write or mutate with jq
jq -n '{...}' > "$FILE"
# — or —
jq '.key = "val"' "$FILE" > tmp.$$ && mv tmp.$$ "$FILE"

# Step 2: MANDATORY schema validation (MUST follow every write)
jq -e -f "schemas/${SCHEMA}.jq" "$FILE" > /dev/null
```

### Retry-and-Correct on Validation Failure

**If schema validation fails, the agent MUST NOT continue the pipeline.** Instead, follow this protocol:

1. **Diagnose**: Run the schema validator with full output to see what failed:
   ```bash
   jq -f "schemas/${SCHEMA}.jq" "$FILE"
   ```
   This prints `false` for the overall check. To pinpoint the failing assertion, extract and test individual fields:
   ```bash
   jq 'has("required_key")' "$FILE"
   jq '.field | type' "$FILE"
   ```

2. **Correct**: Use jq to fix the data in-place. Common fixes:
   - Missing required field: `jq '.missing_field = "default"' "$FILE" > tmp.$$ && mv tmp.$$ "$FILE"`
   - Wrong type: `jq '.field = (.field | tostring)' "$FILE" > tmp.$$ && mv tmp.$$ "$FILE"`
   - Missing nested structure: `jq '.finding.provenance //= {claim:"",sources:[],derivation:"direct_quote"}' "$FILE" > tmp.$$ && mv tmp.$$ "$FILE"`

3. **Re-validate**: Run the schema check again:
   ```bash
   jq -e -f "schemas/${SCHEMA}.jq" "$FILE" > /dev/null
   ```

4. **Retry limit**: Maximum **2 correction attempts**. If validation still fails after 2 fixes:
   - Log the failure and schema output to `./reports/{topic_slug}/research-progress.md`
   - Write the invalid file to a `.invalid` sidecar: `cp "$FILE" "${FILE}.invalid"`
   - Report the failure to the team lead via SendMessage (if in a team) or directly to the user
   - **Do NOT proceed with invalid data in the pipeline**

This is not optional error handling — it is the required response to any schema validation failure.

### Schema Resolution

To determine which schema applies, match the file name:

```
state.json                         → schemas/state.jq
findings_*.json                    → schemas/findings.jq
*_reflection.json                  → schemas/reflection.jq
elicitation.json                   → schemas/elicitation.jq
methodology_plan_*.json            → schemas/methodology-plan.jq
quarantine.json                    → schemas/quarantine.jq
merged_findings.json               → schemas/merged-findings.jq
*-report-metadata.json             → schemas/report-metadata.jq
*-issues.json / issues-dry-run.json → schemas/issues.jq
team_status.json                   → schemas/team-status.jq
conflicts.json                     → schemas/conflicts.jq
sigint.config.json                 → schemas/sigint-config.jq
findings_hashes.json               → inline (to_entries | all(.value | type == "string"))
```

---

## File-First Write Pattern

File writes are the authoritative persistence path. Always write to file first, then validate.

```bash
# Step 1: File write (MANDATORY — must use jq)
echo "$JSON_DATA" | jq '.' > "./reports/{topic_slug}/{key}.json"

# Step 2: MANDATORY schema validation — STOP CHECK before proceeding
jq -e -f "schemas/${SCHEMA}.jq" "./reports/{topic_slug}/{key}.json" > /dev/null || {
  echo "SCHEMA VIOLATION: {key}.json failed validation"
  exit 1
}
```

---

## Recipes

### A. Create New JSON File

```bash
jq -n \
  --arg topic "$TOPIC" \
  --arg slug "$TOPIC_SLUG" \
  --arg date "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{
    topic: $topic,
    topic_slug: $slug,
    started: $date,
    status: "active",
    phase: "discovery",
    elicitation: {},
    findings: [],
    sources: [],
    lineage: []
  }' > "./reports/$TOPIC_SLUG/state.json"

# Validate
jq -e -f schemas/state.jq "./reports/$TOPIC_SLUG/state.json" > /dev/null
```

### B. Append to Array Field

```bash
jq --argjson entry "$ENTRY_JSON" \
  '.lineage += [$entry]' \
  "./reports/$SLUG/state.json" > tmp.$$ && mv tmp.$$ "./reports/$SLUG/state.json"

# Validate
jq -e -f schemas/state.jq "./reports/$SLUG/state.json" > /dev/null
```

### C. Update Scalar Fields

```bash
jq --arg phase "complete" \
   --arg updated "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '.phase = $phase | .last_updated = $updated' \
  "./reports/$SLUG/state.json" > tmp.$$ && mv tmp.$$ "./reports/$SLUG/state.json"

# Validate
jq -e -f schemas/state.jq "./reports/$SLUG/state.json" > /dev/null
```

### D. Merge Findings (Append Array + Update Fields)

Use `--slurpfile` with temp files for findings and sources arrays. Shell `ARG_MAX` (1MB on macOS) cannot hold large arrays as `--argjson` command-line arguments.

```bash
echo "$NEW_FINDINGS_JSON" | jq '.' > /tmp/sigint_findings_$$.json
echo "$NEW_SOURCES_JSON" | jq '.' > /tmp/sigint_sources_$$.json
jq --slurpfile new_findings /tmp/sigint_findings_$$.json \
   --slurpfile new_sources /tmp/sigint_sources_$$.json \
   --arg phase "complete" \
   --arg updated "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '.findings += $new_findings[0] | .sources += $new_sources[0] | .phase = $phase | .last_updated = $updated' \
  "./reports/$SLUG/state.json" > tmp.$$ && mv tmp.$$ "./reports/$SLUG/state.json"
rm -f /tmp/sigint_findings_$$.json /tmp/sigint_sources_$$.json

# Validate
jq -e -f schemas/state.jq "./reports/$SLUG/state.json" > /dev/null
```

### E. Extract Specific Fields

```bash
jq '{topic, topic_slug, phase, elicitation}' "./reports/$SLUG/state.json"
```

### F. Write Object to File (from variable)

```bash
echo "$FINDINGS_JSON" | jq '.' > "./reports/$SLUG/findings_${DIMENSION}.json"

# Validate
jq -e -f schemas/findings.jq "./reports/$SLUG/findings_${DIMENSION}.json" > /dev/null
```

### G. Conditional Create vs Append (Quarantine)

```bash
if [ -f "./reports/$SLUG/quarantine.json" ]; then
  jq --argjson items "$NEW_ITEMS" '.items += $items' \
    "./reports/$SLUG/quarantine.json" > tmp.$$ && mv tmp.$$ "./reports/$SLUG/quarantine.json"
else
  jq -n --arg date "$(date -u +%Y-%m-%dT%H:%M:%SZ)" --argjson items "$NEW_ITEMS" \
    '{quarantined_at: $date, items: $items}' \
    > "./reports/$SLUG/quarantine.json"
fi

# Validate
jq -e -f schemas/quarantine.jq "./reports/$SLUG/quarantine.json" > /dev/null
```

---

## Variable Interpolation

| Type | jq Flag | Example |
|------|---------|---------|
| String | `--arg` | `jq --arg v "$VAL" '.key = $v'` |
| Number/Bool/Object | `--argjson` | `jq --argjson n 42 '.count = $n'` |
| File content | `--rawfile` | `jq --rawfile desc file.txt '.desc = $desc'` |

**Never** embed shell variables directly in jq expressions: `jq ".key = \"$VAL\""` is unsafe.

## Atomic Writes

jq cannot write in-place. Always use the temp-file pattern:

```bash
jq '<expr>' file.json > tmp.$$ && mv tmp.$$ file.json
```

**Never** redirect to the same file: `jq '<expr>' file.json > file.json` destroys the file.
