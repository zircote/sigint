---
diataxis_type: tutorial
title: Getting Started with Sigint
description: Complete your first market research session in 10 minutes
---

# Getting Started with Sigint

This tutorial walks you through your first market research session — from installation to a finished report.

## What you'll accomplish

By the end of this tutorial, you will have:
- Installed the sigint plugin
- Scoped a research topic through elicitation
- Run parallel market research across multiple dimensions
- Generated a professional research report

## Prerequisites

- Claude Code installed and running
- `jq` installed (used for all JSON file operations)
- (Optional) GitHub CLI (`gh`) for issue creation

## Step 1: Install the plugin

```bash
/plugins add sigint
```

Verify it loaded:
```
/sigint:status
```

You should see a message indicating no active research session.

## Step 2: Start your first research session

```
/sigint:start AI-powered code review tools
```

Sigint will ask you a series of scoping questions. For this tutorial, use these answers:

**Decision Context:** "Whether to build or buy a code review solution for our startup"

**Audience:** "CTO and engineering leads"

**Scope:** "US market, 12-month planning horizon"

**Priorities:** Select competitive landscape, market sizing, and trend analysis.

**Timeline:** "This week"

After you confirm the research brief, sigint spawns a research-orchestrator that runs parallel dimension-analysts for each priority you selected.

## Step 3: Check progress

While research runs:

```
/sigint:status
```

The dashboard shows which dimension-analysts are active, complete, or pending.

## Step 4: Review findings

Once research completes, your findings are in `./reports/ai-code-review/state.json`.

Want more depth on a specific area?

```
/sigint:augment competitive landscape
```

## Step 5: Generate your report

```
/sigint:report
```

This creates:
- `./reports/ai-code-review/YYYY-MM-DD-report.md` — full report
- `./reports/ai-code-review/YYYY-MM-DD-executive-summary.md` — one-page brief

## Step 6: Create GitHub issues (optional)

Convert actionable findings into sprint-sized issues:

```
/sigint:issues --dry-run
```

Review the preview, then create for real:

```
/sigint:issues
```

## What you've learned

You completed a full research cycle: elicitation, parallel research, report generation, and issue creation.

## Next steps

- [Research Workflow Guide](../how-to/research-workflow.md) — detailed workflow options
- [Augmenting Research](../how-to/augment-research.md) — deep dives into specific areas
- [Commands Reference](../reference/commands.md) — all available commands
- [Troubleshooting](../how-to/troubleshooting.md) — common issues and solutions
