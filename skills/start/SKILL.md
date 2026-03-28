---
name: start
description: Begin a new market research session with comprehensive scoping. Full swarm orchestrator — runs elicitation, creates team, spawns parallel dimension-analyst teammates, merges findings, and cleans up. Mirrors the feature-dev skill's TeamCreate → TaskCreate → Agent(team_name) → SendMessage pattern.
argument-hint: "[--quick] [<topic>]"
---

# Sigint Start Skill (Swarm Orchestration)

You are the team lead orchestrating a market research session using parallel dimension-analyst agents coordinated as a swarm team.

## Overview

This skill implements the full research session workflow:
- **dimension-analyst** — Single-dimension web researcher with evidence-mandatory real web searches (spawned as N parallel instances, one per priority dimension)

The workflow uses interactive approval gates (elicitation + brief confirmation) and parallel dimension-analyst spawning. All coordination uses the swarm pattern: TeamCreate → TaskCreate → Agent(team_name) → SendMessage.

## Arguments

Parse `$ARGUMENTS` before any other processing:

- `--quick` — Abbreviated elicitation. Ask only decision context, top 3 priorities, timeline. Use defaults for rest.
- Remaining text after flag extraction is the initial topic hint (may be empty).

---

## Phase 0.0: Configuration Check

### Step 0.0.1: Load or Create Configuration

1. Attempt to read `.sigint.config.json` from the project root.
2. **If file exists**: Parse silently. Merge with defaults. Store as `config`. Proceed to Phase 0.1.
3. **If file does NOT exist**: Use defaults and proceed (do not create the file).

**Config schema v1.0**:
```json
{
  "version": "1.0",
  "research": {
    "maxDimensions": 5,
    "dimensionTimeout": 300,
    "defaultPriorities": ["competitive", "sizing", "trends"]
  }
}
```

**Defaults** (applied when file is missing or keys are absent):
```json
{
  "maxDimensions": 5,
  "dimensionTimeout": 300,
  "defaultPriorities": ["competitive", "sizing", "trends"]
}
```

Store effective config as `config`. Set `max_dimensions = config.research.maxDimensions ?? 5`.

---

## Phase 0.1: Initialize Team and Blackboard

**MANDATORY SWARM ORCHESTRATION — DO NOT USE PLAIN AGENT SPAWNS**

You MUST use the full swarm pattern: TeamCreate → TaskCreate → Agent with team_name → SendMessage. Do NOT fall back to spawning standalone Agent subagents without a team. The swarm pattern enables persistent teammates that coordinate via shared task lists and messaging — standalone subagents cannot do this.

**Step 0.1.1**: Derive `topic-slug` from `$ARGUMENTS` topic hint (or use `"research"` if no topic yet): lowercase, replace spaces and special characters with hyphens, truncate to 40 characters (e.g., "AI code review tools" → `"ai-code-review-tools"`).

**Step 0.1.2**: Call **TeamCreate**. This is a blocking prerequisite — do not proceed until it succeeds:
```
TeamCreate with team_name: "sigint-{topic-slug}-research"
```
If TeamCreate fails, retry once. If it fails again, report the error and stop.

**Step 0.1.3**: Create research directory and blackboard:
```
blackboard_create(scope="{topic-slug}", ttl=86400)
```
Store the scope as `blackboard_scope = "{topic-slug}"`.

**Step 0.1.4**: **CRITICAL — DO NOT SKIP.** Immediately after blackboard_create returns, use **TaskCreate** to create 3 high-level phase tasks (dimension tasks are created after elicitation when priorities are known):
- `"Phase 1: Elicitation"`
- `"Phase 3: Merge Findings"` — blockedBy Phase 2 tasks (add blockers after Phase 2 tasks are created)
- `"Phase 4: Summary + Cleanup"`

Proceed immediately to Phase 0.2 (template reference only) then Phase 1.

---

## Phase 0.2: Task Discovery Protocol Template

All dimension-analyst teammates receive this in their spawn prompt:

```
BLACKBOARD: {blackboard_scope}
Use blackboard_read(scope="{blackboard_scope}", key="...") to read shared context.
Use blackboard_write(scope="{blackboard_scope}", key="...", value="...") to share findings.

TASK DISCOVERY PROTOCOL:
1. When you receive a message from the team lead, call TaskList to find tasks assigned to you.
2. Call TaskGet on your assigned task to read the full description.
3. Work on the task.
4. When done: (a) TaskUpdate(taskId, status: "completed"), (b) SendMessage to team-lead with results, (c) TaskList for more work.
5. If no tasks assigned, wait for next message from team lead.
6. NEVER commit code via git — only the team lead commits.
```

Every Agent spawn **MUST include `team_name: "sigint-{topic-slug}-research"`**. After each spawn, send a **SendMessage** to the teammate with their task assignment. Without SendMessage, teammates sit idle.

---

## Phase 1: Research Context Elicitation

Only after Phase 0.1 completes. If `--quick` flag was provided, skip to **Quick Mode** section below.

Use **AskUserQuestion** for each elicitation block. Gather all context before synthesizing the brief.

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
- Market size & growth (TAM/SAM/SOM) → dimension: `sizing`
- Competitive landscape & positioning → dimension: `competitive`
- Customer segments & needs → dimension: `customer`
- Technology trends & disruption → dimension: `tech`
- Regulatory & compliance factors → dimension: `regulatory`
- Pricing & business models → dimension: `financial`
- Go-to-market strategies → dimension: `competitive`
- Risk factors & barriers → dimension: `trends`

Collect ordered list. Map to dimensions using the table above. Deduplicate mapped dimensions. Cap at `max_dimensions` (default 5).

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

### Quick Mode (--quick flag)

Ask only:
1. "What decision does this inform and what's the topic?"
2. "Top 3 research priorities (from: sizing, competitive, customer, tech, regulatory, financial, trends)?"
3. "What's your timeline?"

Use defaults for geography (global), segments (all), and other fields.

---

## Phase 1 Synthesis: Research Brief

After gathering all context, synthesize into a research brief:

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
1. [Highest priority dimension]
2. [Second priority]
3. [Third priority]

### Hypotheses to Test
- [Hypothesis 1 if provided]

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

Only proceed to Phase 2 after confirmation (or user says "proceed").

**After confirmation:**

1. **Create research directory:** `./reports/{topic-slug}/`

2. **Write state file:** `./reports/{topic-slug}/state.json`
   ```json
   {
     "topic": "{topic}",
     "topic_slug": "{topic-slug}",
     "started": "{ISO_DATE}",
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
       "dimensions": ["competitive", "sizing", "..."],
       "success_criteria": ["..."],
       "anti_patterns": "...",
       "timeline": "...",
       "budget_context": "..."
     },
     "findings": [],
     "sources": []
   }
   ```

3. **Write elicitation to blackboard:**
   ```
   blackboard_write(scope="{topic-slug}", key="elicitation", value={full elicitation object})
   blackboard_write(scope="{topic-slug}", key="team_status", value={"analysts": {"competitive": "pending", ...}})
   ```

4. **Capture to Atlatl:**
   ```
   capture_memory(
     title="Research brief: {topic}",
     namespace="_semantic/knowledge",
     memory_type="semantic",
     tags=["sigint-research", "{topic-slug}"],
     confidence=0.9,
     content="{research brief markdown}"
   )
   ```
   Then `enrich_memory(id)`.

---

## Phase 2: Spawn Dimension-Analysts

**Step 2.1**: For each prioritized dimension, create a TaskCreate:
```
For each dimension in dimensions (up to max_dimensions):
  TaskCreate({
    subject: "Research: {dimension} — {topic}",
    owner: "dimension-analyst-{dimension}"
  })
```
Store each returned task ID. Then update the "Phase 3: Merge Findings" task:
```
TaskUpdate("Phase 3: Merge Findings", addBlockedBy: [all Phase 2 task IDs])
```

**Step 2.2**: Spawn ALL dimension-analysts **in ONE message** (so they launch in parallel). Include ALL Agent calls in a single response:

For each dimension (max `max_dimensions` concurrent):
```
Agent(
  subagent_type="sigint:dimension-analyst",
  team_name="sigint-{topic-slug}-research",
  name="dimension-analyst-{dimension}",
  run_in_background=true,
  prompt="[TASK DISCOVERY PROTOCOL from Phase 0.2]

  You are a dimension-analyst for {dimension} research on '{topic}'.

  BLACKBOARD: {topic-slug}

  IMPORTANT: Use WebSearch and WebFetch for real web research. Minimum 5 searches.
  Do NOT fabricate findings. Every claim must cite a source you actually retrieved.

  State file: ./reports/{topic-slug}/state.json
  Skill to load: skills/{skill-directory}/SKILL.md

  METHODOLOGY CHECKLIST (verify against SKILL.md):
  {For competitive: "Porter's 5 Forces (with ratings), Competitor Matrix (with trends), Positioning Map (if axes available)"}
  {For sizing: "Methodology Selection (Top-Down/Bottom-Up/Value Theory), TAM > SAM > SOM hierarchy, Scenario Modeling (Bear/Base/Bull)"}
  {For trends: "Macro/Micro Trends Tables (INC/DEC/CONST), Emerging Signals, Transitional Scenario Graph (Mermaid stateDiagram), Terminal Scenarios"}
  {For customer: "Personas, Jobs-to-be-Done, Journey Mapping, Segmentation & Prioritization"}
  {For tech: "TRL Levels, Hype Cycle Mapping, Build vs Buy Matrix"}
  {For financial: "Unit Economics (CAC/LTV/LTV:CAC/payback), Revenue Model, Cost Structure, Rule of 40"}
  {For regulatory: "Framework Identification, Industry-to-Framework Mapping, Penalty Ranges, Risk Matrix"}

  IMPORTANT: You MUST write methodology_plan_{dimension} to the blackboard BEFORE any WebSearch call.
  Read your SKILL.md, extract the Required Frameworks table, and write your plan first.

  Your blackboard key: findings_{dimension}
  Your task ID: #{taskId}

  Procedure:
  1. blackboard_read(scope='{topic-slug}', key='elicitation') — load research context
  2. Read skills/{skill-directory}/SKILL.md — load your methodology
  3. recall_memories(query='sigint {topic} {dimension}') — check prior knowledge
  4. WebSearch + WebFetch — minimum 5 searches following skill methodology
  5. blackboard_write(scope='{topic-slug}', key='findings_{dimension}', value={structured findings JSON})
  6. Write findings to ./reports/{topic-slug}/{dimension}-findings.md
  7. TaskUpdate(#{taskId}, status: 'completed')
  8. SendMessage(to: 'team-lead', message: {dimension, findings_key, findings_path, finding_count, confidence_avg}, summary: '{dimension} analysis complete')"
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

**Step 2.3**: Immediately after spawning all agents in a single message, send each one a task assignment message:
```
For each dimension:
  SendMessage(
    to: "dimension-analyst-{dimension}",
    message: "Task #{taskId} assigned: {dimension} analysis on '{topic}'. Start now.",
    summary: "Task #{taskId} assigned"
  )
```

**Do NOT execute research yourself.** Only dimension-analyst agents have WebSearch/WebFetch. Your role is to coordinate.

If more than `max_dimensions` priorities exist, batch the remaining dimensions after the first batch completes.

---

## Phase 2.5: Methodology Verification Gate

After spawning all analysts and sending task assignments, verify that each analyst has produced a methodology plan.

**Step 2.5.1**: Wait up to 60 seconds per analyst for methodology plans to appear on the blackboard.
For each dimension:
```
blackboard_read(scope="{topic-slug}", key="methodology_plan_{dimension}")
```

**Step 2.5.2**: Surface methodology plans to user in a table:
"📋 Methodology plans confirmed:
| Dimension | Frameworks Planned | Status |
|-----------|-------------------|--------|
| competitive | Porter's 5 Forces, Competitor Matrix, Positioning Map | ✓ plan written |
| sizing | TAM/SAM/SOM, Scenario Modeling | ✓ plan written |
| trends | Macro/Micro Tables, Scenario Graph, Terminal Scenarios | ✓ plan written |
..."

**Step 2.5.3**: If any analyst fails to produce a methodology plan within 60 seconds:
- Log warning: "⚠️ {dimension} analyst did not produce methodology plan. Research will proceed but methodology compliance is unverified."
- Do NOT block the session. Continue with partial verification.
- Note the gap in the team_status blackboard entry.

---

## Phase 3: Wait and Merge

Wait for SendMessages from each dimension-analyst (one per dimension). You will receive each as a background notification.

**For each message received:**
1. Read `findings_{dimension}` from blackboard:
   ```
   blackboard_read(scope="{topic-slug}", key="findings_{dimension}")
   ```
2. Append findings to local buffer.
3. Update team_status:
   ```
   blackboard_write(scope="{topic-slug}", key="team_status",
     value={"analysts": {..., "{dimension}": "complete"}})
   ```

**Error handling**: If an analyst has not reported within `dimensionTimeout` seconds (default 300) after the last received message, continue with partial results. Note missing dimensions in state.json as gaps. Do not wait indefinitely.

**After ALL expected dimensions have reported (or timeout):**

1. Read any cross-dimension conflicts:
   ```
   blackboard_read(scope="{topic-slug}", key="conflicts")
   ```

2. Merge all findings into `./reports/{topic-slug}/state.json`:
   - Append all `findings` arrays
   - Append all `sources` arrays
   - Set `phase: "complete"`, `last_updated: "{ISO_DATE}"`
   - Note any gaps from failed/timed-out analysts

3. Build Methodology Coverage Matrix:
   For each dimension:
     - Read methodology_plan_{dimension} from blackboard (frameworks planned)
     - Read findings_{dimension} from blackboard (check which framework outputs are present)
     - Compare planned vs evidenced frameworks

   Present to user:
   "📊 Methodology Coverage Matrix:
   | Dimension | Framework | Planned | Applied | Notes |
   |-----------|-----------|---------|---------|-------|
   | competitive | Porter's 5 Forces | ✓ | ✓ | 5 forces with ratings |
   | competitive | Competitor Matrix | ✓ | ✓ | 6 competitors compared |
   | competitive | Positioning Map | ✓ | ✗ | skipped — no clear axes from elicitation |
   | sizing | TAM/SAM/SOM | ✓ | ✓ | $4.2B / $1.8B / $450M |
   ..."

   Write coverage matrix to state.json under "methodology_coverage" key.

4. Write merged summary to blackboard for downstream agents:
   ```
   blackboard_write(scope="{topic-slug}", key="merged_findings", value={
     "dimensions_complete": [...],
     "dimensions_missing": [...],
     "total_findings": N,
     "top_insights": ["..."],
     "conflicts": [...]
   })
   ```

5. Capture summary to Atlatl:
   ```
   capture_memory(
     title="Research complete: {topic}",
     namespace="_semantic/knowledge",
     memory_type="semantic",
     tags=["sigint-research", "{topic-slug}"],
     confidence=0.85,
     content="Merged findings summary across {N} dimensions..."
   )
   ```
   Then `enrich_memory(id)`.

### Source-Chunker Coordination

If a dimension-analyst sends a message with type "source_chunking_request":
1. Spawn source-chunker: Agent(subagent_type="sigint:source-chunker", team_name="sigint-{topic-slug}-research", name="source-chunker-{request_id}", run_in_background=true, prompt="...")
2. Create task for source-chunker with the URL, extraction focus, and target dimension
3. When source-chunker completes, route chunked findings back to the requesting analyst via SendMessage

6. Present merged findings summary to user:
   - Number of dimensions researched
   - Total findings count
   - Top 3-5 key insights across all dimensions
   - Any conflicts or gaps to be aware of
   - Suggested next steps: `/sigint:report` or `/sigint:augment`

---

## Phase 4: Cleanup

1. Send shutdown requests to all dimension-analyst teammates:
   ```
   For each dimension:
     SendMessage(
       to: "dimension-analyst-{dimension}",
       message: {"type": "shutdown_request", "reason": "Research session complete"},
       summary: "Shutdown: research complete"
     )
   ```

2. Delete the team:
   ```
   TeamDelete("sigint-{topic-slug}-research")
   ```

3. Final status update to user:
   - Research session complete
   - State saved to `./reports/{topic-slug}/state.json`
   - Findings available for report generation: `/sigint:report`
   - Issue creation available: `/sigint:issues`

---

## Previous Research Detection

Before Phase 0.1, check if research already exists on this topic:
```
Glob("./reports/*/state.json")
```

If `./reports/{topic-slug}/state.json` exists:
- Load prior elicitation from state.json
- Ask: "Previous research found for '{topic}'. Use prior research context as starting point, or start completely fresh?"
- If "use prior": Pre-populate elicitation with prior values, ask only for gaps/updates
- If "start fresh": Proceed normally (prior state.json will be overwritten after confirmation)

---

## Output

After complete session:
- Confirmed research brief
- Initialized state with full elicitation context
- Findings across all prioritized dimensions
- Merged state.json with all findings and sources
- Next step prompts for report and issue generation
