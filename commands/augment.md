---
description: Deep-dive into a specific area of current research
version: 0.1.0
argument-hint: <area> [--methodology <type>]
allowed-tools: Read, Write, Grep, Glob, TodoWrite
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

3. **Delegate to market-researcher agent:**
   Use the Task tool to launch the market-researcher agent:
   - `subagent_type`: `"sigint:market-researcher"`
   - `prompt`: Include the area to investigate, selected methodology, and path to state.json
   - `description`: "Deep research on [area]"

   The agent will apply the selected methodology using WebSearch and WebFetch,
   gathering specific data points, quotes, and evidence in isolated context.

   **Do NOT execute research directly in this context.**

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
