---
diataxis_type: how-to
title: Augment Research
description: How to deep-dive into specific research dimensions
---

# Augment Research

How to add depth to specific areas of an active research session.

## Augment a single dimension

```
/sigint:augment <area>
```

This spawns a single dimension-analyst focused on one research methodology.

## Available dimensions

| Dimension | Skill Used | What It Covers |
|-----------|-----------|----------------|
| `competitive landscape` | competitive-analysis | Porter's 5 Forces, competitor mapping, positioning |
| `market sizing` | market-sizing | TAM/SAM/SOM calculations, growth projections |
| `trends` | trend-analysis + trend-modeling | Macro/micro trends, scenario graphs |
| `customer research` | customer-research | Personas, needs analysis, journey maps |
| `technology assessment` | tech-assessment | Tech evaluation, build vs buy, feasibility |
| `financial analysis` | financial-analysis | Revenue models, unit economics |
| `regulatory review` | regulatory-review | Compliance, legal considerations |

## Specify methodology explicitly

```
/sigint:augment "regulatory risks" --methodology regulatory
```

## Augment with a specific source

For large documents (analyst reports, PDFs), the source-chunker agent automatically activates for documents exceeding ~15K tokens:

```
/sigint:augment competitive --source https://example.com/industry-report.pdf
```

## See also

- [Research Workflow](research-workflow.md)
- [Skills Reference](../reference/skills.md)
- [Architecture: Source Chunking](../explanation/architecture.md#source-chunking)
