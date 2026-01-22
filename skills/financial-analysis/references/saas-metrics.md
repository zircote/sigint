# SaaS Metrics Reference

## Revenue Metrics

### Monthly Recurring Revenue (MRR)

**Definition**: Predictable monthly revenue from subscriptions.

**Formula**:
```
MRR = Σ(Monthly subscription value for all active customers)
```

**MRR Components**:
| Component | Formula |
|-----------|---------|
| New MRR | MRR from new customers |
| Expansion MRR | Upsells + cross-sells |
| Contraction MRR | Downgrades |
| Churned MRR | Lost subscriptions |
| Net New MRR | New + Expansion - Contraction - Churned |

### Annual Recurring Revenue (ARR)

**Formula**:
```
ARR = MRR × 12
```

**When to Use**:
- ARR: Enterprise SaaS, annual contracts
- MRR: SMB SaaS, monthly contracts

### Annual Contract Value (ACV)

**Definition**: Average annualized revenue per contract.

**Formula**:
```
ACV = Total Contract Value / Contract Years
```

### Total Contract Value (TCV)

**Definition**: Total value of a contract including all years.

**Formula**:
```
TCV = ACV × Contract Length + One-time Fees
```

---

## Growth Metrics

### MRR Growth Rate

**Monthly**:
```
MoM Growth = (Current MRR - Previous MRR) / Previous MRR
```

**Year-over-Year**:
```
YoY Growth = (Current MRR - MRR 12 months ago) / MRR 12 months ago
```

### Growth Benchmarks

| ARR Range | Good Growth | Great Growth |
|-----------|-------------|--------------|
| $0-1M | >15% MoM | >20% MoM |
| $1-10M | >10% MoM | >15% MoM |
| $10-50M | 80%+ YoY | 100%+ YoY |
| $50-100M | 50%+ YoY | 70%+ YoY |
| $100M+ | 30%+ YoY | 50%+ YoY |

### Quick Ratio

**Definition**: Growth efficiency measure.

**Formula**:
```
Quick Ratio = (New MRR + Expansion MRR) / (Churned MRR + Contraction MRR)
```

**Interpretation**:
| Ratio | Meaning |
|-------|---------|
| < 1 | Shrinking |
| 1-2 | Slow growth |
| 2-4 | Good growth |
| > 4 | Excellent growth |

---

## Retention Metrics

### Gross Revenue Retention (GRR)

**Definition**: Revenue retained excluding expansion.

**Formula**:
```
GRR = (Starting MRR - Churned MRR - Contraction MRR) / Starting MRR
```

**Benchmarks**:
| Segment | Good | Great |
|---------|------|-------|
| SMB | >80% | >85% |
| Mid-Market | >85% | >90% |
| Enterprise | >90% | >95% |

### Net Revenue Retention (NRR)

**Definition**: Revenue retained including expansion.

**Formula**:
```
NRR = (Starting MRR + Expansion - Contraction - Churned) / Starting MRR
```

**Benchmarks**:
| Segment | Good | Great | Excellent |
|---------|------|-------|-----------|
| SMB | >90% | >100% | >110% |
| Mid-Market | >100% | >110% | >120% |
| Enterprise | >110% | >120% | >130% |

**NRR > 100%** means expansion exceeds churn.

### Logo Retention

**Definition**: Percentage of customers retained.

**Formula**:
```
Logo Retention = (Starting Customers - Churned Customers) / Starting Customers
```

### Churn Metrics

| Metric | Formula | Good | Great |
|--------|---------|------|-------|
| Monthly Churn | Churned / Starting | <3% | <1% |
| Annual Churn | 1 - (1 - Monthly)^12 | <30% | <10% |
| Logo Churn | Churned Customers / Starting Customers | <5% | <2% |

---

## Efficiency Metrics

### Rule of 40

**Formula**:
```
Rule of 40 = Growth Rate % + Profit Margin %
```

**Interpretation**:
| Score | Assessment |
|-------|------------|
| < 20 | Concerning |
| 20-40 | Acceptable |
| 40-60 | Strong |
| > 60 | Excellent |

### Burn Multiple

**Definition**: How much you burn for each dollar of ARR growth.

**Formula**:
```
Burn Multiple = Net Burn / Net New ARR
```

**Interpretation**:
| Multiple | Meaning |
|----------|---------|
| < 1x | Excellent efficiency |
| 1-2x | Good |
| 2-3x | Acceptable for early stage |
| > 3x | Inefficient |

### Sales Efficiency (Magic Number)

**Formula**:
```
Magic Number = Net New ARR / S&M Spend (previous quarter)
```

**Interpretation**:
| Number | Action |
|--------|--------|
| < 0.5 | Slow down spend |
| 0.5-1.0 | Optimize |
| > 1.0 | Increase spend |

---

## Customer Metrics

### Average Revenue Per User (ARPU)

**Formula**:
```
ARPU = MRR / Total Customers
```

### Customer Concentration

**Metric**: % of revenue from top 10 customers

**Risk Levels**:
| Concentration | Risk |
|---------------|------|
| < 10% | Low |
| 10-25% | Moderate |
| > 25% | High |

### Customer Health Score

Composite metric including:
- Product usage frequency
- Feature adoption depth
- Support ticket sentiment
- Engagement with CS
- Payment health

---

## Trend Analysis

### Metric Trend Indicators

| Metric | INC | DEC | CONST |
|--------|-----|-----|-------|
| MRR | Growing | Declining | Stagnant |
| NRR | Improving retention | Worsening retention | Stable |
| Churn | Warning sign | Improvement | Stable |
| CAC | Channels saturating | Efficiency improving | Stable |
| Quick Ratio | Accelerating | Decelerating | Steady state |

### Cohort Trend Analysis

Compare cohorts over time:
```markdown
| Metric | Q1 Cohort | Q2 Cohort | Q3 Cohort | Trend |
|--------|-----------|-----------|-----------|-------|
| Month 3 NRR | 95% | 97% | 99% | INC |
| Month 6 NRR | 92% | 95% | - | INC |
| Month 12 NRR | 88% | - | - | - |
```

---

## SaaS Metrics Dashboard Template

```markdown
## SaaS Metrics Summary

### Revenue
| Metric | Current | Previous | Change | Trend |
|--------|---------|----------|--------|-------|
| MRR | $X | $X | X% | INC/DEC/CONST |
| ARR | $X | $X | X% | INC/DEC/CONST |
| ARPU | $X | $X | X% | INC/DEC/CONST |

### Growth
| Metric | Current | Benchmark | Status |
|--------|---------|-----------|--------|
| MoM Growth | X% | 10% | 🟢/🟡/🔴 |
| Quick Ratio | X | 2.0 | 🟢/🟡/🔴 |
| Net New MRR | $X | - | - |

### Retention
| Metric | Current | Benchmark | Status |
|--------|---------|-----------|--------|
| GRR | X% | 90% | 🟢/🟡/🔴 |
| NRR | X% | 110% | 🟢/🟡/🔴 |
| Logo Retention | X% | 95% | 🟢/🟡/🔴 |

### Efficiency
| Metric | Current | Benchmark | Status |
|--------|---------|-----------|--------|
| Rule of 40 | X | 40 | 🟢/🟡/🔴 |
| Magic Number | X | 1.0 | 🟢/🟡/🔴 |
| LTV:CAC | X:1 | 3:1 | 🟢/🟡/🔴 |

### MRR Bridge
| Component | Value |
|-----------|-------|
| Starting MRR | $X |
| + New | $X |
| + Expansion | $X |
| - Contraction | $X |
| - Churned | $X |
| = Ending MRR | $X |
```

---

## References

Tunguz, T. (various). "SaaS Metrics" blog posts.
SaaS Capital. Annual SaaS benchmarks reports.
OpenView. SaaS Benchmarks reports.
