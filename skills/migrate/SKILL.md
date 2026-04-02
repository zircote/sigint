---
name: migrate
description: Migrate legacy sigint configuration (sigint.local.md or .sigint.config.json v1.0) to sigint.config.json v2.0 with per-topic support. Safe, idempotent, supports dry-run preview.
argument-hint: "[--dry-run] [--global]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash
  - AskUserQuestion
---

# Sigint Migrate Skill

Migrates legacy sigint configuration to the v2.0 JSON format with per-topic support. Safe to run multiple times (idempotent). Always backs up source files before overwriting.

## Arguments

Parse `$ARGUMENTS`:
- `--dry-run` → `dry_run = true` — preview what would be written, no files modified
- `--global` → `migrate_global = true` — also migrate `~/.claude/sigint.local.md` (default: project only)

---

## Phase 0: Detect Source Files

### Step 0.1: Inventory legacy config files

Check for each (silent, no errors if missing):
- `project_local_md` — `./.claude/sigint.local.md` exists
- `global_local_md` — `~/.claude/sigint.local.md` exists (relevant only if migrate_global)
- `project_config_v1` — `./.sigint.config.json` exists and its version field is "1.0"
- `target_exists` — `./sigint.config.json` exists

### Step 0.2: Check for existing v2.0 target

If `./sigint.config.json` exists:
- Parse it. If version == "2.0":
  ```
  AskUserQuestion(
    question: "sigint.config.json v2.0 already exists. How would you like to proceed?",
    options: [
      "Merge: add missing topics from legacy config, preserve existing topic customizations",
      "Overwrite: replace entirely with freshly migrated config",
      "Cancel"
    ]
  )
  ```
  Store as `merge_mode` ("merge", "overwrite", or cancel/exit).
- If version != "2.0": treat as overwrite.

### Step 0.3: Early exit if nothing to migrate

If no source files found AND no v1.0 target:
- Output: "Nothing to migrate. No legacy config files found."
- Output: "To create a fresh config, run /sigint:init."
- Exit.

---

## Phase 1: Parse Legacy Sources

### Step 1.1: Parse project sigint.local.md (if exists)

Read `./.claude/sigint.local.md`. Extract YAML frontmatter:
- `default_repo` (string or null)
- `report_format` (string or null)
- `audiences` (array or null)
- `auto_atlatl` (boolean or null)

Extract markdown body (everything after closing `---` separator). Store as `local_md_body`.

### Step 1.2: Parse global sigint.local.md (if migrate_global AND exists)

Same extraction from `~/.claude/sigint.local.md`. Store as `global_defaults_raw`.

### Step 1.3: Parse .sigint.config.json v1.0 (if exists)

Read and parse. Extract `research.maxDimensions`, `research.dimensionTimeout`, `research.defaultPriorities`. Store as `v1_research_config`.

### Step 1.4: Discover existing topics from reports

```
Glob("./reports/*/state.json")
```

For each match, read and extract `topic_slug` (from directory name in glob path) and `topic` (human-readable name from state.json). Store as `discovered_topics`.

---

## Phase 2: Build v2.0 Config

### Step 2.1: Construct defaults block

```json
"defaults": {
  "default_repo": <project_local_md.default_repo ?? null>,
  "report_format": <project_local_md.report_format ?? "markdown">,
  "audiences": <project_local_md.audiences ?? ["technical"]>,
  "auto_atlatl": <project_local_md.auto_atlatl ?? true>
}
```

### Step 2.2: Construct research block

```json
"research": {
  "maxDimensions": <v1_research_config.maxDimensions ?? 5>,
  "dimensionTimeout": <v1_research_config.dimensionTimeout ?? 300>,
  "defaultPriorities": <v1_research_config.defaultPriorities ?? ["competitive", "sizing", "trends"]>
}
```

### Step 2.3: Construct topics block

For each `{slug, name}` in `discovered_topics`:
```json
"<slug>": {
  "context_file": "./reports/<slug>/CONTEXT.md"
}
```

If merge_mode == "merge": preserve all existing topic entries from current v2.0 config; only add newly discovered slugs not already present.

### Step 2.4: Assemble complete v2.0 config

```json
{ "version": "2.0", "defaults": ..., "research": ..., "topics": ... }
```

---

## Phase 3: Plan CONTEXT.md Files

For each discovered topic:
- Path: `./reports/{slug}/CONTEXT.md`
- Content: `local_md_body` if non-empty, else:
  ```markdown
  # Research Context: {topic name}

  <!-- Add project-specific context, constraints, or background here -->
  ```
- If CONTEXT.md already exists at that path: mark as "skip — already exists".

---

## Phase 4: Preview and Confirm

### Step 4.1: Display migration plan

```
Sigint Configuration Migration Plan
=====================================

Sources detected:
  {[found] or [not found]} .claude/sigint.local.md (project)
  {[found] or [not found]} ~/.claude/sigint.local.md (global)
  {[found] or [not found]} .sigint.config.json (v1.0)

Target: ./sigint.config.json (v2.0) — {create fresh | merge with existing | overwrite existing}

Topics to register ({count}): {slug list}

Files to write:
  [CREATE or UPDATE] ./sigint.config.json
  {for each new CONTEXT.md: "  [CREATE] ./reports/{slug}/CONTEXT.md"}
  {for each skipped CONTEXT.md: "  [SKIP — exists] ./reports/{slug}/CONTEXT.md"}

Files to back up:
  {for each source: "  {source} → {source}.bak"}

Resolved defaults:
  default_repo:   {value or "not set"}
  report_format:  {value}
  audiences:      {value}
  auto_atlatl:    {value}
  maxDimensions:  {value}
```

If `dry_run = true`:
```
DRY RUN — no files modified. Remove --dry-run to execute.
```
Exit after preview.

If `dry_run = false`:
```
AskUserQuestion(
  question: "Proceed with migration?",
  options: ["Proceed", "Cancel"]
)
```

---

## Phase 5: Execute Migration

(Skipped if dry_run = true.)

### Step 5.1: Write CONTEXT.md files

For each topic where CONTEXT.md does not already exist:
```
Write("./reports/{slug}/CONTEXT.md", content)
```

### Step 5.2: Write sigint.config.json

```
Write("./sigint.config.json", formatted JSON of v2_config)
```

### Step 5.3: Rename legacy files to .bak

```
Bash: mv ./.claude/sigint.local.md ./.claude/sigint.local.md.bak  (if existed)
Bash: mv ./.sigint.config.json ./.sigint.config.json.bak  (if existed)
If migrate_global AND ~/.claude/sigint.local.md exists:
  Bash: mv ~/.claude/sigint.local.md ~/.claude/sigint.local.md.bak
```

### Step 5.4: Update .gitignore

Read `.gitignore`. Find the `.claude/sigint.local.md` entry:
- Replace it with `sigint.config.json`
- If not found, append:
  ```
  # Sigint local config (contains user-specific settings)
  sigint.config.json
  ```

---

## Phase 6: Completion Output

```
Migration complete.

Written:
  sigint.config.json (v2.0)
  {each CONTEXT.md written}

Backed up:
  {each .bak file created}

{count} topic(s) registered: {slug list}

Next steps:
  - Review ./sigint.config.json and add per-topic customizations
  - Edit ./reports/{slug}/CONTEXT.md to add project-specific context
  - Run /sigint:init to verify configuration
  - Run /sigint:start <topic> to begin a research session
```
