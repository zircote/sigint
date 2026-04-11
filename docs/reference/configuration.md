---
diataxis_type: reference
title: Configuration Reference
description: Configuration options, file locations, schema v2.0, and resolution algorithm
---

# Configuration Reference

## Overview

Sigint uses a single structured JSON configuration file (`sigint.config.json`) that supports per-topic overrides for mono-repo research layouts.

## File Locations

| Location | Scope | Priority |
|----------|-------|----------|
| `./sigint.config.json` | Project | Highest |
| `~/.claude/sigint.config.json` | Global | Lower |
| Built-in defaults | Fallback | Lowest |

## Config Resolution Order

For any field and topic, values resolve via this cascade:

1. **Topic-specific** — `topics[<topic_slug>].<field>` in project config
2. **Project defaults** — `defaults.<field>` in project config
3. **Global defaults** — `defaults.<field>` in global config
4. **Hardcoded default** — built-in value

## Configuration Options

### User Preference Fields (`defaults` block)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `default_repo` | `string or null` | `null` | GitHub repo for issue creation (owner/repo) |
| `report_format` | `markdown, html, or both` | `"markdown"` | Report output format |
| `audiences` | `string[]` | `["technical"]` | Default report audiences |

### Research Runtime Fields (`research` block)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `maxDimensions` | `integer` | `5` | Max concurrent research dimensions |
| `dimensionTimeout` | `integer` | `300` | Seconds per dimension before timeout |
| `defaultPriorities` | `string[]` | `["competitive","sizing","trends"]` | Default dimension ordering |

### Per-Topic Fields (`topics[slug]` block)

All user preference fields above, plus:

| Field | Type | Description |
|-------|------|-------------|
| `context_file` | `string or null` | Path to CONTEXT.md with freeform research context |
| `research` | `object` | Topic-level overrides of research block fields |

## File Format

```json
{
  "version": "2.0",
  "defaults": {
    "default_repo": "owner/repo",
    "report_format": "markdown",
    "audiences": ["technical"]
  },
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  },
  "topics": {
    "my-topic-slug": {
      "default_repo": "owner/other-repo",
      "audiences": ["executives", "technical"],
      "context_file": "./reports/my-topic-slug/CONTEXT.md",
      "research": {
        "maxDimensions": 8
      }
    }
  }
}
```

## Context Files

Each topic can reference a `CONTEXT.md` file:
- Typically at `./reports/{topic_slug}/CONTEXT.md`
- Loaded by `/sigint:start` and passed to the research orchestrator
- Useful for: project background, target audience, research constraints, prior decisions
- Created automatically by `/sigint:migrate` or added manually

## Storage Structure

```
./
├── sigint.config.json              # Project config (gitignored)
└── reports/
    ├── README.md
    └── <topic-slug>/
        ├── CONTEXT.md                  # Topic research context
        ├── README.md
        ├── state.json
        ├── YYYY-MM-DD-research.md
        ├── YYYY-MM-DD-report.md
        ├── YYYY-MM-DD-report.html
        └── YYYY-MM-DD-issues.json
```

## Migration from Legacy Config

```
/sigint:migrate
```

Converts `sigint.local.md` or `.sigint.config.json` v1.0 to v2.0, creates CONTEXT.md files for each existing topic, and backs up old files as `.bak`.

## See also

- [Configure Plugin](../how-to/configure-plugin.md)
- [Commands Reference](commands.md)
