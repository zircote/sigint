# Quick Start Guide

Get started with sigint in 5 minutes.

## Prerequisites

- Claude Code installed
- sigint plugin enabled
- (Optional) GitHub CLI (`gh`) for issue creation
- (Optional) Subcog MCP server for memory persistence

## Your First Research Session

### Step 1: Start Research

```
/sigint:start AI-powered code review tools
```

### Step 2: Answer Elicitation Questions

sigint will ask you questions to scope your research. Answer honestly - this shapes the entire research output.

**Decision Context**
> "What decision will this research inform?"

Example: "Whether to build or buy a code review solution for our startup"

**Audience**
> "Who will consume this research?"

Example: "CTO and engineering leads"

**Scope**
> "What geographic markets? What time horizon?"

Example: "US market, 12-month planning horizon"

**Priorities**
> "Rank these research areas..."

Select your top 3-5 priorities from the list.

### Step 3: Review Status

Once elicitation completes, check progress:

```
/sigint:status
```

You'll see a dashboard showing which research areas are complete.

### Step 4: Deep Dive (Optional)

Want more detail on a specific area?

```
/sigint:augment competitive landscape
```

### Step 5: Generate Report

When ready, create your report:

```
/sigint:report
```

This generates:
- `./reports/ai-code-review/YYYY-MM-DD-report.md`
- Executive summary, market sizing, competitive analysis, recommendations

### Step 6: Create Issues (Optional)

Convert findings to GitHub issues:

```
/sigint:issues
```

## What's Next?

- Read the [Workflow Guide](workflow-guide.md) for detailed usage
- Check [Troubleshooting](troubleshooting.md) if you hit issues
- Explore the 9 research methodologies in skills/

## Example Output

After completing research, you'll have:

```
./reports/ai-code-review/
├── 2026-01-22-report.md      # Full report
├── 2026-01-22-executive.md   # Executive summary
├── state.json                # Research state
└── 2026-01-22-issues.json    # Generated issues
```
