---
description: Begin a new market research session with comprehensive scoping
version: 0.1.0
argument-hint: [<topic>]
allowed-tools: Read, Write, Grep, Glob, TaskCreate, TaskUpdate, AskUserQuestion
---

Initialize a new sigint research session through structured elicitation.

**If topic provided:** Use as starting point but still conduct elicitation.
**If no topic:** Begin with open discovery elicitation.

---

## Phase 1: Research Context Elicitation

Before any research begins, gather comprehensive context through structured questions. Use AskUserQuestion for each elicitation block.

### 1.1 Decision Context

**Question:** "What decision or action will this research inform?"

Options:
- Market entry decision (should we enter this market?)
- Product positioning (how should we position against competitors?)
- Investment/funding (preparing for investors or evaluating investment)
- Pricing strategy (how should we price our offering?)
- Partnership evaluation (assessing potential partners or acquisitions)
- Strategic planning (informing roadmap or business strategy)
- Other (let user specify)

**Follow-up based on response:**
- Market entry → Ask about risk tolerance, timeline to decision
- Product positioning → Ask about current positioning, target segment
- Investment → Ask about stage, amount seeking, investor type
- Pricing → Ask about current pricing, cost structure awareness
- Partnership → Ask about specific targets or criteria
- Strategic planning → Ask about planning horizon, key uncertainties

### 1.2 Stakeholder & Audience

**Question:** "Who will consume this research and what do they need?"

Options (multi-select):
- Executive leadership (high-level strategic insights)
- Board/investors (market opportunity, risk assessment)
- Product team (competitive features, customer needs)
- Sales/marketing (positioning, messaging, battlecards)
- Technical team (technology landscape, build vs buy)
- External presentation (pitch deck, public materials)

**Follow-up:** "What's their familiarity with this market?"
- Expert (deep domain knowledge)
- Familiar (general awareness)
- New to this space (need foundational context)

### 1.3 Prior Knowledge & Assumptions

**Question:** "What do you already know or believe about this market?"

Gather free-form response, then ask:

**Question:** "Are there specific assumptions you want validated or challenged?"

Options:
- Yes, I have specific hypotheses to test
- No, this is exploratory research
- I have some intuitions but they're soft

If yes: Elicit 2-5 specific hypotheses to validate.

### 1.4 Scope Definition

**Question:** "What geographic scope?"

Options:
- Global
- North America
- Europe
- Asia-Pacific
- Specific countries (specify)
- Multiple regions (specify)

**Question:** "What market segments or verticals to focus on?"

Options:
- Enterprise (large organizations)
- Mid-market (100-1000 employees)
- SMB (small businesses)
- Consumer/B2C
- Specific verticals (specify)
- All segments

**Question:** "What time horizon matters?"

Options:
- Current state (next 0-12 months)
- Near-term (1-3 years)
- Long-term (3-5+ years)
- All horizons with emphasis on near-term

### 1.5 Competitive Context

**Question:** "Are there specific competitors you're already tracking?"

Gather list if yes.

**Question:** "How do you think about your competitive position?"

Options:
- We're the incumbent/leader
- We're a challenger trying to disrupt
- We're a new entrant evaluating the space
- We're adjacent and considering expansion
- We don't have a product yet (evaluating opportunity)

### 1.6 Research Priorities

**Question:** "Rank these research areas by importance (1-5):"

Present as multi-select with priority indication:
- Market size & growth (TAM/SAM/SOM)
- Competitive landscape & positioning
- Customer segments & needs
- Technology trends & disruption
- Regulatory & compliance factors
- Pricing & business models
- Go-to-market strategies
- Risk factors & barriers

### 1.7 Success Criteria

**Question:** "What would make this research highly valuable to you?"

Options (multi-select):
- Clear go/no-go recommendation
- Specific competitive insights I didn't have
- Quantified market opportunity
- Identified risks I hadn't considered
- Actionable next steps
- Data to support a specific argument
- Surprising insights that change my thinking

**Question:** "What would make this research fail or be unhelpful?"

Gather free-form to understand anti-patterns.

### 1.8 Constraints & Practicalities

**Question:** "What's your timeline for this research?"

Options:
- Urgent (need insights today)
- This week
- This month
- No rush, thoroughness over speed

**Question:** "Any specific sources you trust or distrust?"

Gather if applicable.

**Question:** "Budget context that affects recommendations?"

Options:
- Bootstrapped/limited resources
- Funded startup
- Established company with budget
- Enterprise with significant resources
- Not relevant to share

---

## Phase 2: Elicitation Synthesis

After gathering all context, synthesize into research brief:

```markdown
## Research Brief: [TOPIC]

### Decision Context
[What decision this informs and key success criteria]

### Target Audience
[Who will use this, their expertise level, what they need]

### Scope
- Geography: [regions]
- Segments: [target segments]
- Time horizon: [timeframe]
- Competitive position: [their position]

### Research Priorities (ranked)
1. [Highest priority area]
2. [Second priority]
3. [Third priority]

### Hypotheses to Test
- [Hypothesis 1]
- [Hypothesis 2]

### Known Competitors
- [Competitor list if provided]

### Constraints
- Timeline: [urgency]
- Budget context: [if shared]

### Success Criteria
[What makes this valuable]

### Anti-patterns to Avoid
[What would make this unhelpful]
```

**Present brief to user and confirm:**
"Does this capture your research needs? Anything to adjust before we begin?"

---

## Phase 3: Research Initialization

Only after elicitation complete and confirmed:

1. **Create research directory:**
   ```
   ./reports/$TOPIC_SLUG/
   ```

2. **Initialize enriched state file:**
   Create `./reports/$TOPIC_SLUG/state.json` with full elicitation data:
   ```json
   {
     "topic": "$TOPIC",
     "started": "ISO_DATE",
     "status": "active",
     "phase": "discovery",
     "elicitation": {
       "decision_context": "...",
       "audience": ["..."],
       "audience_expertise": "...",
       "prior_knowledge": "...",
       "hypotheses": ["..."],
       "scope": {
         "geography": "...",
         "segments": ["..."],
         "time_horizon": "..."
       },
       "competitive_position": "...",
       "known_competitors": ["..."],
       "priorities": ["..."],
       "success_criteria": ["..."],
       "anti_patterns": "...",
       "timeline": "...",
       "budget_context": "..."
     },
     "findings": [],
     "sources": []
   }
   ```

3. **Capture to Atlatl:**
   Store research brief using `capture_memory`:
   - `namespace`: `_semantic/knowledge`
   - `memory_type`: `semantic`
   - `tags`: `["sigint-research", "$TOPIC_SLUG"]`
   - `title`: "Research brief: $TOPIC"
   - `confidence`: 0.9
   Then run `enrich_memory(id)` on the captured memory.

4. **Create prioritized research plan:**
   Based on elicitation, create tasks ordered by stated priorities using `TaskCreate`:
   - Tasks aligned to decision context
   - Depth calibrated to timeline
   - Focus areas matching stated priorities

5. **Create blackboard for team coordination:**
   ```
   blackboard_create(scope="{topic-slug}", ttl=86400)
   blackboard_write(scope="{topic-slug}", key="elicitation", value={elicitation object from state.json})
   blackboard_write(scope="{topic-slug}", key="team_status", value={analysts: {dim1: "pending", dim2: "pending", ...}})
   ```

6. **Spawn dimension-analysts directly — one per priority, ALL in a SINGLE message:**
   For each prioritized dimension, make a REAL Agent tool call. Include ALL Agent calls in ONE message so they launch in parallel:

   ```
   Agent(
     subagent_type="sigint:dimension-analyst",
     name="dimension-analyst-{dimension}",
     description="{dimension} analysis: {topic}",
     run_in_background=true,
     prompt="You are a dimension-analyst for {dimension} research on '{topic}'.
       IMPORTANT: Use WebSearch and WebFetch for real web research. Minimum 5 searches. Do NOT fabricate findings.
       Blackboard scope: {topic-slug}
       State file: ./reports/{topic-slug}/state.json
       Skill to load: skills/{skill-directory}/SKILL.md
       Your blackboard key: findings_{dimension}
       Procedure:
       1. blackboard_read(scope='{topic-slug}', key='elicitation')
       2. Read skills/{skill-directory}/SKILL.md
       3. recall_memories(query='sigint {topic} {dimension}')
       4. WebSearch + WebFetch — minimum 5 searches
       5. blackboard_write(scope='{topic-slug}', key='findings_{dimension}', value={structured findings})
       6. Write findings to ./reports/{topic-slug}/{dimension}-findings.md"
   )
   ```

   **Dimension-to-skill mapping:**
   | Dimension | Skill Directory |
   |-----------|----------------|
   | competitive | competitive-analysis |
   | sizing | market-sizing |
   | trends | trend-analysis |
   | customer | customer-research |
   | tech | tech-assessment |
   | financial | financial-analysis |
   | regulatory | regulatory-review |

   Maximum 5 concurrent analysts. If more than 5 priorities, batch the rest after the first batch completes.

7. **Wait for all analysts to complete, then merge:**
   You will receive notifications as each background agent finishes. Once ALL are done:
   - Read findings from blackboard or from `./reports/{topic-slug}/*-findings.md`
   - Merge into state.json (update findings array, sources array, phase, last_updated)
   - Capture summary to Atlatl: `capture_memory(namespace="_semantic/knowledge", tags=["sigint-research", "{topic-slug}"])`
   - Present merged findings summary to user

   **Do NOT execute research yourself.** Only the dimension-analyst agents have WebSearch/WebFetch.
   **Do NOT spawn a research-orchestrator.** Spawn the dimension-analysts directly from this command.

---

## Elicitation Shortcuts

For returning users or quick starts:

**If user says "quick" or provides `--quick` flag:**
- Ask only: decision context, top 3 priorities, timeline
- Use defaults for rest

**If previous research exists on topic:**
- Load prior elicitation from state.json
- Ask: "Use previous research context or start fresh?"

**If user provides extensive context upfront:**
- Parse provided context
- Confirm interpretation
- Ask only for gaps

---

## Output

After elicitation:
- Confirmed research brief
- Initialized state with full context
- Prioritized research plan
- First discovery actions based on top priorities

**The research that follows will be shaped entirely by elicitation responses.**
