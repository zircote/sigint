---
diataxis_type: reference
title: Configuration Reference
description: All configuration options and file locations
---

# Configuration Reference

## File locations

| Location | Scope | Priority |
|----------|-------|----------|
| `./.claude/sigint.local.md` | Project | Highest |
| `~/.claude/sigint.local.md` | Global | Lower |
| Built-in defaults | Fallback | Lowest |

## Configuration options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `default_repo` | `string` | Current git remote | GitHub repo for issue creation (`owner/repo`) |
| `report_format` | `string` | `markdown` | Report output format: `markdown`, `html`, `both` |
| `audiences` | `string[]` | `["technical"]` | Default report audiences |
| `auto_atlatl` | `boolean` | `true` | Auto-persist findings to Atlatl memory |

## File format

Configuration files use YAML frontmatter followed by optional markdown content:

```yaml
---
default_repo: owner/repo
report_format: markdown
audiences:
  - executives
  - product-managers
auto_atlatl: true
---

Additional research context or preferences can be added here as markdown.
This content is loaded as supplementary context for research sessions.
```

## Storage structure

```
./reports/
├── README.md                   # Master index of all research
└── <topic-slug>/
    ├── README.md               # Topic research index
    ├── state.json              # Research state + elicitation context
    ├── YYYY-MM-DD-research.md  # Raw findings
    ├── YYYY-MM-DD-report.md    # Generated report (markdown)
    ├── YYYY-MM-DD-report.html  # Generated report (HTML)
    └── YYYY-MM-DD-issues.json  # Issue creation manifest
```

## See also

- [Configure Plugin](../how-to/configure-plugin.md)
- [Commands Reference](commands.md)
