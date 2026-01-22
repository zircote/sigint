# Build vs. Buy Analysis Framework

## Decision Framework

### When to Build

**Strong Build Indicators**:
- Core competitive differentiator
- Unique requirements not met by market
- Long-term total cost advantage
- Critical control requirements
- Strong internal expertise
- Sensitive data/security concerns

**Build Questions**:
- Does this directly enable our competitive advantage?
- Would buying expose us to unacceptable risk?
- Do we have (or can we attract) the talent?
- Will requirements change frequently?
- Is time-to-market flexible?

### When to Buy

**Strong Buy Indicators**:
- Commodity functionality
- Time-to-market critical
- Mature market with proven solutions
- Limited internal expertise
- Maintenance burden undesirable
- Lower total cost of ownership

**Buy Questions**:
- Do multiple vendors solve this well?
- Is this a distraction from our core focus?
- Can we find solution with 80%+ fit?
- Is vendor stable and trustworthy?
- Are exit options reasonable?

---

## Weighted Scoring Matrix

| Factor | Weight | Build Score | Buy Score | Notes |
|--------|--------|-------------|-----------|-------|
| **Strategic** | 30% | | | |
| Core differentiator | | 1-5 | 1-5 | 5=critical to differentiation |
| Control requirements | | 1-5 | 1-5 | 5=complete control needed |
| IP/competitive concerns | | 1-5 | 1-5 | 5=high sensitivity |
| **Economic** | 25% | | | |
| Initial cost | | 1-5 | 1-5 | 5=lower cost |
| Ongoing cost (3yr) | | 1-5 | 1-5 | 5=lower cost |
| Opportunity cost | | 1-5 | 1-5 | 5=lower opportunity cost |
| **Capability** | 25% | | | |
| Feature fit | | 1-5 | 1-5 | 5=perfect fit |
| Integration ease | | 1-5 | 1-5 | 5=easy integration |
| Customization need | | 1-5 | 1-5 | 5=meets needs as-is |
| **Risk** | 20% | | | |
| Execution risk | | 1-5 | 1-5 | 5=low risk |
| Vendor/dependency risk | | 1-5 | 1-5 | 5=low risk |
| Timeline risk | | 1-5 | 1-5 | 5=low risk |

### Calculation

```
Build Score = Σ(Factor Score × Weight)
Buy Score = Σ(Factor Score × Weight)

If Build Score > Buy Score + 10%: Build
If Buy Score > Build Score + 10%: Buy
Otherwise: Deeper analysis needed
```

---

## Total Cost of Ownership (TCO) Template

### Build TCO

**Year 0 (Initial)**
| Item | Cost |
|------|------|
| Development (internal) | FTE × months × loaded rate |
| Development (contract) | Contract value |
| Infrastructure setup | Cloud/hardware |
| Training | Team enablement |
| Opportunity cost | What else could team build? |
| **Total Year 0** | $ |

**Years 1-3 (Ongoing Annual)**
| Item | Year 1 | Year 2 | Year 3 |
|------|--------|--------|--------|
| Maintenance (20-25% of dev) | $ | $ | $ |
| Infrastructure | $ | $ | $ |
| Enhancements | $ | $ | $ |
| Support | $ | $ | $ |
| **Total** | $ | $ | $ |

**3-Year Build TCO**: $

### Buy TCO

**Year 0 (Initial)**
| Item | Cost |
|------|------|
| License/subscription | Annual fee |
| Implementation | Vendor services |
| Integration development | Internal effort |
| Training | Team enablement |
| **Total Year 0** | $ |

**Years 1-3 (Ongoing Annual)**
| Item | Year 1 | Year 2 | Year 3 |
|------|--------|--------|--------|
| License/subscription | $ | $ | $ |
| Support tier | $ | $ | $ |
| Integration maintenance | $ | $ | $ |
| Internal admin | $ | $ | $ |
| **Total** | $ | $ | $ |

**3-Year Buy TCO**: $

---

## Risk Assessment

### Build Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Scope creep | H/M/L | H/M/L | Fixed scope, MVP first |
| Talent departure | H/M/L | H/M/L | Documentation, redundancy |
| Timeline slip | H/M/L | H/M/L | Buffer, phase releases |
| Technical failure | H/M/L | H/M/L | Proof of concept first |
| Ongoing burden | H/M/L | H/M/L | Plan for maintenance |

### Buy Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Vendor failure | H/M/L | H/M/L | Escrow, multi-vendor |
| Price increases | H/M/L | H/M/L | Long-term contract |
| Feature gaps | H/M/L | H/M/L | Roadmap review |
| Lock-in | H/M/L | H/M/L | Data portability |
| Security breach | H/M/L | H/M/L | Due diligence |

---

## Hybrid Options

### Buy + Customize
- Buy core platform
- Build differentiating features on top
- Best of both worlds
- Watch for API limitations

### Buy + Build Roadmap
- Buy now for speed
- Plan to build later if strategic
- De-risk with portability requirements
- Build internal expertise alongside

### Open Source + Build
- Leverage open source foundation
- Build proprietary layer
- Consider support contracts
- Plan for maintenance burden

---

## Decision Template

```markdown
## Build vs. Buy Decision: [Solution Area]

### Executive Summary
**Recommendation**: Build / Buy / Hybrid
**Confidence**: High / Medium / Low
**Key Driver**: [Primary reason]

### Scoring Summary
| Factor | Build | Buy | Winner |
|--------|-------|-----|--------|
| Strategic | X | X | Build/Buy |
| Economic | X | X | Build/Buy |
| Capability | X | X | Build/Buy |
| Risk | X | X | Build/Buy |
| **Total** | X | X | **Build/Buy** |

### TCO Comparison (3 Year)
- Build: $X
- Buy: $X
- Difference: $X (X%)

### Risk Assessment
- Primary Build Risk: [Risk and mitigation]
- Primary Buy Risk: [Risk and mitigation]

### Recommendation Rationale
[2-3 paragraphs explaining recommendation]

### Next Steps
1. [Action item]
2. [Action item]
3. [Action item]

### Trend Indicator
Solution Area Strategic Importance: INC / DEC / CONST
Build Capability Trend: INC / DEC / CONST
Buy Market Maturity: INC / DEC / CONST
```

---

## Common Mistakes

**Build Bias**:
- "We can do it better"
- Underestimating maintenance
- Not-invented-here syndrome
- Ignoring opportunity cost

**Buy Bias**:
- "Vendor will solve everything"
- Underestimating integration
- Ignoring lock-in
- Not negotiating hard enough

**Both**:
- Not considering hybrid options
- Ignoring hidden costs
- Short time horizon analysis
- Not involving all stakeholders
