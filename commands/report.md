---
description: Generate comprehensive research report in multiple formats
version: 0.1.0
argument-hint: [--format <type>] [--audience <type>] [--sections <list>]
allowed-tools: Read, Write, Grep, Glob, WebFetch, TodoWrite
---

Generate a comprehensive market research report from current findings.

**Arguments:**
- `--format` - Output format: markdown (default), html, both
- `--audience` - Target audience: executives, pm, investors, dev, all
- `--sections` - Comma-separated list of sections to include (or "all")

**Report Sections:**

1. **Executive Summary** (always included)
   - Key findings in 3-5 bullets
   - Primary recommendation
   - Critical risks

2. **Market Overview**
   - Market definition and scope
   - Current state analysis
   - Key players and segments

3. **Market Sizing** (TAM/SAM/SOM)
   - Total Addressable Market calculation
   - Serviceable Addressable Market
   - Serviceable Obtainable Market
   - Growth projections with trend indicators (INC/DEC/CONST)

4. **Competitive Landscape**
   - Competitor matrix
   - Porter's 5 Forces summary
   - Positioning map (Mermaid diagram)

5. **Trend Analysis**
   - Macro trends
   - Micro trends
   - Transitional scenario graph (Mermaid)
   - Terminal scenarios and trade-offs

6. **SWOT Analysis**
   - Strengths, Weaknesses, Opportunities, Threats
   - Visual quadrant (Mermaid)

7. **Recommendations**
   - Strategic recommendations (prioritized)
   - Tactical next steps
   - Resource requirements

8. **Risk Assessment**
   - Risk matrix
   - Mitigation strategies
   - Monitoring indicators

9. **Appendix**
   - Data sources and methodology
   - Detailed competitor profiles
   - Full scenario analysis
   - Research timeline

**Generation Process:**

1. **Load research state:**
   Read all findings from state.json.
   Load related Subcog memories.

2. **Use report-writing skill:**
   Apply executive report best practices.
   Tailor language to specified audience.

3. **Generate visualizations:**
   Create all Mermaid diagrams:
   - Competitive positioning map
   - Trend scenario graphs
   - SWOT quadrant
   - Risk matrix

4. **Write report files:**
   - `./reports/[topic]/YYYY-MM-DD-report.md`
   - `./reports/[topic]/YYYY-MM-DD-report.html` (if requested)

5. **Generate summary:**
   Create one-page executive brief.

**Output:**
- Full report in specified format(s)
- Location of saved files
- Prompt for issue generation

**Example usage:**
```
/sigint:report
/sigint:report --format both --audience executives
/sigint:report --sections "executive-summary,competitive,recommendations"
```
