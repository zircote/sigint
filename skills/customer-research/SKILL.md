---
name: customer-research
description: This skill should be used when the user asks to "understand customers", "customer research", "user personas", "customer needs analysis", "buyer journey mapping", "voice of customer", "customer segmentation", "user research", or needs guidance on customer discovery methodologies, persona development, or understanding buyer behavior.
version: 0.1.0
---

# Customer Research

## Overview

Customer research systematically gathers insights about target users to inform product and market decisions. This skill covers methodologies for understanding customer needs, behaviors, and preferences.

## Required Frameworks

| Framework | Output Section | Required | Condition |
|-----------|---------------|----------|-----------|
| Persona Development | Customer Personas | yes | — |
| Jobs-to-be-Done | JTBD Analysis | yes | — |
| Journey Mapping | Customer Journey | yes | — |
| Segmentation & Prioritization | Customer Segments | yes | — |

**Trend Indicators**: Load and apply the trend indicator definitions from `protocols/TREND-INDICATORS.md`.

## Research Types

### Quantitative Research
- Surveys and questionnaires
- Usage analytics
- A/B testing results
- Market share data
- NPS/satisfaction scores

### Qualitative Research
- Customer interviews
- Focus groups
- Observation studies
- Support ticket analysis
- Review mining

## Persona Development

### Core Elements

**Demographics**
- Age range
- Job title/role
- Industry
- Company size
- Location

**Psychographics**
- Goals and motivations
- Pain points and frustrations
- Decision-making style
- Information sources
- Technology comfort

**Behaviors**
- Current solutions used
- Buying process
- Key triggers
- Evaluation criteria

### Persona Template

```markdown
## [Persona Name]

### Profile
- **Role**: [Job title]
- **Company**: [Size, industry]
- **Experience**: [Years in role]

### Goals
1. [Primary goal]
2. [Secondary goal]
3. [Tertiary goal]

### Pain Points
1. [Major frustration]
2. [Secondary frustration]
3. [Minor annoyance]

### Quote
"[Representative statement capturing mindset]"

### Buying Behavior
- **Trigger**: [What prompts search]
- **Research**: [How they evaluate]
- **Decision**: [Who/what influences]
- **Timeline**: [Typical cycle length]

### Preferred Channels
- [Channel 1]
- [Channel 2]
```

## Jobs-to-be-Done Framework

Focus on what customers are trying to accomplish:

**Functional Jobs**
- Core task to complete
- Measurable outcomes desired

**Emotional Jobs**
- How they want to feel
- Social perception goals

**Related Jobs**
- Before/after the core job
- Supporting tasks

### JTBD Statement Format
"When [situation], I want to [motivation], so I can [expected outcome]."

**Example:**
"When I'm preparing a market analysis, I want to quickly find reliable data, so I can make confident recommendations to leadership."

## Customer Journey Mapping

### Journey Stages

1. **Awareness**
   - How do they discover they have a need?
   - What triggers the search?

2. **Consideration**
   - What options do they evaluate?
   - What criteria matter most?

3. **Decision**
   - Who influences the choice?
   - What tips the decision?

4. **Purchase**
   - What friction points exist?
   - What enables conversion?

5. **Onboarding**
   - First experience expectations
   - Success metrics

6. **Retention/Advocacy**
   - What drives continued use?
   - What triggers referrals?

### Journey Map Template

| Stage | Actions | Thoughts | Emotions | Pain Points | Opportunities |
|-------|---------|----------|----------|-------------|---------------|
| Awareness | | | | | |
| Consideration | | | | | |
| Decision | | | | | |
| Purchase | | | | | |
| Onboarding | | | | | |
| Retention | | | | | |

## Data Collection Methods

### Interview Framework

> **Note:** This section applies when conducting primary research interviews. For AI secondary research synthesis, use these as topic weighting guides rather than time allocations.

**Opening (5 min)**
- Build rapport
- Explain purpose
- Get permission to record

**Current State (15 min)**
- Walk me through your typical workflow
- What tools do you use?
- What's working well?

**Pain Points (15 min)**
- What's most frustrating?
- Tell me about a recent challenge
- What would make your life easier?

**Ideal State (10 min)**
- If you could wave a magic wand...
- What would success look like?
- How would you measure it?

**Closing (5 min)**
- Anything else to add?
- Can I follow up?
- Referrals?

### Review Mining

Extract insights from:
- G2, Capterra, TrustRadius
- App store reviews
- Reddit discussions
- Twitter/social mentions
- Support forums

**What to look for:**
- Repeated complaints
- Feature requests
- Competitor comparisons
- Use case descriptions
- Emotional language

## Segmentation

### Segmentation Criteria

**Demographic**: Company size, industry, role
**Behavioral**: Usage patterns, buying frequency
**Needs-based**: Problem severity, sophistication
**Value-based**: Revenue potential, strategic fit

### Segment Prioritization

| Segment | Size | Need Intensity | Accessibility | Competition | Priority |
|---------|------|----------------|---------------|-------------|----------|
| [Name] | S/M/L | H/M/L | H/M/L | H/M/L | 1-5 |

## Output Structure

```markdown
## Customer Research Summary

### Key Segments
1. [Segment 1]: [Description, size]
2. [Segment 2]: [Description, size]

### Personas
[Persona summaries]

### Jobs-to-be-Done
1. [Core job]
2. [Supporting job]

### Journey Insights
- **Awareness**: [Key finding]
- **Consideration**: [Key finding]
- **Decision**: [Key finding]

### Pain Points (Ranked)
1. [Most severe]
2. [Second]
3. [Third]

### Opportunities
1. [Unmet need 1]
2. [Unmet need 2]

### Trend Indicators
- Customer sophistication: INC/DEC/CONST
- Willingness to pay: INC/DEC/CONST
- Switching propensity: INC/DEC/CONST
```

## Mandatory Output Rules

1. Every persona must include: name, role, company size, key pain points, buying triggers
2. Every segment must include: size estimate, growth direction (INC/DEC/CONST), confidence level
3. All claims must cite specific sources (see `protocols/TREND-INDICATORS.md`)
4. NEVER use placeholder values ($X, TBD, [insert])
5. Minimum 3 customer segments identified

## Pre-Output Validation Checklist

- [ ] All personas have complete fields (name, role, company size, pain points, buying triggers)
- [ ] All segments have size estimates with sources
- [ ] No placeholder values remain
- [ ] Confidence levels assigned per universal scale
- [ ] Gaps documented in findings.gaps[]
- [ ] Trend indicators (INC/DEC/CONST) applied to customer behavior metrics
- [ ] At least 3 customer segments identified
- [ ] Pain points ranked by severity with evidence

## Best Practices

- Talk to actual customers, not just internal assumptions
- Include churned customers and non-customers
- Distinguish between stated and revealed preferences
- Update research regularly (behaviors change)
- Quantify qualitative insights where possible

## Additional Resources

For detailed frameworks, see:
- `references/interview-guide.md` - Interview techniques
- `references/persona-examples.md` - Sample personas
- `examples/journey-map.md` - Complete journey map

## Orchestration Hints

**Confidence tiers (universal scale):**
- **High**: 3+ independent, recent (<12mo) sources that converge
- **Medium**: 2 sources OR sources >12mo old OR indirect evidence
- **Low**: Single source, inference, or extrapolation

Dimension-specific confidence criteria below REFINE (not replace) these universal definitions.

- **Blackboard key**: `findings_customer`
- **Cross-reference dimensions**: competitive (feature gaps map to unmet needs), financial (willingness to pay, price sensitivity)
- **Alert triggers**:
  - Unmet customer need with no existing solution in market
  - Customer segment not previously identified in scope
  - Switching cost barrier that invalidates competitive assumptions
- **Confidence rules**:
  - High: Multiple customer data sources (surveys, reviews, interviews) align
  - Medium: 2 data sources or strong proxy indicators
  - Low: Single source or inferred from adjacent markets
- **Conflict detection**:
  - Customer willingness-to-pay vs financial dimension's pricing models
  - Feature importance ranking vs competitive dimension's feature matrices
  - Segment sizes vs sizing dimension's SAM calculations
