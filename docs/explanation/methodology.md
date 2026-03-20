---
diataxis_type: explanation
title: Research Methodology
description: The theoretical foundations behind sigint's analytical frameworks
---

# Research Methodology

Sigint's research approach combines established business analysis frameworks with three-valued logic for handling uncertainty.

## Three-valued logic (INC/DEC/CONST)

The core analytical innovation in sigint is the use of minimally information-intensive quantifiers for trend analysis:

- **INC** (increasing): Growing trend with supporting evidence
- **DEC** (decreasing): Declining trend with supporting evidence
- **CONST** (constant): Stable or uncertain — insufficient evidence for directional claim

This approach comes from qualitative modeling under information scarcity. Rather than requiring precise numerical parameters (which are often unavailable in market research), three-valued logic captures directional trends that can be composed into scenario models.

### Correlation-to-trend conversion

When quantitative data is available, it maps to trend values:
- Correlation coefficient r > 0.3 → INC
- Correlation coefficient r < -0.3 → DEC
- -0.3 <= r <= 0.3 → CONST

### Transitional scenario graphs

Variables with assigned trend values generate scenarios through their relationships. A Mermaid state diagram shows possible transitions from the current state to terminal (equilibrium) states, with each path labeled by the trend indicators that drive the transition.

## Analytical frameworks

### Porter's Five Forces
Analyzes industry structure through competitive rivalry, supplier power, buyer power, threat of substitution, and threat of new entry. Each force rated High/Medium/Low with industry-specific factors.

### TAM/SAM/SOM
Market sizing using three tiers: Total Addressable Market (global opportunity), Serviceable Addressable Market (realistic target), Serviceable Obtainable Market (achievable share). Supports top-down, bottom-up, and value theory methodologies.

### SWOT Analysis
Strengths, Weaknesses, Opportunities, Threats organized into internal/external and helpful/harmful quadrants.

## Academic references

- Bockova, N., Volna, B., & Dohnal, M. (2025). "Optimisation of complex product innovation processes based on trend models with three-valued logic." *arXiv:2601.10768v1*.
- Porter, M.E. (1979). "How Competitive Forces Shape Strategy." *Harvard Business Review*, 57(2).
- Blank, S. & Dorf, B. (2012). *The Startup Owner's Manual*. K&S Ranch.
- Kleene, S.C. (1952). *Introduction to Metamathematics*. North-Holland.
- Schwartz, P. (1991). *The Art of the Long View*. Doubleday.

## See also

- [Architecture](architecture.md) — how these methodologies are executed
- [Skills Reference](../reference/skills.md) — individual skill details
