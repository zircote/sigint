---
diataxis_type: reference
title: Skills Reference
description: Overview of all 9 research methodology skills
---

# Skills Reference

Each skill is a passive methodology guide loaded by dimension-analysts during research. Skills define frameworks, output structures, and quality standards.

| Skill | Directory | Methodology | Key Frameworks |
|-------|-----------|-------------|----------------|
| Competitive Analysis | `skills/competitive-analysis/` | Porter's 5 Forces, competitor mapping | Competitive matrix, positioning map, strategic recommendations |
| Market Sizing | `skills/market-sizing/` | TAM/SAM/SOM calculations | Top-down, bottom-up, value theory, scenario modeling |
| Trend Analysis | `skills/trend-analysis/` | Macro/micro trend identification | Three-valued logic (INC/DEC/CONST), emerging signals, scenario graphs |
| Customer Research | `skills/customer-research/` | Persona development, needs analysis | JTBD framework, customer journey maps, interview frameworks |
| Tech Assessment | `skills/tech-assessment/` | Technology evaluation, feasibility | TRL assessment, build vs buy, hype cycle positioning |
| Financial Analysis | `skills/financial-analysis/` | Revenue models, unit economics | CAC/LTV, Rule of 40, SaaS metrics, scenario projections |
| Regulatory Review | `skills/regulatory-review/` | Compliance, legal considerations | GDPR, HIPAA, SOC2, industry-specific frameworks |
| Report Writing | `skills/report-writing/` | Executive report best practices | Minto Pyramid, audience tailoring, visualization selection |
| Trend Modeling | `skills/trend-modeling/` | Three-valued logic scenario modeling | Variable relationships, transitional scenarios, terminal states |

## Skill structure

Each skill directory contains:

```
skills/<name>/
├── SKILL.md              # Methodology definition + orchestration hints
├── evals/
│   └── evals.json        # Evaluation test cases
├── references/           # Framework details and templates
└── examples/             # Sample outputs
```

## Orchestration hints

Every SKILL.md includes an `## Orchestration Hints` section that tells dimension-analysts:
- **Blackboard key** for writing findings
- **Cross-reference dimensions** to validate against
- **Alert triggers** for significant findings
- **Confidence rules** for source requirements
- **Conflict detection** patterns against other dimensions

## See also

- [Agents Reference](agents.md) — dimension-analyst uses these skills
- [Architecture](../explanation/architecture.md) — how skills fit into the swarm
