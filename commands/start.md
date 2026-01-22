---
description: Begin a new market research session on a topic
argument-hint: <topic> [--audience <type>] [--depth <level>]
allowed-tools: Read, Write, Grep, Glob, WebSearch, WebFetch, TodoWrite
---

Initialize a new sigint research session for the specified topic.

**Arguments:**
- `$1` - Research topic (required)
- Additional arguments may specify audience (executives, pm, investors, dev) or depth (quick, standard, deep)

**Initialization Steps:**

1. **Create research directory:**
   ```
   ./reports/$TOPIC_SLUG/
   ```

2. **Initialize research state file:**
   Create `./reports/$TOPIC_SLUG/state.json` with:
   ```json
   {
     "topic": "$1",
     "started": "ISO_DATE",
     "status": "active",
     "phase": "discovery",
     "audiences": ["executives", "product-managers"],
     "findings": [],
     "sources": []
   }
   ```

3. **Load Subcog context:**
   Recall any previous research on this topic or related topics from Subcog memory.
   Capture the new research session to Subcog for persistence.

4. **Create initial research plan:**
   Using the research methodologies from sigint skills, create a TodoWrite task list:
   - Market overview discovery
   - Competitive landscape mapping
   - Trend identification
   - Initial data gathering

5. **Begin discovery phase:**
   Use WebSearch to gather initial market context on the topic.
   Identify key players, market size indicators, and recent news.

6. **Report initial findings:**
   Summarize what was discovered and outline next research steps.
   Ask if user wants to augment any specific area.

**Output:**
- Confirmation of research session start
- Initial findings summary
- Research plan with next steps
- Prompt for user direction on focus areas

**Example usage:**
```
/sigint:start "AI code assistants market"
/sigint:start "sustainable packaging" --audience executives --depth deep
```
