---
description: Resume a previous research session from progress file and Atlatl
version: 0.5.0
argument-hint: "[<topic>] [--list]"
allowed-tools: AskUserQuestion, Glob, Grep, Read, Write, mcp__atlatl__inject_context, mcp__atlatl__recall_memories
---

Resume a previous sigint research session following the harness initialization protocol.

**Arguments:**
- `$1` - Topic name to resume (optional if only one active session)
- `--list` - List all available research sessions

**Harness Initialization Protocol:**

The resume command follows the Anthropic long-running agent harness pattern: read progress files first to understand prior work state before doing anything else.

**Process:**

1. **If `--list` specified:**
   Scan `./reports/*/state.json` for all research sessions.
   Recall Atlatl memories: `recall_memories(query="sigint research sessions", tags=["sigint-research"])`
   Display table:
   ```
   | Topic | Status | Last Updated | Phase | Findings | Lineage Entries |
   |-------|--------|--------------|-------|----------|-----------------|
   ```

2. **If topic specified:**
   Load `./reports/[topic]/research-progress.md` **FIRST** (harness init protocol).
   Then load `./reports/[topic]/state.json` for structured data.
   Recall related Atlatl memories: `recall_memories(query="sigint {topic}", tags=["sigint-research"])`

3. **If no topic specified:**
   Check for single active session.
   If multiple, prompt user to specify.
   If none, suggest starting new research.

4. **Read progress file first (harness init protocol):**
   ```
   Read ./reports/{topic_slug}/research-progress.md
   ```
   This is the human/agent-readable log of all phase transitions, codex review results,
   and session events. It provides the cross-session continuity that state.json alone cannot.

   If `research-progress.md` does not exist (legacy session), fall back to state.json only
   and note: "Legacy session — no progress file. Consider running `/sigint:update` to generate one."

5. **Restore research context:**
   From state.json:
   - Load all findings and sources
   - Read `lineage[]` to understand session history
   - Identify current research phase
   - Check for quarantined findings in `./reports/{topic_slug}/quarantine.json`
   
   From research-progress.md:
   - Identify last completed phase
   - Note any codex review gate results
   - Check for flagged issues or gaps

6. **Display session summary:**
   ```
   Research Session: [topic]
   Status: [active/paused/complete]
   Phase: [discovery/analysis/synthesis]
   Started: [date]
   Last Updated: [date]

   Lineage: [N] research actions
   Latest: [action] on [date] — [dimensions], [finding_count] findings

   Findings: [count] ([quarantined] quarantined)
   Sources: [count]
   Dimensions: [list with status]

   Codex Review Status:
   - Post-findings: [pass/fail/not-run]
   - Post-merge: [pass/fail/not-run]

   Pending Tasks:
   - [from progress file if any]
   ```

7. **Suggest next steps:**
   Based on current phase, lineage, and findings:
   - If research is recent and complete → suggest `/sigint:report` or `/sigint:issues`
   - If research is stale (>30 days) → suggest `/sigint:update`
   - If dimensions are missing → suggest `/sigint:augment <dimension>`
   - If quarantined findings exist → suggest reviewing `quarantine.json`

**Output:**
- Session summary with lineage history
- Research state restored with progress context
- Suggested next actions based on current state
