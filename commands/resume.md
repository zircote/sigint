---
description: Resume a previous research session from Subcog or files
argument-hint: [<topic>] [--list]
allowed-tools: Read, Write, Grep, Glob
---

Resume a previous sigint research session.

**Arguments:**
- `$1` - Topic name to resume (optional if only one active session)
- `--list` - List all available research sessions

**Process:**

1. **If `--list` specified:**
   Scan `./reports/*/state.json` for all research sessions.
   Query Subcog for research memories.
   Display table:
   ```
   | Topic | Status | Last Updated | Phase | Findings |
   |-------|--------|--------------|-------|----------|
   ```

2. **If topic specified:**
   Load `./reports/[topic]/state.json`.
   Load related Subcog memories for context.

3. **If no topic specified:**
   Check for single active session.
   If multiple, prompt user to specify.
   If none, suggest starting new research.

4. **Restore research context:**
   - Load all findings and sources
   - Recall Subcog memories for this topic
   - Identify current research phase
   - List pending tasks

5. **Display session summary:**
   ```
   Research Session: [topic]
   Status: [active/paused]
   Phase: [discovery/analysis/synthesis]
   Started: [date]
   Last Updated: [date]

   Findings: [count]
   Sources: [count]

   Current Focus:
   - [last augmented area]

   Pending Tasks:
   - [from todo list if any]
   ```

6. **Suggest next steps:**
   Based on current phase and findings:
   - Discovery → suggest areas to augment
   - Analysis → suggest running trend modeling
   - Synthesis → suggest generating report

**Output:**
- Session summary and context
- Research state restored
- Suggested next actions

**Example usage:**
```
/sigint:resume
/sigint:resume "AI code assistants"
/sigint:resume --list
```
