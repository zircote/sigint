---
diataxis_type: how-to
title: Migrate Configuration
description: How to migrate from legacy sigint.local.md or v1.0 config to sigint.config.json v2.0
---

# Migrate Configuration

How to convert legacy `sigint.local.md` or `.sigint.config.json` v1.0 to the current `sigint.config.json` v2.0 format.

## When to migrate

Migrate if you have any of these legacy config files:

- `.claude/sigint.local.md` (project or global)
- `.sigint.config.json` with `"version": "1.0"`

Sigint will warn you on startup if it detects a non-v2.0 config.

## Preview the migration (dry run)

See what would change without modifying any files:

```
/sigint:migrate --dry-run
```

This displays:
- Which legacy files were detected
- The target `sigint.config.json` that would be created
- Which `CONTEXT.md` files would be generated for existing topics
- Which files would be backed up

## Run the migration

```
/sigint:migrate
```

The migrate skill performs these steps:

1. **Detects legacy config files** -- scans for `.claude/sigint.local.md` (project and global) and `.sigint.config.json` v1.0
2. **Parses legacy settings** -- extracts `default_repo`, `report_format`, `audiences`, `auto_atlatl` from YAML frontmatter, and `maxDimensions`, `dimensionTimeout`, `defaultPriorities` from v1.0 JSON
3. **Discovers existing topics** -- scans `./reports/*/state.json` for previously researched topics
4. **Builds v2.0 config** -- assembles `defaults`, `research`, and `topics` blocks from parsed values (with hardcoded defaults for missing fields)
5. **Creates CONTEXT.md files** -- generates a context file for each discovered topic at `./reports/{slug}/CONTEXT.md` (skips if already exists)
6. **Writes `sigint.config.json`** -- creates the v2.0 config using jq with schema validation
7. **Backs up legacy files** -- renames source files to `.bak` (timestamped if a backup already exists)
8. **Updates `.gitignore`** -- replaces the `.claude/sigint.local.md` entry with `sigint.config.json`

## Migrate global config

To also migrate `~/.claude/sigint.local.md`:

```
/sigint:migrate --global
```

## Handle existing v2.0 config

If `sigint.config.json` v2.0 already exists, you are prompted to choose:

- **Merge** -- adds missing topics from legacy config while preserving existing topic customizations
- **Overwrite** -- replaces the config entirely with freshly migrated values
- **Cancel** -- exits without changes

## After migration

1. Review `./sigint.config.json` and adjust per-topic settings
2. Edit `./reports/{slug}/CONTEXT.md` files to add project-specific research context
3. Run `/sigint:init` to verify the configuration loads correctly
4. Run `/sigint:start <topic>` to begin a research session with the new config

## See also

- [Configure Plugin](configure-plugin.md)
- [Configuration Reference](../reference/configuration.md)
