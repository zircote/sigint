---
description: Manually initialize or reload Atlatl memory context for sigint
version: 0.1.0
argument-hint: [--full] [--topic <topic>]
allowed-tools: Bash, Glob, Grep, Read, Write, mcp__atlatl__recall_memories
---

Manually initialize the Atlatl memory context for sigint research.

**Arguments:**
- `--full` - Load all sigint-related memories (not just current session)
- `--topic` - Load memories for a specific topic

**Process:**

1. **Search Atlatl memories:**
   Search for existing sigint memories using `recall_memories(query="sigint research", tags=["sigint-research"])`.
   Atlatl namespace mapping:
   - `_semantic/knowledge` with tag `sigint-research` - Research session state and findings
   - `_procedural/patterns` with tag `sigint-methodology` - Learned methodologies and approaches
   - `_semantic/knowledge` with tag `sigint-sources` - Trusted sources and data quality notes
   - `_procedural/patterns` with tag `sigint-patterns` - Recognized market patterns

2. **Load relevant memories:**
   Use `recall_memories` to retrieve:
   - Active research sessions
   - Recent findings and insights
   - Methodology preferences
   - Source reliability notes

3. **If `--topic` specified:**
   Load only memories related to that topic.
   Include related topics if semantically similar.

4. **If `--full` specified:**
   Load comprehensive sigint memory context.
   May use more context window but provides full history.

5. **Load configuration (Config Resolution Protocol):**

   Apply the **Config Resolution Protocol**:
   1. Read `protocols/CONFIG-RESOLUTION.md` and follow all steps.
   2. Apply with `topic_slug = null` (init operates at project level, not topic level).
   3. Result: `config` and `project_config` are now available.

   **If `./sigint.config.json` does not exist**, create it using jq (per Structured Data Protocol):
   ```bash
   jq -n '{
     version: "2.0",
     defaults: {
       report_format: "markdown",
       audiences: ["technical"],
       auto_atlatl: true
     },
     research: {
       maxDimensions: 5,
       dimensionTimeout: 300,
       defaultPriorities: ["competitive", "sizing", "trends"]
     },
     topics: {}
   }' > ./sigint.config.json
   jq -e -f schemas/sigint-config.jq ./sigint.config.json > /dev/null
   ```

   **Legacy config detection**: After config resolution, check for:
   - `./.claude/sigint.local.md`
   - `~/.claude/sigint.local.md`
   - `./.sigint.config.json` (v1.0)

   If any are found, display:
   ```
   Legacy config detected: {found file(s)}
   Run /sigint:migrate to convert to sigint.config.json v2.0 and preserve all settings.
   ```
   Continue initialization regardless.

6. **Display loaded context:**
   ```
   Atlatl Context Loaded
   ─────────────────────
   Research Sessions: [count]
   Active Session: [topic or "none"]
   Methodology Notes: [count]
   Source Notes: [count]
   Patterns: [count]

   Configuration (sigint.config.json v2.0):
   - Default Repo: [config.default_repo or "not set"]
   - Report Format: [config.report_format]
   - Audiences: [config.audiences]
   - Auto Atlatl: [config.auto_atlatl]
   - Topics configured: [count of keys in project_config.topics, or 0]
   ```

7. **Suggest next action:**
   - If active session: suggest `/sigint:status`
   - If no session: suggest `/sigint:start <topic>`
   - If stale session: suggest `/sigint:update`

**Note:** This command supplements the SessionStart hook which provides basic awareness.
Use this command to manually reload full Atlatl context mid-session or after configuration changes.

**Output:**
- Confirmation of context loaded
- Summary of available memories
- Configuration status
- Suggested next action

**Example usage:**
```
/sigint:init
/sigint:init --full
/sigint:init --topic "AI assistants"
```
