# sigint - Signal Intelligence

Comprehensive market research toolkit for Claude Code with report generation, GitHub issue creation, and trend-based analysis.

## Features

- **Iterative Research Workflow**: Start, refine, and finalize market research through commands
- **Multi-Audience Reports**: Generate reports for executives, PMs, investors, and developers
- **Trend-Based Modeling**: Three-valued logic analysis (INC/DEC/CONST) for uncertain data
- **GitHub Integration**: Automatically create sprint-sized issues from findings
- **Subcog Memory**: Persist research state across sessions
- **Multi-Format Output**: Markdown, HTML, Mermaid diagrams

## Installation

```bash
# Option 1: Local testing
claude --plugin-dir /path/to/sigint

# Option 2: Copy to plugins directory
cp -r sigint ~/.claude/plugins/
```

## Commands

| Command | Description |
|---------|-------------|
| `/sigint:start <topic>` | Begin new research session |
| `/sigint:augment <area>` | Deep-dive into specific area |
| `/sigint:update` | Refresh existing research data |
| `/sigint:report` | Generate comprehensive report |
| `/sigint:issues` | Create GitHub issues from findings |
| `/sigint:resume` | Resume previous research session |
| `/sigint:status` | Show current research state |
| `/sigint:init` | Manually initialize Subcog context |

## Agents

- **market-researcher**: Autonomous market research and data gathering
- **issue-architect**: Converts findings to sprint-sized GitHub issues
- **report-synthesizer**: Generates multi-format reports with visualizations

## Skills (Research Methodologies)

Each skill teaches AND executes the methodology:

1. **Competitive Analysis**: Porter's 5 Forces, competitor mapping
2. **Market Sizing**: TAM/SAM/SOM calculations
3. **Trend Analysis**: Macro/micro trend identification
4. **Customer Research**: Persona development, needs analysis
5. **Tech Assessment**: Technology evaluation, feasibility
6. **Financial Analysis**: Revenue models, unit economics
7. **Regulatory Review**: Compliance, legal considerations
8. **Report Writing**: Executive report best practices
9. **Trend Modeling**: Three-valued logic (INC/DEC/CONST), scenario graphs

## Report Structure

Reports include:
- Executive Summary
- Market Size (TAM/SAM/SOM)
- Competitive Landscape
- SWOT Analysis
- Recommendations
- Risk Assessment
- Data Sources & Methodology
- Transitional Scenario Graphs (Mermaid)

## Storage Structure

```
./reports/
└── topic-name/
    ├── YYYY-MM-DD-research.md
    ├── YYYY-MM-DD-report.md
    ├── YYYY-MM-DD-report.html
    └── YYYY-MM-DD-issues.json
```

## Configuration

Create `.claude/sigint.local.md` for custom settings:

```yaml
---
default_repo: owner/repo
report_format: markdown
audiences:
  - executives
  - product-managers
auto_subcog: true
---

Additional research context or preferences...
```

## Dependencies

- GitHub CLI (`gh`) for issue creation
- Subcog MCP server for memory persistence
- WebSearch/WebFetch tools for research

## License

MIT
