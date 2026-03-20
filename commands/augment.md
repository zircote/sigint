---
description: Deep-dive into a specific area of current research
version: 0.1.0
argument-hint: <area> [--methodology <type>]
allowed-tools: Read, Write, Grep, Glob, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskUpdate, TaskList, TaskGet
---

Augment the current research session with deeper analysis of a specific area.

**Arguments:**
- `$1` - Area to investigate deeper (e.g., "competitor pricing", "regulatory landscape", "technology stack")
- `--methodology` - Optional: specific methodology to apply (competitive, sizing, trends, customer, tech, financial, regulatory)

**Process:**

1. **Load current research state:**
   Read `./reports/[current-topic]/state.json` to understand context.
   Recall relevant Atlatl memories: `recall_memories(query="sigint {topic} {area}", tags=["sigint-research"])`

2. **Identify applicable methodology:**
   Based on the area specified, select the most relevant sigint skill:
   - Competitor/market players → competitive-analysis skill
   - Size/TAM/opportunity → market-sizing skill
   - Patterns/future → trend-analysis skill (include trend-modeling for scenarios)
   - Users/personas → customer-research skill
   - Technology/feasibility → tech-assessment skill
   - Revenue/economics → financial-analysis skill
   - Compliance/legal → regulatory-review skill

3. **Spawn a dimension-analyst agent (MANDATORY — do NOT skip this):**
   Use the Agent tool with these EXACT parameters:
   ```
   Agent(
     subagent_type="sigint:dimension-analyst",
     name="dimension-analyst-{dimension}",
     description="Deep research on {area}",
     run_in_background=true,
     prompt="You are a dimension-analyst for {dimension} research.
       IMPORTANT: Use WebSearch and WebFetch for real web research. Minimum 5 searches.
       State file: ./reports/{topic-slug}/state.json
       Skill to load: skills/{skill-directory}/SKILL.md
       Blackboard scope: {topic-slug} (if exists)
       Write findings to: ./reports/{topic-slug}/{dimension}-findings.md"
   )
   ```

   **You MUST include `subagent_type: "sigint:dimension-analyst"`.** Without it, the agent won't have WebSearch/WebFetch.

   **Do NOT execute research directly.** You do not have WebSearch or WebFetch tools. Only the dimension-analyst agent does.

4. **Generate transitional scenario graph:**
   For trend-related augmentations, create Mermaid diagrams showing:
   - Current state scenarios
   - Possible transitions (INC/DEC/CONST)
   - Terminal/equilibrium states

5. **Update research state:**
   Add new findings to state.json.
   Capture key insights to Atlatl: `capture_memory(namespace="_semantic/knowledge", tags=["sigint-research", "{topic}", "{area}"], ...)` then `enrich_memory(id)`.
   Update the research phase if appropriate.

6. **Present augmented findings:**
   Summarize new discoveries with evidence.
   Show how this connects to existing research.
   Include scenario graphs where relevant.

**Output:**
- Detailed findings for the augmented area
- Mermaid transitional graphs (when applicable)
- Updated research state
- Recommendations for further augmentation or report generation

**Example usage:**
```
/sigint:augment "competitor pricing strategies"
/sigint:augment "regulatory risks" --methodology regulatory
/sigint:augment "market growth trajectory" --methodology trends
```
