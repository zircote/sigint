# Workflow Guide

Complete guide to the sigint research workflow.

## Research Lifecycle

```
┌───────────────┐     ┌──────────────────┐    ┌─────────┐     ┌────────┐
│ /sigint:start │  →  │  Orchestrator    │  → │ Report  │  →  │ Issues │
│ (Elicitation) │     │  ├─ Analyst ×N   │    │ (Synth) │     │ (Arch) │
│               │     │  └─ (parallel)   │    │         │     │        │
└───────────────┘     └──────────────────┘    └─────────┘     └────────┘
```

## Phase 1: Elicitation

### Why Elicitation Matters

Without context, research is generic. Elicitation ensures:
- Research addresses YOUR specific decision
- Output is tailored to YOUR audience
- Findings focus on YOUR priorities

### Elicitation Questions

| Section | Purpose | Example |
|---------|---------|---------|
| Decision Context | What decision this informs | "Build vs buy decision" |
| Audience | Who reads the output | "Board of directors" |
| Expertise Level | How technical to be | "Non-technical executives" |
| Hypotheses | Claims to validate | "Market is consolidating" |
| Geography | Market scope | "North America only" |
| Time Horizon | Planning window | "18 months" |
| Competitors | Known players | "SonarQube, CodeClimate" |
| Priorities | Research focus | Competitive, Market Size |
| Success Criteria | What makes it valuable | "Surprising insights" |
| Budget Context | Resource constraints | "Bootstrapped startup" |
| Timeline | Urgency | "Board meeting in 2 weeks" |

### Skipping Elicitation

If you want quick research without elicitation:
```
Just ask: "Research the AI code review market"
```
The research-orchestrator agent will run with generic assumptions.

## Phase 2: Research

### Automatic Research

After elicitation, the `research-orchestrator` agent:
1. Creates a blackboard for team coordination
2. Spawns parallel `dimension-analyst` agents for each priority
3. Each analyst loads its skill methodology and conducts web research
4. Findings written to blackboard, merged by orchestrator
5. Results stored in `./reports/<topic>/state.json`

### Manual Deep Dives

Add depth to specific areas:

```
/sigint:augment competitive landscape
/sigint:augment market sizing
/sigint:augment regulatory environment
```

Available areas:
- `competitive landscape`
- `market sizing`
- `trends`
- `customer research`
- `technology assessment`
- `financial analysis`
- `regulatory review`

### Updating Stale Research

Refresh data after time passes:

```
/sigint:update
/sigint:update --area "competitive landscape"
/sigint:update --since 2026-01-01
```

## Phase 3: Reports

### Generate Full Report

```
/sigint:report
```

Creates a comprehensive report with:
- Executive Summary (key findings, recommendation)
- Research Brief Alignment (how it addresses your decision)
- Hypothesis Validation (if you stated hypotheses)
- Market Overview
- Competitive Landscape
- Trends & Projections
- SWOT Analysis
- Recommendations
- Risk Assessment
- Sources

### Report Audiences

Reports auto-adjust based on your stated audience:

| Audience | Focus |
|----------|-------|
| Executives | Bottom-line impact, strategic implications |
| Product Managers | Feature gaps, roadmap implications |
| Investors | Market opportunity, growth metrics |
| Developers | Technical feasibility, build vs buy |

### Output Formats

Reports generate as:
- Markdown (`.md`) - Default, portable
- HTML (`.html`) - Styled, printable
- Mermaid diagrams embedded for visualizations

## Phase 4: Issues

### Generate GitHub Issues

```
/sigint:issues
```

The `issue-architect` agent:
1. Extracts actionable items from research
2. Atomizes into sprint-sized issues
3. Categorizes (feature, enhancement, research, action)
4. Assigns priorities (P0-P3)
5. Creates via `gh` CLI or previews for review

### Issue Categories

| Category | Label | Example |
|----------|-------|---------|
| Feature | `enhancement`, `feature` | New capability from market gap |
| Enhancement | `enhancement` | Improvement to existing feature |
| Research | `research` | Further investigation needed |
| Action Item | `action-item` | Process change, quick win |

### Dry Run

Preview issues without creating:
```
/sigint:issues --dry-run
```

## Resuming Work

### Check Status

```
/sigint:status
/sigint:status --verbose
```

### Resume Previous Session

```
/sigint:resume
```

Lists active sessions and continues where you left off.

## Storage Structure

All research stored locally:

```
./reports/
├── README.md                   # Master index of all research
└── <topic-slug>/
    ├── README.md               # Topic research index
    ├── state.json              # Research state + elicitation
    ├── YYYY-MM-DD-research.md  # Raw findings
    ├── YYYY-MM-DD-report.md    # Generated report
    ├── YYYY-MM-DD-report.html  # HTML version
    └── YYYY-MM-DD-issues.json  # Issue manifest
```

### Master Index (`./reports/README.md`)

The root reports folder includes a master index that:
- Lists all research topics with status and dates
- Provides quick links to active and completed research
- Shows brief summaries for each topic

### Topic Index (`./reports/<topic>/README.md`)

Each research folder includes a topic README.md that provides:
- **Research query**: Original topic and question
- **Configuration**: Elicitation settings (audience, scope, priorities)
- **Artifact links**: Links to all generated files
- **Key findings**: Top 3 insights from the research

This makes it easy to browse research folders and understand what each contains.

## Atlatl Memory Integration

Research findings persist across sessions via Atlatl MCP:

- Key findings stored with namespace `_semantic/knowledge` and tag `sigint-research`
- Methodology learnings stored in `_procedural/patterns` with tag `sigint-methodology`
- Prior research automatically recalled when starting related topics
- Blackboard provides ephemeral coordination during active research (TTL 24h)
