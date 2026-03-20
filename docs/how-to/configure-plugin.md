---
diataxis_type: how-to
title: Configure Sigint
description: How to set up global and project-specific configuration
---

# Configure Sigint

How to set up default repositories, report formats, and audience preferences.

## Configuration locations

Sigint uses cascading configuration where project settings override global defaults.

| Location | Scope | Purpose |
|----------|-------|---------|
| `~/.claude/sigint.local.md` | Global | User-wide defaults for all projects |
| `./.claude/sigint.local.md` | Project | Project-specific overrides |

**Resolution order**: Project > Global > Built-in defaults

## Create a global configuration

```bash
mkdir -p ~/.claude
cat > ~/.claude/sigint.local.md << 'EOF'
---
report_format: markdown
audiences:
  - executives
---
EOF
```

## Create a project configuration

```bash
mkdir -p .claude
cat > .claude/sigint.local.md << 'EOF'
---
default_repo: myorg/myrepo
audiences:
  - developers
  - product-managers
---
EOF
```

## Available options

| Option | Description | Default |
|--------|-------------|---------|
| `default_repo` | GitHub repo for issue creation (`owner/repo`) | Current git remote |
| `report_format` | Output format: `markdown`, `html`, `both` | `markdown` |
| `audiences` | Default report audiences | `["technical"]` |
| `auto_atlatl` | Auto-persist findings to Atlatl memory | `true` |

## Initialize configuration interactively

```
/sigint:init
```

Creates `.claude/sigint.local.md` with default template if it doesn't exist, and loads Atlatl memory context.

## See also

- [Configuration Reference](../reference/configuration.md)
- [Commands Reference](../reference/commands.md)
