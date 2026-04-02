---
title: Config Resolution Protocol
type: protocol
version: 2.0
---

# Config Resolution Protocol

This protocol defines how sigint resolves configuration for a given research session. All skills that need config values MUST use this protocol instead of inlining custom config loading.

## Steps

### Step 1: Load config files (silent, best-effort)

Read both config files if they exist. Silently ignore missing files.

  project_config = Read("./sigint.config.json") → parse as JSON  (or {} if missing/invalid)
  global_config  = Read("~/.claude/sigint.config.json") → parse as JSON  (or {} if missing/invalid)

> Read is acceptable here — comprehension-only reads to inform config cascade decisions, per Structured Data Protocol (`protocols/STRUCTURED-DATA.md`).

### Step 2: Version check (warn-only)

If project_config.version is defined and is NOT "2.0":
  Warn: "sigint.config.json is schema v{version}. Run /sigint:migrate to upgrade."
  Continue regardless — the warning is advisory only. All config values from the file are still applied in Step 3's cascade. Do NOT discard config values based on schema version.

### Step 3: Resolve all fields

Apply the cascade (topic-specific → project defaults → global defaults → hardcoded defaults) for every field.
Store the full resolved object as `config` (shape defined in configuration.md reference).
Set `max_dimensions = config.research.maxDimensions`.

### Step 4: Load context file (if applicable)

If config.context_file is non-null:
  context_content = Read(config.context_file)
  If file missing: warn "CONTEXT.md not found at {config.context_file} — proceeding without topic context." Set context_content = null.
Else:
  context_content = null

## Outputs

After protocol completion, the following are available:
- `config` — full resolved config object
- `project_config` — raw parsed project config (for inspecting topics count, etc.)
- `max_dimensions` — integer shorthand
- `context_content` — string or null
