---
diataxis_type: how-to
title: Configure Sigint
description: How to set up global and project-specific configuration using sigint.config.json v2.0
---

# Configure Sigint

How to set up default repositories, report formats, audience preferences, and per-topic overrides using the `sigint.config.json` v2.0 format.

## Configuration locations

Sigint uses cascading JSON configuration where project settings override global defaults.

| Location | Scope | Priority |
|----------|-------|----------|
| `./sigint.config.json` | Project | Highest |
| `~/.claude/sigint.config.json` | Global | Lower |
| Built-in defaults | Fallback | Lowest |

**Resolution order**: Topic-specific > Project defaults > Global defaults > Hardcoded defaults

## Create a project configuration

Create `sigint.config.json` in your project root:

```json
{
  "version": "2.0",
  "defaults": {
    "default_repo": "myorg/myrepo",
    "report_format": "markdown",
    "audiences": ["developers", "product-managers"]
  },
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  },
  "topics": {}
}
```

## Create a global configuration

Create `~/.claude/sigint.config.json` for user-wide defaults:

```json
{
  "version": "2.0",
  "defaults": {
    "report_format": "markdown",
    "audiences": ["executives"]
  },
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  },
  "topics": {}
}
```

## Add per-topic overrides

Override defaults for specific research topics in the `topics` block:

```json
{
  "version": "2.0",
  "defaults": {
    "default_repo": "myorg/myrepo",
    "report_format": "markdown",
    "audiences": ["technical"]
  },
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  },
  "topics": {
    "ai-code-review": {
      "default_repo": "myorg/ai-review-tracker",
      "audiences": ["executives", "technical"],
      "context_file": "./reports/ai-code-review/CONTEXT.md",
      "research": {
        "maxDimensions": 8
      }
    }
  }
}
```

Topic-level fields override project defaults for that topic only.

## Topic lifecycle fields

When you run `/sigint:start`, the topic is automatically registered in `sigint.config.json` with lifecycle tracking fields. You do not need to add these manually — they are managed by the research lifecycle:

```json
"topics": {
  "ag-grants-research": {
    "status": "complete",
    "dimensions": ["competitive", "regulatory", "financial"],
    "created": "2026-04-02T14:30:00Z",
    "updated": "2026-04-03T09:15:00Z",
    "reports_dir": "./reports/ag-grants-research",
    "findings_count": 42,
    "context_file": "./reports/ag-grants-research/CONTEXT.md"
  }
}
```

| Field | Managed by | Description |
|-------|-----------|-------------|
| `status` | start/augment/update/orchestrator | `in_progress`, `complete`, or `stale` |
| `dimensions` | start/augment/orchestrator | Researched dimensions |
| `created` | start | First session timestamp |
| `updated` | all lifecycle commands | Last activity timestamp |
| `reports_dir` | start | Path to reports directory |
| `findings_count` | orchestrator/augment | Total active findings |
| `context_file` | migrate/manual | Optional CONTEXT.md path |

These fields enable `/sigint:status` and `/sigint:resume --list` to discover sessions from the config without globbing report directories.

## Add a context file

Each topic can reference a `CONTEXT.md` file with freeform research background:

```markdown
# Research Context: AI Code Review

Target market: US enterprise, 500+ developers
Key constraint: Must integrate with GitHub and GitLab
Prior decision: Ruled out self-hosted solutions in Q1
```

Set the path in your topic config:

```json
"ai-code-review": {
  "context_file": "./reports/ai-code-review/CONTEXT.md"
}
```

The context file is loaded by `/sigint:start` and passed to the research orchestrator.

## Available options

### Defaults block

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `default_repo` | `string or null` | `null` | GitHub repo for issue creation (`owner/repo`) |
| `report_format` | `markdown, html, or both` | `"markdown"` | Report output format |
| `audiences` | `string[]` | `["technical"]` | Default report audiences |

### Research block

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxDimensions` | `integer` | `5` | Max concurrent research dimensions |
| `dimensionTimeout` | `integer` | `300` | Seconds per dimension before timeout |
| `defaultPriorities` | `string[]` | `["competitive","sizing","trends"]` | Default dimension ordering |

## Initialize configuration interactively

```
/sigint:init
```

Creates `sigint.config.json` with default template if it does not exist.

## Migrate from legacy configuration

If you have an existing `sigint.local.md` or `.sigint.config.json` v1.0:

```
/sigint:migrate
```

This converts legacy config to `sigint.config.json` v2.0, creates CONTEXT.md files for existing topics, and backs up old files. See [Migrate Configuration](migrate-config.md) for the full process.

## See also

- [Configuration Reference](../reference/configuration.md)
- [Migrate Configuration](migrate-config.md)
- [Commands Reference](../reference/commands.md)
