---
name: Technology Assessment
description: This skill should be used when the user asks to "assess technology", "technology evaluation", "tech stack analysis", "technical feasibility", "technology trends", "build vs buy", "technology roadmap", "architecture assessment", or needs guidance on evaluating technologies, technical due diligence, or technology strategy decisions.
version: 0.1.0
---

# Technology Assessment

## Overview

Technology assessment evaluates technologies for strategic fit, technical feasibility, and competitive advantage. This skill covers frameworks for making informed technology decisions.

## Critical Assessment Rules

Follow these rules to produce assessments that are honest, grounded, and actionable:

1. **Contextual Grounding**: Always tie scores, recommendations, and analysis back to the user's specific context (team size, scale, budget, timeline). A technology that scores 5/5 for Google may score 2/5 for a 10-person startup.
2. **Honest Scoring**: Do not inflate scores. A score of 2 or 3 is normal and valuable — it tells the user where the risks are. If a technology has known weaknesses, say so. Scores above 4 require strong justification.
3. **Decisive Recommendations**: End every assessment with a clear recommendation. "It depends" is not a recommendation. If the answer genuinely depends, specify what it depends ON and give a recommendation for each scenario.
4. **Trend Indicators Everywhere**: Apply INC/DEC/CONST trend indicators to every technology mentioned, not just the primary subject. Trend context helps the user understand trajectory.
5. **Domain Tailoring**: When the user's domain has specific considerations (AI/ML, fintech, healthcare, infrastructure), extend the standard framework with domain-specific evaluation criteria rather than using a generic checklist.
6. **Always Consider Alternatives**: Every assessment should mention at least 2-3 alternatives to the technology being assessed, with brief comparative notes. The user needs to know what else they could choose.
7. **Quantify When Possible**: Prefer concrete numbers over vague qualifiers. "50k msgs/sec" is better than "high throughput." "$23k/year" is better than "affordable." "3-6 months" is better than "some time."

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

**Show the math**: For each factor, multiply the score by the weight. Sum the weighted scores for Build and Buy separately. The option with the higher weighted total wins. Example: Strategic importance Build=3, weight=30% → 0.90. Display both the individual weighted contributions and the totals.

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

## Scoring Calibration

Use these anchor definitions to ensure consistent scoring across assessments:

| Score | Meaning | Example |
|-------|---------|---------|
| 1 | Critical weakness, likely blocker | No production deployments exist; vendor may not survive 12 months |
| 2 | Significant concern, requires mitigation | Works in limited scenarios but known scaling issues; small talent pool |
| 3 | Adequate, meets minimum requirements | Production-ready with caveats; moderate community; reasonable cost |
| 4 | Strong, clear advantage | Battle-tested at scale; large ecosystem; good cost/value ratio |
| 5 | Exceptional, best-in-class | Industry standard; massive community; proven at extreme scale |

**Inflation check**: If your overall score is above 4.0, re-examine each dimension. Technologies scoring 4+ across all dimensions are rare — most have at least one weak area (usually cost, talent availability, or operational complexity). An assessment with all 4s and 5s is almost certainly inflated.

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

### Domain-Specific Due Diligence Extensions

When the target company operates in a specialized domain, extend the standard four-area framework with domain-specific evaluation criteria. Every sub-item within Architecture Review, Code Quality, Operations, and Team must be covered — do not skip sub-items.

**AI/ML Companies**
- Model quality and defensibility (proprietary data, novel architecture, data moat)
- Training pipeline reproducibility (can a new engineer retrain from docs alone?)
- AI ethics and bias testing across protected classes
- Data licensing and transferability (do rights survive acquisition?)
- Regulatory exposure (AI Act, sector-specific AI regulations)

**Fintech Companies**
- Regulatory compliance (PCI-DSS, SOX, PSD2, banking licenses)
- Transaction processing integrity (double-entry, reconciliation)
- Fraud detection and prevention systems
- Audit trail completeness and cryptographic integrity

**Healthcare Companies**
- HIPAA/HITECH compliance (PHI handling, BAAs, breach notification)
- Clinical validation and FDA clearance status
- Interoperability standards (HL7 FHIR, DICOM)
- Patient data anonymization and de-identification pipelines

**Infrastructure/DevTools Companies**
- Multi-tenancy isolation guarantees
- API stability and backward compatibility track record
- Self-hosted vs. SaaS deployment model sustainability
- Open-source licensing compliance and contribution model

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

## Assessment Methodology

Follow this 4-step process for every assessment:

### Step 1: Understand Context
Before evaluating anything, extract the user's constraints:
- **Team size**: How many engineers will implement/maintain this?
- **Scale**: What volume/throughput/user count are they at now and targeting?
- **Budget**: What can they spend (time and money)?
- **Timeline**: When do they need this working?
- **Existing stack**: What are they already using that this must integrate with?

If the user doesn't provide these, state your assumptions explicitly.

### Step 2: Classify the Request
Determine which assessment type to produce:
- **Single technology assessment** → Use full output template (TRL, Hype Cycle, Evaluation Matrix, Risk, Recommendations)
- **Build vs. Buy analysis** → Use Build vs. Buy Matrix with weighted scoring and show the math
- **Tech stack analysis** → Use three-layer framework (Infrastructure, Platform, Application) with Stack Evaluation Criteria
- **Competitive comparison** → Use Competitive Technology Analysis table with trend indicators for each option
- **Technical due diligence** → Use four-area framework (Architecture, Code Quality, Operations, Team) plus domain extensions

### Step 3: Score and Analyze
- Apply the relevant framework completely — do not skip sections
- Score honestly — justify every score above 3 with specific evidence
- Apply trend indicators to all technologies mentioned
- Reference the user's specific constraints in scoring rationale

### Step 4: Recommend Decisively
- State your recommendation clearly in the first sentence
- Support with 2-3 key reasons tied to the user's constraints
- Acknowledge trade-offs honestly
- Provide a conditional alternative ("If X changes, then consider Y instead")

## Common Anti-Patterns

Avoid these failure modes that undermine assessment quality:

1. **Resume-Driven Assessment**: Recommending a technology because it's trendy rather than because it fits the user's constraints. Ask: "Would I recommend this if nobody was watching?"
2. **Score Inflation**: Giving everything 4s and 5s. If the average score across dimensions is above 3.5, verify each score has concrete justification. A realistic assessment of most technologies will have at least one dimension scoring 2 or 3.
3. **Framework Without Recommendation**: Presenting a beautifully structured analysis that ends with "it depends." The user hired you to make a call, not to organize their confusion.
4. **Ignoring Constraints**: Recommending Kubernetes to a 2-person team, or a $50k/year SaaS to a bootstrapped startup. Always check the user's stated constraints (team size, budget, timeline) and ensure recommendations are feasible within them.
5. **Hype Cycle Blindness**: Failing to position technologies on the hype cycle. Every technology has a hype trajectory. Ignoring it leaves the user vulnerable to adopting over-hyped tech or dismissing maturing tech.
6. **Missing the "Don't" Recommendation**: Sometimes the right answer is "don't adopt this technology." If the assessment reveals poor fit (overall score below 2.5, or critical dimension below 2), say so clearly.

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

## Orchestration Hints

- **Blackboard key**: `findings_tech`
- **Cross-reference dimensions**: trends (technology adoption curves), competitive (competitor tech stacks and capabilities)
- **Alert triggers**:
  - Disruptive technology at TRL 7+ (system prototype demonstrated)
  - Technology obsolescence risk for current market leaders
  - Build vs buy cost differential >3x
- **Confidence rules**:
  - High: Technology demonstrated at scale with public benchmarks
  - Medium: Multiple credible demonstrations or strong theoretical basis
  - Low: Early-stage or single-vendor claims only
- **Conflict detection**:
  - Technology readiness vs trend dimension's adoption timeline
  - Feasibility assessment vs competitive dimension's claimed capabilities
  - Cost estimates vs financial dimension's unit economics
