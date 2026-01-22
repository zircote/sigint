# Unit Economics Deep Dive

## Core Metrics

### Customer Acquisition Cost (CAC)

**Definition**: Total cost to acquire one new customer.

**Formula**:
```
CAC = (Sales Cost + Marketing Cost) / New Customers Acquired
```

**Components**:
- Sales salaries and commissions
- Marketing spend (paid, content, events)
- Sales/marketing tools
- Agency fees
- Allocated overhead

**Calculation Period**: Typically monthly or quarterly

**Benchmarks by Stage**:
| Stage | Typical CAC | Notes |
|-------|-------------|-------|
| Early | Higher, variable | Finding channels |
| Growth | Stabilizing | Channel optimization |
| Scale | Optimized | Efficient machine |

**CAC by Channel**:
| Channel | Typical CAC | Scalability |
|---------|-------------|-------------|
| Organic/SEO | Low ($10-50) | Limited |
| Content Marketing | Low-Medium ($50-200) | Medium |
| Paid Search | Medium ($100-500) | High |
| Outbound Sales | High ($500-2000+) | Medium |
| Events | Variable | Limited |

---

### Lifetime Value (LTV)

**Definition**: Total revenue expected from a customer over their lifetime.

**Simple Formula**:
```
LTV = ARPU × Gross Margin × Customer Lifetime
```

**Alternative (using churn)**:
```
LTV = (ARPU × Gross Margin) / Monthly Churn Rate
```

**With Expansion**:
```
LTV = (ARPU × Gross Margin × (1 + Monthly Expansion Rate)) / Monthly Churn Rate
```

**Components**:
- Average Revenue Per User (ARPU)
- Gross Margin (exclude COGS)
- Retention/churn rates
- Expansion revenue

**Benchmarks**:
| Metric | Good | Great | Excellent |
|--------|------|-------|-----------|
| LTV (SaaS) | $5K+ | $25K+ | $100K+ |
| Gross Margin | 60%+ | 70%+ | 80%+ |
| Net Revenue Retention | 100%+ | 110%+ | 130%+ |

---

### LTV:CAC Ratio

**Definition**: Return on customer acquisition investment.

**Formula**:
```
LTV:CAC = LTV / CAC
```

**Interpretation**:
| Ratio | Meaning |
|-------|---------|
| < 1:1 | Losing money on customers |
| 1:1 - 3:1 | Marginal/risky |
| 3:1 - 5:1 | Healthy |
| > 5:1 | May be under-investing in growth |

**Trend Analysis**:
- INC LTV:CAC: Improving unit economics
- DEC LTV:CAC: Warning sign - investigate
- CONST LTV:CAC: Stable, optimize elsewhere

---

### CAC Payback Period

**Definition**: Months to recover customer acquisition cost.

**Formula**:
```
Payback = CAC / (Monthly ARPU × Gross Margin)
```

**Benchmarks**:
| Stage | Target Payback |
|-------|----------------|
| Early/Funded | < 24 months |
| Growth | < 18 months |
| Efficient | < 12 months |
| Excellent | < 6 months |

**Why It Matters**:
- Cash flow efficiency
- Ability to reinvest in growth
- Lower = less capital required

---

## Advanced Concepts

### Cohort Analysis

Track metrics by customer cohort (month/quarter acquired):

```markdown
| Cohort | Month 0 | Month 3 | Month 6 | Month 12 |
|--------|---------|---------|---------|----------|
| Jan 24 | $100K | $95K | $92K | $88K |
| Apr 24 | $120K | $118K | $115K | - |
| Jul 24 | $150K | $148K | - | - |
```

**What to Look For**:
- Improving retention over time
- Faster ramp to full ARPU
- Lower churn in recent cohorts

### Contribution Margin

**Definition**: Per-customer profitability before fixed costs.

**Formula**:
```
Contribution Margin = Revenue - Variable Costs
CM% = Contribution Margin / Revenue
```

**Variable Costs Include**:
- Hosting/infrastructure (per customer)
- Support (per customer)
- Payment processing
- Third-party API costs

### Magic Number

**Definition**: Sales efficiency metric.

**Formula**:
```
Magic Number = (Current Quarter Revenue - Previous Quarter Revenue) × 4 / Previous Quarter S&M Spend
```

**Interpretation**:
| Magic Number | Meaning |
|--------------|---------|
| < 0.5 | Inefficient - reduce spend |
| 0.5 - 0.75 | Moderate - optimize |
| 0.75 - 1.0 | Good efficiency |
| > 1.0 | Excellent - consider increasing spend |

---

## Unit Economics by Business Model

### SaaS (Subscription)

| Metric | Formula | Benchmark |
|--------|---------|-----------|
| MRR | Sum of monthly subscriptions | - |
| ARR | MRR × 12 | - |
| ARPU | MRR / Customers | Varies |
| Net MRR Churn | (Lost MRR - Expansion MRR) / Starting MRR | < 0% |
| NRR | (Starting MRR + Expansion - Contraction - Churn) / Starting MRR | > 110% |

### Marketplace

| Metric | Formula | Benchmark |
|--------|---------|-----------|
| GMV | Total transaction value | - |
| Take Rate | Revenue / GMV | 5-30% |
| CAC | As above | Varies |
| LTV | Take Rate × Avg Order × Orders per Customer Lifetime | - |

### Usage-Based

| Metric | Formula | Benchmark |
|--------|---------|-----------|
| ARPU | Monthly usage revenue / Customers | Varies |
| Expansion Rate | MoM ARPU growth | > 0% |
| Usage Churn | % customers with declining usage | < 5% |

---

## Red Flags

### Warning Signs

| Signal | Concern | Action |
|--------|---------|--------|
| Rising CAC | Channel saturation | Test new channels |
| Falling LTV | Retention issues | Investigate churn |
| LTV:CAC declining | Unit economics deteriorating | Full audit |
| Payback > 24mo | Cash flow risk | Reduce CAC or raise price |
| NRR < 100% | Contraction > expansion | Product/success focus |

### Trend Indicators

| Metric | INC Meaning | DEC Meaning |
|--------|-------------|-------------|
| CAC | Efficiency declining | Efficiency improving |
| LTV | Customer value growing | Customer value declining |
| LTV:CAC | Healthier economics | Deteriorating economics |
| Payback | Slower recovery | Faster recovery |

---

## Analysis Template

```markdown
## Unit Economics Analysis: [Company/Product]

### Key Metrics
| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| CAC | $ | $ | 🟢/🟡/🔴 |
| LTV | $ | $ | 🟢/🟡/🔴 |
| LTV:CAC | X:1 | 3:1 | 🟢/🟡/🔴 |
| Payback | X mo | 12 mo | 🟢/🟡/🔴 |
| Gross Margin | X% | 70% | 🟢/🟡/🔴 |
| NRR | X% | 100% | 🟢/🟡/🔴 |

### Trend Analysis
| Metric | 6mo Ago | Current | Trend |
|--------|---------|---------|-------|
| CAC | $ | $ | INC/DEC/CONST |
| LTV | $ | $ | INC/DEC/CONST |
| LTV:CAC | X:1 | X:1 | INC/DEC/CONST |

### Unit Economics Health: [Strong/Moderate/Weak]

### Key Insights
1. [Insight 1]
2. [Insight 2]

### Recommendations
1. [Recommendation 1]
2. [Recommendation 2]
```

---

## References

Ries, E. (2011). *The Lean Startup*. Crown Business.
Blank, S. (2012). *The Startup Owner's Manual*. K&S Ranch.
Tunguz, T. (2015). *Winning with Data*. Wiley.
