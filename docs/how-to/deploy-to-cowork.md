# Deploy Sigint to Cowork

Sigint is compatible with both Claude Code and Cowork. This guide covers deploying and using sigint in Cowork environments.

## Prerequisites

- Claude Pro, Max, Team, or Enterprise subscription
- Claude Desktop app with Cowork enabled

## Installation

### Individual Installation

1. Open the Claude Desktop app and switch to the **Cowork** tab
2. Click **Customize** in the left sidebar
3. Click **Browse plugins** and search for "sigint"
4. Click **Install**

### Organization-Wide Deployment (Teams/Enterprise)

1. Add the sigint plugin to your organization's plugin marketplace repository
2. Configure managed settings to distribute the marketplace to team members
3. Team members install from Cowork sidebar: **Customize > Browse plugins > sigint > Install**

### Manual Installation

Clone the repository and point Cowork to the local directory:

```bash
git clone https://github.com/zircote/sigint.git ~/.claude/plugins/sigint
```

## Cowork Environment Differences

Cowork runs in a sandboxed virtual machine. This affects sigint in the following ways:

### GitHub Integration

Cowork uses GitHub MCP tools instead of the `gh` CLI. Sigint's issue-architect agent will automatically prefer MCP tools when available. No configuration needed — ensure your Cowork environment has the GitHub MCP server connected.

To connect GitHub in Cowork:
1. Go to **Customize > Connectors**
2. Enable the **GitHub** connector
3. Authorize access to your target repositories

### Atlatl MCP (Optional)

Sigint uses Atlatl MCP for blackboard coordination and persistent memory. If Atlatl is not available in your Cowork environment:

- **Blackboard coordination** falls back to file-based state in `./reports/{topic-slug}/` (per-key files)
- **Persistent memory** falls back to `./reports/{topic-slug}/state.json` per research session
- **All core research workflows** continue to function without Atlatl

To add Atlatl in Cowork (if available):
1. Go to **Customize > Connectors**
2. Enable the **Atlatl** connector

### File System

Cowork provides a sandboxed filesystem. Sigint writes all output to `./reports/` within the active project directory. This works normally in Cowork's sandbox.

## Usage in Cowork

Usage is identical to Claude Code. All commands work the same way:

```
/sigint:start AI-powered customer support tools
/sigint:status
/sigint:report --audience executives
/sigint:issues --repo myorg/myrepo
```

## Troubleshooting

### "Blackboard tools not available"

Atlatl MCP is not connected. Sigint will automatically fall back to file-based coordination. Research workflows are unaffected.

### "Cannot create GitHub issues"

Ensure the GitHub connector is enabled in **Customize > Connectors** and you have authorized access to the target repository.

### "WebSearch unavailable"

Cowork requires web access permissions. Check that your organization's managed settings allow web search and web fetch for plugins.
