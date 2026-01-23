---
description: Manually initialize or reload Subcog context for sigint
version: 0.1.0
argument-hint: [--full] [--topic <topic>]
allowed-tools: Read, Write, Grep, Glob
---

Manually initialize the Subcog memory context for sigint research.

**Arguments:**
- `--full` - Load all sigint-related memories (not just current session)
- `--topic` - Load memories for a specific topic

**Process:**

1. **Initialize Subcog namespace:**
   Ensure sigint namespace is available in Subcog.
   Namespaces used:
   - `sigint:research` - Research session state and findings
   - `sigint:methodology` - Learned methodologies and approaches
   - `sigint:sources` - Trusted sources and data quality notes
   - `sigint:patterns` - Recognized market patterns

2. **Load relevant memories:**
   Query Subcog for:
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

5. **Load user configuration (cascading):**
   Configuration is loaded from two locations, with project-level overriding global:

   a. **Global defaults** (`~/.claude/sigint.local.md`):
      - User-wide default settings
      - Shared across all projects

   b. **Project overrides** (`./.claude/sigint.local.md` in current working directory):
      - Project-specific settings
      - Overrides global defaults

   Configuration options:
   - Default repository
   - Preferred report format
   - Audience preferences
   - Custom research context

   **Resolution order**: Project config > Global config > Built-in defaults

   **If project config doesn't exist**, create `./.claude/sigint.local.md` with default template:
   ```yaml
   ---
   # Sigint Plugin Configuration
   # Project-specific settings (overrides ~/.claude/sigint.local.md)

   # default_repo: owner/repo
   report_format: markdown
   audiences:
     - technical
   ---

   <!-- Project-specific research context can be added here -->
   ```

   Ensure the `.claude/` directory exists before creating the file.

6. **Display loaded context:**
   ```
   Subcog Context Loaded
   ─────────────────────
   Research Sessions: [count]
   Active Session: [topic or "none"]
   Methodology Notes: [count]
   Source Notes: [count]
   Patterns: [count]

   Configuration:
   - Default Repo: [repo or "not set"]
   - Report Format: [format]
   - Audiences: [list]
   ```

7. **Suggest next action:**
   - If active session: suggest `/sigint:status`
   - If no session: suggest `/sigint:start <topic>`
   - If stale session: suggest `/sigint:update`

**Note:** This command is also run automatically on SessionStart via hook.
Use this command to manually reload context mid-session or after configuration changes.

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
