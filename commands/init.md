---
description: Manually initialize or reload research context for sigint
version: 0.1.0
argument-hint: [--full] [--topic <topic>]
allowed-tools: Bash, Glob, Grep, Read, Write
---

Manually initialize the research context for sigint.

**Arguments:**
- `--full` - Load all sigint-related context (not just current session)
- `--topic` - Load context for a specific topic

**Process:**

1. **If `--topic` specified:**
   Load only context related to that topic from `./reports/[topic_slug]/`.

2. **If `--full` specified:**
   Load comprehensive sigint context from all topics.
   May use more context window but provides full history.

3. **Load configuration (Config Resolution Protocol):**

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
       audiences: ["technical"]
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

   **Legacy config detection**: After config resolution, check for `./.sigint.config.json` (v1.0).
   If found, display:
   ```
   Legacy config detected: {found file(s)}
   Run /sigint:migrate to convert to sigint.config.json v2.0 and preserve all settings.
   ```
   Continue initialization regardless.

4. **Display loaded context:**
   ```
   Research Context Loaded
   ───────────────────────
   Research Sessions: [count]
   Active Session: [topic or "none"]

   Configuration (sigint.config.json v2.0):
   - Default Repo: [config.default_repo or "not set"]
   - Report Format: [config.report_format]
   - Audiences: [config.audiences]
   - Topics configured: [count of keys in project_config.topics, or 0]
   ```

5. **Suggest next action:**
   - If active session: suggest `/sigint:status`
   - If no session: suggest `/sigint:start <topic>`
   - If stale session: suggest `/sigint:update`

**Note:** This command supplements the SessionStart hook which provides basic awareness.
Use this command to manually reload full research context mid-session or after configuration changes.

**Output:**
- Confirmation of context loaded
- Configuration status
- Suggested next action

**Example usage:**
```
/sigint:init
/sigint:init --full
/sigint:init --topic "AI assistants"
```
