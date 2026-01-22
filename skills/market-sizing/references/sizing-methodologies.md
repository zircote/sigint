# Market Sizing Methodologies

## Top-Down Methodology

### When to Use
- Quick estimates needed
- Industry data is available
- Starting broad exploration

### Process

```
Industry Total → Segment → Geography → Realistic Share
```

**Step 1: Find Total Market**
- Use analyst reports (Gartner, IDC, Forrester)
- Trade association data
- Government statistics

**Step 2: Apply Segmentation**
- Product category percentage
- Customer type percentage
- Use case percentage

**Step 3: Geographic Adjustment**
- Regional percentage of global
- Currency conversion
- Local market factors

**Step 4: Realistic Share**
- Based on competitive intensity
- Resource constraints
- Go-to-market capability

### Example Calculation

```
Global Cloud Market:           $500B (TAM global)
├─ IaaS Segment (25%):         $125B (TAM segment)
│  ├─ North America (40%):     $50B  (SAM)
│  │  └─ SMB Focus (30%):      $15B  (SAM refined)
│  │     └─ Realistic 1%:      $150M (SOM)
```

### Advantages
- Fast
- Uses validated data
- Good for large markets

### Disadvantages
- May miss nuances
- Dependent on source accuracy
- Can overestimate opportunity

---

## Bottom-Up Methodology

### When to Use
- Defensible numbers needed
- Customer data available
- Novel market without research

### Process

```
Customer Count × Price × Penetration Rate = Market Size
```

**Step 1: Define Target Customer**
- Clear criteria for who qualifies
- Countable/estimable population

**Step 2: Estimate Customer Count**
- Industry databases
- Government registrations
- LinkedIn/professional networks
- Trade associations

**Step 3: Determine Price Point**
- Your pricing or market average
- Per-seat, per-company, usage-based

**Step 4: Apply Penetration Rate**
- Current category penetration
- Realistic adoption timeline

### Example Calculation

```
US Companies 100-1000 employees:     150,000 companies
├─ In target industries (40%):       60,000 companies
│  ├─ Avg contract value:            $25,000/year
│  │  └─ Fully penetrated:           $1.5B (TAM)
│  │     ├─ Reachable (50%):         $750M (SAM)
│  │     └─ 3-year target (5%):      $37.5M (SOM)
```

### Advantages
- Highly defensible
- Reveals assumptions
- Connects to sales model

### Disadvantages
- Time-consuming
- Requires customer data
- May underestimate if definition too narrow

---

## Value Theory Methodology

### When to Use
- New category creation
- Disrupting existing spend
- Value-based pricing

### Process

```
Pain Cost × Customers × Capture Rate = Market Potential
```

**Step 1: Quantify Customer Pain**
- Cost of current problem
- Lost revenue or efficiency
- Risk exposure value

**Step 2: Estimate Value Delivered**
- Percentage improvement
- Time/cost savings
- Risk mitigation value

**Step 3: Apply Capture Rate**
- Typically 10-30% of value created
- Based on competitive alternatives
- Willingness to pay research

### Example Calculation

```
Average company loses to problem:    $500K/year
├─ Solution captures 25% of value:   $125K willingness to pay
│  ├─ Actual pricing (50% of WTP):   $62.5K avg contract
│  │  └─ Target customers (10,000):  $625M (TAM)
```

### Advantages
- Justifies premium pricing
- Works for new categories
- Focuses on value creation

### Disadvantages
- Hard to validate
- Requires deep customer knowledge
- May overestimate willingness to pay

---

## Hybrid Approach

### Best Practice: Triangulate

Use multiple methods and compare:

| Method | TAM | SAM | SOM | Confidence |
|--------|-----|-----|-----|------------|
| Top-Down | $X | $X | $X | Medium |
| Bottom-Up | $X | $X | $X | High |
| Value Theory | $X | $X | $X | Low |
| **Consensus** | $X | $X | $X | - |

### Reconciliation
- If estimates diverge >50%, investigate assumptions
- Weight by confidence level
- Note range, not single number

---

## Data Source Reliability

| Source Type | Reliability | Use For |
|-------------|-------------|---------|
| Primary research | High | SOM, pricing |
| Analyst reports | Medium-High | TAM, trends |
| Public filings | High | Revenue benchmarks |
| News articles | Low-Medium | Directional signals |
| Expert estimates | Medium | Validation |
| Web scraping | Low | Rough sizing |

---

## Common Adjustments

### Growth Projections
```
Future TAM = Current TAM × (1 + CAGR)^years
```

### Currency Normalization
- Specify USD, EUR, etc.
- Note exchange rate date
- Use PPP for cost comparisons

### Inflation Adjustment
- Real vs. nominal growth
- Especially for multi-year projections
