# Trend Signal Identification

## Signal Categories

### Leading Indicators (Early Signals)

**Investment Activity**
- VC funding in category
- Corporate venture activity
- M&A activity
- IPO pipeline

**Research & Development**
- Patent filings
- Academic paper volume
- R&D job postings
- Conference paper topics

**Early Adopter Behavior**
- Developer tool adoption (GitHub stars)
- Technical blog posts
- Hacker News/Reddit discussions
- Early startup activity

### Coincident Indicators (Current State)

**Market Activity**
- Revenue growth rates
- Customer acquisition rates
- Pricing changes
- Market share shifts

**Employment Signals**
- Job posting volume
- Salary trends
- LinkedIn skill additions
- Certification demand

**Search & Social**
- Google Trends data
- Social media mentions
- News coverage volume
- Analyst report frequency

### Lagging Indicators (Confirmation)

**Financial Results**
- Public company earnings
- Market capitalization changes
- Profitability trends

**Adoption Metrics**
- Mainstream media coverage
- Regulatory attention
- Enterprise deployment
- Industry standard formation

---

## Signal Sources by Type

### Quantitative Signals

| Signal | Source | Frequency | Lead Time |
|--------|--------|-----------|-----------|
| VC funding | Crunchbase, PitchBook | Weekly | 12-24 months |
| Patent filings | USPTO, Google Patents | Monthly | 24-36 months |
| Job postings | LinkedIn, Indeed | Weekly | 6-12 months |
| Google Trends | Google Trends | Real-time | Coincident |
| GitHub activity | GitHub API | Daily | 6-18 months |

### Qualitative Signals

| Signal | Source | Assessment |
|--------|--------|------------|
| Expert opinions | Interviews, conferences | Interpret directionally |
| Customer feedback | Reviews, surveys | Look for patterns |
| Competitive moves | News, announcements | Validate with data |
| Regulatory signals | Government announcements | Long lead time |

---

## Signal Strength Assessment

### Strong Signal (INC/DEC confident)
- Multiple independent sources confirm
- Quantitative data supports direction
- Sustained over 3+ time periods
- Expert consensus aligns

### Moderate Signal (Directional)
- 2+ sources suggest direction
- Some quantitative support
- 2+ time periods
- Mixed expert views

### Weak Signal (Monitor)
- Single source
- Anecdotal evidence
- Short time frame
- Novel/uncertain

---

## Signal Detection Framework

### 1. Define Search Space
- What are you trying to detect?
- What would early signals look like?
- Where would signals appear first?

### 2. Establish Baseline
- Current state metrics
- Historical patterns
- Normal variation ranges

### 3. Monitor Systematically
- Set up alerts (Google Alerts, Crunchbase)
- Regular data pulls
- Periodic expert check-ins

### 4. Evaluate Significance
- Is change outside normal range?
- Multiple signals converging?
- Accelerating or decelerating?

### 5. Validate and Act
- Cross-reference sources
- Assess implications
- Update trend models

---

## Common Signal Patterns

### Technology Adoption Curve Signals

| Phase | Signals |
|-------|---------|
| Innovation | Academic papers, patents, research grants |
| Early Adoption | Startup founding, VC investment, developer tools |
| Early Majority | Enterprise pilots, job postings surge, analyst coverage |
| Late Majority | Mainstream news, regulatory frameworks, commodity pricing |
| Decline | Legacy mentions, replacement discussions, declining jobs |

### Market Shift Signals

| Pattern | Signals |
|---------|---------|
| Consolidation | M&A activity, fewer new entrants, price stability |
| Disruption | New entrants with different model, incumbent struggles |
| Expansion | Geographic expansion, new use cases, adjacent markets |
| Contraction | Revenue declines, layoffs, exits, price wars |

---

## Alert Setup Guide

### Google Alerts
```
"[industry] funding" OR "[industry] acquisition"
"[technology] adoption" OR "[technology] deployment"
"[competitor]" AND (launch OR announce OR release)
```

### Crunchbase Alerts
- Category funding activity
- Company funding rounds
- Key player acquisitions

### LinkedIn/Job Board Monitoring
- Skills growth in profiles
- Job posting volume trends
- New role titles emerging

---

## Signal-to-Noise Management

### Reduce Noise
- Filter by source reliability
- Require multiple confirmations
- Focus on quantitative over qualitative
- Set significance thresholds

### Avoid False Positives
- Don't overweight single events
- Consider base rates
- Look for sustained patterns
- Validate with experts

### Avoid False Negatives
- Don't dismiss weak signals entirely
- Monitor edge cases
- Consider unconventional sources
- Maintain broad scanning
