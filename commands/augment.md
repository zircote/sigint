---
description: Deep-dive into a specific area of current research
argument-hint: <area> [--methodology <type>]
allowed-tools: Read, Write, Grep, Glob, WebSearch, WebFetch, TodoWrite
---

Augment the current research session with deeper analysis of a specific area.

**Arguments:**
- `$1` - Area to investigate deeper (e.g., "competitor pricing", "regulatory landscape", "technology stack")
- `--methodology` - Optional: specific methodology to apply (competitive, sizing, trends, customer, tech, financial, regulatory)

**Process:**

1. **Load current research state:**
   Read `./reports/[current-topic]/state.json` to understand context.
   Load relevant Subcog memories for this research.

2. **Identify applicable methodology:**
   Based on the area specified, select the most relevant sigint skill:
   - Competitor/market players → competitive-analysis skill
   - Size/TAM/opportunity → market-sizing skill
   - Patterns/future → trend-analysis skill (include trend-modeling for scenarios)
   - Users/personas → customer-research skill
   - Technology/feasibility → tech-assessment skill
   - Revenue/economics → financial-analysis skill
   - Compliance/legal → regulatory-review skill

3. **Execute deep research:**
   Apply the selected methodology using WebSearch and WebFetch.
   Gather specific data points, quotes, and evidence.

4. **Generate transitional scenario graph:**
   For trend-related augmentations, create Mermaid diagrams showing:
   - Current state scenarios
   - Possible transitions (INC/DEC/CONST)
   - Terminal/equilibrium states

5. **Update research state:**
   Add new findings to state.json.
   Capture key insights to Subcog memory.
   Update the research phase if appropriate.

6. **Present augmented findings:**
   Summarize new discoveries with evidence.
   Show how this connects to existing research.
   Include scenario graphs where relevant.

**Output:**
- Detailed findings for the augmented area
- Mermaid transitional graphs (when applicable)
- Updated research state
- Recommendations for further augmentation or report generation

**Example usage:**
```
/sigint:augment "competitor pricing strategies"
/sigint:augment "regulatory risks" --methodology regulatory
/sigint:augment "market growth trajectory" --methodology trends
```
