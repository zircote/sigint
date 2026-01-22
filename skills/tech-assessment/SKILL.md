---
name: Technology Assessment
description: This skill should be used when the user asks to "assess technology", "technology evaluation", "tech stack analysis", "technical feasibility", "technology trends", "build vs buy", "technology roadmap", "architecture assessment", or needs guidance on evaluating technologies, technical due diligence, or technology strategy decisions.
version: 0.1.0
---

# Technology Assessment

## Overview

Technology assessment evaluates technologies for strategic fit, technical feasibility, and competitive advantage. This skill covers frameworks for making informed technology decisions.

## Assessment Dimensions

### Technical Maturity
- Proven vs. emerging
- Stability and reliability
- Community/ecosystem size
- Documentation quality

### Strategic Fit
- Alignment with business goals
- Competitive differentiation potential
- Integration with existing systems
- Scalability trajectory

### Risk Profile
- Technology risk (will it work?)
- Adoption risk (will people use it?)
- Vendor risk (will they survive?)
- Security risk (vulnerabilities)

### Economic Factors
- Total cost of ownership
- Time to value
- Resource requirements
- Opportunity cost

## Technology Readiness Levels (TRL)

| Level | Description | Characteristics |
|-------|-------------|-----------------|
| TRL 1-3 | Research | Concept only, no implementation |
| TRL 4-6 | Development | Prototype, limited deployment |
| TRL 7-8 | Production | Proven at scale, enterprise-ready |
| TRL 9 | Mature | Widely adopted, commoditized |

## Gartner Hype Cycle Mapping

Position technologies on the hype cycle:

1. **Innovation Trigger**: New technology emerges
2. **Peak of Inflated Expectations**: Hype exceeds reality
3. **Trough of Disillusionment**: Reality sets in
4. **Slope of Enlightenment**: Practical use cases emerge
5. **Plateau of Productivity**: Mainstream adoption

## Build vs. Buy Framework

### Build When:
- Core competitive differentiator
- Unique requirements not met by market
- Long-term cost advantage
- Internal expertise available
- Control is critical

### Buy When:
- Commodity functionality
- Time-to-market critical
- Proven solutions exist
- Maintenance burden undesirable
- Lower total cost of ownership

### Build vs. Buy Matrix

| Factor | Weight | Build Score | Buy Score |
|--------|--------|-------------|-----------|
| Strategic importance | 30% | 1-5 | 1-5 |
| Differentiation | 25% | 1-5 | 1-5 |
| Time to market | 20% | 1-5 | 1-5 |
| Total cost | 15% | 1-5 | 1-5 |
| Risk | 10% | 1-5 | 1-5 |
| **Weighted Total** | 100% | X.X | X.X |

## Technology Stack Analysis

### Layers to Assess

**Infrastructure**
- Cloud provider (AWS, Azure, GCP)
- Compute (containers, serverless, VMs)
- Storage and databases
- Networking

**Platform**
- Application frameworks
- Runtime environments
- Development tools
- CI/CD pipeline

**Application**
- Core product technologies
- Third-party integrations
- APIs and services
- Security stack

### Stack Evaluation Criteria

| Criterion | Question | Weight |
|-----------|----------|--------|
| Performance | Does it meet requirements? | High |
| Scalability | Can it grow with us? | High |
| Maintainability | Easy to support? | Medium |
| Security | Meets compliance needs? | High |
| Cost | Fits budget? | Medium |
| Talent | Can we hire for it? | Medium |
| Community | Active ecosystem? | Low |

## Trend Indicators for Technologies

Apply three-valued logic:

**INC (Increasing adoption)**
- Growing community
- Increasing job postings
- Rising search interest
- New investment/funding

**DEC (Decreasing adoption)**
- Shrinking community
- Declining job postings
- Migration to alternatives
- Vendor instability

**CONST (Stable)**
- Mature, established
- Steady usage patterns
- No major changes

## Competitive Technology Analysis

Assess how competitors use technology:

| Competitor | Key Technologies | Strengths | Weaknesses | Trend |
|------------|------------------|-----------|------------|-------|
| A | [Stack] | [Advantage] | [Gap] | INC/DEC/CONST |
| B | [Stack] | [Advantage] | [Gap] | INC/DEC/CONST |

## Technical Due Diligence

For M&A or partnership evaluation:

### Architecture Review
- System design and patterns
- Scalability approach
- Technical debt level
- Documentation quality

### Code Quality
- Testing coverage
- Code review practices
- Security practices
- Performance benchmarks

### Operations
- Deployment processes
- Monitoring and observability
- Incident response
- SLA track record

### Team
- Skills and expertise
- Key person dependencies
- Knowledge documentation
- Retention risk

## Output Structure

```markdown
## Technology Assessment Summary

### Technology: [Name]
**TRL**: [Level]
**Hype Cycle Position**: [Stage]
**Trend**: INC/DEC/CONST

### Evaluation Matrix
| Dimension | Score (1-5) | Notes |
|-----------|-------------|-------|
| Technical Maturity | X | [Note] |
| Strategic Fit | X | [Note] |
| Risk Profile | X | [Note] |
| Economic Factors | X | [Note] |
| **Overall** | X.X | |

### Build vs. Buy Recommendation
[Recommendation with rationale]

### Competitive Position
[How this tech compares to alternatives]

### Risk Assessment
- **Primary Risk**: [Risk and mitigation]
- **Secondary Risk**: [Risk and mitigation]

### Recommendations
1. [Recommendation]
2. [Recommendation]

### Monitoring Indicators
- [What to watch]
- [What to watch]
```

## Best Practices

- Evaluate against actual use cases, not theoretical
- Include non-technical stakeholders in assessment
- Consider long-term maintenance, not just implementation
- Document assumptions and update as they change
- Prototype before committing to major decisions

## Additional Resources

For detailed frameworks, see:
- `references/tech-evaluation-matrix.md` - Complete evaluation template
- `references/build-buy-analysis.md` - Detailed build vs. buy
- `examples/tech-assessment-report.md` - Sample assessment
