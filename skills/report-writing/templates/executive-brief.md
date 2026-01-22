---
name: Executive Brief
description: Concise one-page executive summary for leadership decision-making
variables:
  - TOPIC: Research topic or market name
  - DATE: Brief generation date
  - ONE_SENTENCE_SUMMARY: Bottom-line statement
  - TAM/SAM/SOM: Market sizing metrics
  - FINDING_*: Key findings (3)
  - PRIMARY_REC: Main recommendation
  - PRIMARY_RISK: Key risk to highlight
  - DECISION_STATEMENT: What decision is needed
  - OPTION_*: Decision options (3)
use-case: Executive-level summary requiring decision or action
output-format: Single-page Markdown with pie chart
---

# Executive Brief: {{TOPIC}}

**Date**: {{DATE}} | **Prepared by**: sigint

---

## Bottom Line

{{ONE_SENTENCE_SUMMARY}}

---

## Key Findings

1. **{{FINDING_1_TITLE}}**: {{FINDING_1_DETAIL}}

2. **{{FINDING_2_TITLE}}**: {{FINDING_2_DETAIL}}

3. **{{FINDING_3_TITLE}}**: {{FINDING_3_DETAIL}}

---

## Market Opportunity

| Metric | Value | Trend |
|--------|-------|-------|
| TAM | {{TAM}} | {{TAM_TREND}} |
| SAM | {{SAM}} | {{SAM_TREND}} |
| SOM (achievable) | {{SOM}} | - |

---

## Competitive Position

```mermaid
pie title Market Share
    {{PIE_DATA}}
```

**Our Position**: {{POSITION_SUMMARY}}

---

## Recommendation

**{{PRIMARY_REC}}**

- **Action**: {{REC_ACTION}}
- **Timeline**: {{REC_TIMELINE}}
- **Investment**: {{REC_INVESTMENT}}
- **Expected Return**: {{REC_RETURN}}

---

## Key Risk

**{{PRIMARY_RISK}}**: {{RISK_DESCRIPTION}}

**Mitigation**: {{RISK_MITIGATION}}

---

## Decision Required

{{DECISION_STATEMENT}}

**Options**:
1. {{OPTION_1}} - {{OPTION_1_TRADEOFF}}
2. {{OPTION_2}} - {{OPTION_2_TRADEOFF}}
3. {{OPTION_3}} - {{OPTION_3_TRADEOFF}}

---

*Full analysis available in detailed report*
