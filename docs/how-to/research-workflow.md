---
diataxis_type: how-to
title: Research Workflow
description: How to run, refine, and complete market research sessions
---

# Research Workflow

How to manage the full research lifecycle: start, augment, update, report, and create issues.

## Start a new research session

```
/sigint:start <topic>
```

Answer the elicitation questions to scope your research. The research-orchestrator spawns parallel dimension-analysts for each prioritized area.

For quick research without full elicitation:
```
Just ask: "Research the AI code review market"
```

## Deep dive into specific areas

```
/sigint:augment <area>
```

Available areas: `competitive landscape`, `market sizing`, `trends`, `customer research`, `technology assessment`, `financial analysis`, `regulatory review`.

Each augment spawns a single dimension-analyst with the relevant skill methodology.

## Update stale research

```
/sigint:update
/sigint:update --area "competitive landscape"
/sigint:update --since 2026-01-01
```

Flags findings older than 30 days as stale and fetches fresh data.

## Generate reports

```
/sigint:report
/sigint:report --format both --audience executives
/sigint:report --sections "executive-summary,competitive,recommendations"
```

Reports auto-adjust language and focus based on your stated audience (executives, PMs, investors, developers).

## Create GitHub issues

```
/sigint:issues
/sigint:issues --dry-run
/sigint:issues --repo myorg/myrepo --labels "market-research,q1-2026"
```

The issue-architect atomizes findings into sprint-sized issues with acceptance criteria.

## Resume previous sessions

```
/sigint:resume
/sigint:resume "AI code assistants"
/sigint:resume --list
```

Restores research state from files.

## Check session status

```
/sigint:status
/sigint:status --verbose
```

Shows research progress, team status (if analysts are running), coverage gaps, and suggested next actions.

## See also

- [Getting Started Tutorial](../tutorials/getting-started.md)
- [Commands Reference](../reference/commands.md)
- [Troubleshooting](../how-to/troubleshooting.md)
