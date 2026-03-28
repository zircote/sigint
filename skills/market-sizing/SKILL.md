---
name: Market Sizing
description: This skill should be used when the user asks to "calculate market size", "TAM SAM SOM analysis", "estimate market opportunity", "market sizing", "total addressable market", "serviceable market", "market potential", or needs guidance on market size estimation methodologies, market opportunity calculations, or growth projections.
version: 0.3.0
---

# Market Sizing (TAM/SAM/SOM)

## Overview

Market sizing quantifies the revenue opportunity in a market. The TAM/SAM/SOM framework provides progressively refined estimates from total market to realistically achievable share.

## Required Frameworks

| Framework | Output Section | Required | Condition |
|-----------|---------------|----------|-----------|
| Methodology Selection | methodology rationale | yes | — |
| TAM/SAM/SOM Hierarchy | Market Sizing Summary | yes | — |
| Scenario Modeling | Scenarios | yes | — |
| Growth Projections | CAGR/growth | yes | — |

## Key Definitions

**TAM (Total Addressable Market)**
- Total global market demand for a product/service
- Assumes 100% market share (theoretical maximum)
- Useful for understanding ceiling and investor conversations

**SAM (Serviceable Addressable Market)**
- Portion of TAM targetable with current business model
- Considers geographic, demographic, or segment constraints
- More realistic than TAM

**SOM (Serviceable Obtainable Market)**
- Realistic market share achievable in near term (1-3 years)
- Considers competition, resources, and go-to-market capability
- Most relevant for planning

## Methodology Selection Guide

| User Signal | Recommended Methodology |
|-------------|------------------------|
| "TAM SAM SOM", "market opportunity", no pricing data | Top-Down |
| Provides pricing, unit counts, or customer data | Bottom-Up |
| Mentions "value", "pain point cost", "willingness to pay" | Value Theory |
| "bottom-up" explicitly requested | Bottom-Up |
| "growth trends", "CAGR", trend questions | Top-Down + Trend Analysis |
| "bear/base/bull", "scenarios" | Any methodology + Scenario Modeling |
| Vague with no segment specified | Top-Down (state assumptions) |
| Market known to be declining | Top-Down + DEC trend handling |

## Calculation Methodologies

### Top-Down Approach

Start with large market data, narrow down:

1. **Find industry market size** from analyst reports
2. **Apply relevant percentage** for target segment
3. **Adjust for geography** if not global
4. **Factor growth rates** for projections

**Example:**
- Global SaaS market: $200B (TAM)
- HR SaaS segment: 15% → $30B (TAM refined)
- North America: 40% → $12B (SAM)
- Achievable share 2%: $240M (SOM)

**Pros:** Fast, uses existing research
**Cons:** May miss nuances, depends on source quality

### Bottom-Up Approach

Build from unit economics upward. When the user provides pricing data, use their exact figure:

1. **Identify target customer count** — quantify the addressable customer base with specific numbers
2. **Estimate price per customer** — use user-provided pricing if available; cite source otherwise
3. **Calculate total revenue potential** — show the multiplication explicitly

**Example:**
- Target customers: 50,000 SMBs
- Average contract value: $5,000/year
- Total: $250M (SOM)
- Expand to all SMBs (500,000): $2.5B (SAM)
- Include enterprise: $10B (TAM)

**Pros:** More defensible, validates assumptions
**Cons:** Slower, requires customer data

### Value Theory Approach

Estimate based on value delivered (also called "willingness to pay" or "value-based" sizing):

1. **Calculate customer pain point cost** — use the figure the user provides if given
2. **Estimate value of solution** — what fraction of the pain does the tool address?
3. **Apply capture rate** (typically 10-30% of value) — always state the percentage explicitly
4. **Still produce TAM/SAM/SOM** — value theory informs pricing, but the output must maintain the three-tier structure

When the user provides a specific cost figure (e.g., "$4.5M per breach"), reference that exact number in the output and build the calculation around it.

**Example:**
- Customer loses $100K/year to problem
- Solution captures 20%: $20K willingness to pay
- 100,000 potential customers: $2B market

## Trend Indicators

Apply three-valued logic to growth projections. Always include the Trend column in the Market Sizing Summary table.

- **INC (Increasing)**: Market growing >10% annually
- **CONST (Constant)**: Market growth 0-10% annually
- **DEC (Decreasing)**: Market contracting (negative growth rates, show as `-X.X%`)

Document evidence for each indicator — at minimum one analyst projection, adoption metric, or investment data point:
- INC: "Analyst projects 25% CAGR through 2027"
- CONST: "Mature market with 3% annual growth"
- DEC: "Legacy technology being displaced; revenue declined -12% YoY"

When the user asks about growth trends or CAGR specifically, expand the trend analysis with a sub-trend table breaking down growth by segment.

## Data Sources

**Primary Sources (Most Reliable):**
- Industry analyst reports (Gartner, Forrester, IDC)
- Government statistics (Census, BLS)
- Trade association data
- Company financials (public companies)

**Secondary Sources:**
- Market research firms (Statista, IBISWorld)
- News articles citing research
- Industry publications
- Competitor disclosures

**Estimation Sources (Use Carefully):**
- LinkedIn job counts × average salary
- Google Trends relative volume
- App store downloads × price
- Website traffic estimates

## Critical Output Requirements

Every market sizing output MUST include ALL of the following. Missing any of these is a failure:

1. **"Market Sizing Summary" header** with a markdown table containing rows for TAM, SAM, and SOM
2. **Concrete dollar values** (e.g., `$18.5B`, `$240M`) — NEVER use placeholder syntax like `$X.XB`, `$XXM`, or `[insert value]`
3. **Methodology identification** — explicitly state "Top-Down", "Bottom-Up", "Value Theory", or "Hybrid"
4. **"Key Assumptions" section** with at least two numbered, specific assumptions
5. **"Data Sources" section** referencing at least one named source
6. **"Confidence Level" section** with High, Medium, or Low assessment and explanation
7. **TAM > SAM > SOM hierarchy** — values must always follow this ordering

## Handling Vague or Ambiguous Requests

When the user provides minimal context (e.g., "market size for drones"):

1. **State your scope assumptions explicitly** — do not silently pick a segment
2. **Acknowledge market breadth** — name the major segments (e.g., commercial, consumer, military)
3. **Still produce a TAM/SAM/SOM structure** — even if the SOM must be conditional
4. **Ask clarifying questions at the end** — suggest which details would refine the analysis
5. **Never return just a single number** — always provide the full framework

## Handling Declining Markets

When sizing a contracting market:

1. **Use DEC trend indicator** and show negative growth rates (e.g., `-12.5% CAGR`)
2. **Include a decline trajectory table** showing year-over-year contraction
3. **Note risks and caveats** specific to entering or operating in a declining market
4. **Still provide complete TAM/SAM/SOM** — declining markets still have structure
5. **Include "Data Sources" section** — declining market claims need backing

## Output Structure

The output must follow this structure with REAL values (no placeholders):

```markdown
## Market Sizing Summary

| Metric | Value | Growth | Trend |
|--------|-------|--------|-------|
| TAM | $18.5B | 15% CAGR | INC |
| SAM | $4.6B | 14% CAGR | INC |
| SOM | $92M | - | - |

## Methodology
Top-Down

## TAM Calculation
[Step-by-step derivation with cited sources and concrete numbers]

## SAM Derivation
[How SAM was narrowed from TAM with specific percentages]

## SOM Justification
[Realistic share rationale with customer count or market share basis]

## Key Assumptions
1. Market growth rate of 15% CAGR sustained through 2028; if growth slows to 10%, TAM drops to $X
2. Target segment represents 35% of total market based on [source]

## Data Sources
- Gartner (2024): Market size and growth projections
- Census Bureau: Demographic data for customer count

## Confidence Level
Medium — Single methodology with multiple supporting data points. Would upgrade to High with bottom-up corroboration.
```

## Validation Rules

Before finalizing output, verify:

1. **Hierarchy check:** TAM > SAM > SOM — if this fails, re-examine your filtering logic
2. **No placeholders:** Search output for `$X`, `[insert`, `[Assumption`, `$XXM`, `TBD` — replace all with concrete values
3. **User input echo:** If the user provided a price point, cost figure, or other specific data, that exact value MUST appear in the output
4. **Methodology match:** If the user requested a specific methodology (bottom-up, value theory), the output must identify that methodology by name
5. **Trend evidence:** If trend indicators (INC/CONST/DEC) are used, at least one supporting data point must follow

## Common Pitfalls

- **Double-counting**: Ensure segments don't overlap
- **Currency confusion**: Specify USD/EUR and year
- **Stale data**: Note data age, adjust for growth
- **Over-optimism**: SOM should be conservative
- **Missing context**: Include methodology for credibility
- **Template residue**: Never leave template placeholders in final output — `$X.XB` or `[Source 1]` in the output is a failure

## Scenario Modeling

When the user requests scenarios (bear/base/bull), provide a range. The values MUST satisfy **Bear < Base < Bull** for every metric (TAM, SAM, SOM). Each scenario must include a rationale explaining its key drivers.

| Scenario | TAM | SAM | SOM |
|----------|-----|-----|-----|
| Bear | $5B | $500M | $10M |
| Base | $8B | $800M | $25M |
| Bull | $12B | $1.2B | $50M |

Never use placeholder values (`$X`, `$X.XB`, `[insert]`, `[Assumption`) in scenario tables — use concrete dollar amounts.

## Quality Checklist

Before delivering the output, mentally verify:

- [ ] "Market Sizing Summary" table is present with TAM, SAM, SOM rows
- [ ] All dollar values are concrete (no `$X.XB` patterns)
- [ ] TAM > SAM > SOM holds numerically
- [ ] Methodology is named explicitly
- [ ] Key Assumptions has at least 2 numbered items
- [ ] Data Sources names at least 1 real source
- [ ] Confidence Level states High/Medium/Low
- [ ] If user gave pricing/cost data, it appears verbatim in the output
- [ ] If scenarios requested, Bear < Base < Bull for all metrics
- [ ] If declining market, negative growth rate shown and risks noted

## Additional Resources

For detailed templates and examples, see:
- `references/sizing-methodologies.md` - Complete methodology guide
- `references/data-sources.md` - Source reliability ratings
- `examples/market-sizing-report.md` - Sample sizing report

## Orchestration Hints

- **Blackboard key**: `findings_sizing`
- **Cross-reference dimensions**: financial (revenue validation), competitive (player count and share)
- **Alert triggers**:
  - TAM deviation >30% from initial expectations
  - Growth rate reversal (INC→DEC or vice versa)
  - Segment emerging that wasn't in original scope
- **Confidence rules**:
  - High: Top-down and bottom-up estimates converge within 20%
  - Medium: Single methodology with 2+ supporting data points
  - Low: Single data point or significant methodology gaps
- **Conflict detection**:
  - Sum of competitor revenues vs total market size
  - Growth projections vs trend dimension's macro indicators
  - Segment sizes vs customer dimension's adoption estimates
