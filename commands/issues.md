---
description: Create GitHub issues from research findings as atomic deliverables
version: 0.1.0
argument-hint: [--repo <owner/repo>] [--dry-run] [--labels <list>]
allowed-tools: Read, Write, Bash, Grep, Glob
---

Convert research findings into sprint-sized GitHub issues.

**Arguments:**
- `--repo` - Target repository (default: current directory's repo or configured default)
- `--dry-run` - Preview issues without creating them
- `--labels` - Additional labels to apply (comma-separated)

**Issue Categories:**

1. **Feature Requests** (label: `enhancement`)
   - New capabilities suggested by market analysis
   - Competitive feature gaps to address
   - Customer-requested functionality

2. **Enhancements** (label: `enhancement`)
   - Improvements to existing features
   - Performance optimizations
   - UX improvements based on research

3. **Research Tasks** (label: `research`)
   - Further investigation needed
   - Data validation required
   - Technical feasibility studies

4. **Action Items** (label: `action-item`)
   - Immediate to-dos
   - Process changes
   - Documentation updates

**Issue Generation Process:**

1. **Parse arguments:**
   Extract repo, dry-run flag, and labels from command arguments.

2. **Delegate to issue-architect agent:**
   Use the Task tool to launch the issue-architect agent:
   - `subagent_type`: `"sigint:issue-architect"`
   - `prompt`: Include the parsed arguments (repo, dry-run, labels) and path to state.json
   - `description`: "Create GitHub issues from research"

   The agent will:
   - Load state.json and any generated reports
   - Identify actionable items from recommendations, gaps, and risks
   - Atomize into sprint-sized issues with clear acceptance criteria
   - Determine target repository (from args, config, or git remote)
   - Create issues via GitHub MCP or `gh` CLI (or preview if dry-run)
   - Save issue manifest to `./reports/[topic]/YYYY-MM-DD-issues.json`
   - Capture to Subcog for future reference
   - Return summary of created issues

   **Do NOT generate or create issues directly in this context.** The issue-architect agent handles all atomization, content generation, and GitHub integration.

**Output:**
- List of created issues with numbers and URLs
- Issue manifest file location
- Summary by category

**Example usage:**
```
/sigint:issues
/sigint:issues --dry-run
/sigint:issues --repo myorg/myrepo --labels "market-research,q1-2024"
```
