---
diataxis_type: how-to
title: Troubleshooting
description: Solutions for common issues with installation, research, reports, and memory
---

# Troubleshooting

Common issues and solutions.

## Installation Issues

### Plugin Not Loading

**Symptom:** `/sigint:start` not recognized

**Solutions:**
1. Verify plugin is loaded. Check one of:
   ```bash
   # If installed globally
   ls ~/.claude/plugins/sigint/.claude-plugin/plugin.json

   # If using --plugin-dir flag
   ls /path/to/sigint/.claude-plugin/plugin.json
   ```

2. Restart Claude Code after installation

3. Check plugin is enabled:
   ```
   /plugins
   ```

### Commands Not Appearing

**Symptom:** Plugin loads but commands don't show

**Solution:** Commands are in `commands/` directory. Verify they exist in your plugin location:
```bash
ls <plugin-path>/commands/
```

Should show: `start.md`, `augment.md`, `report.md`, etc.

## Research Issues

### No Web Results

**Symptom:** Research returns empty or minimal findings

**Causes:**
- WebSearch tool not available
- Rate limiting on search APIs
- Very niche topic with limited online coverage

**Solutions:**
1. Try broader search terms
2. Wait and retry if rate limited
3. Use `/sigint:augment` with specific sources

### Elicitation Skipped

**Symptom:** Research runs without asking questions

**Cause:** You may have asked naturally instead of using `/sigint:start`

**Solution:** Use the command explicitly:
```
/sigint:start <topic>
```

### State Not Saving

**Symptom:** `/sigint:status` shows no active research

**Causes:**
- Research didn't complete
- `./reports/` directory permissions issue

**Solutions:**
1. Check `./reports/` exists and is writable
2. Re-run `/sigint:start`

## Report Issues

### Report Generation Fails

**Symptom:** `/sigint:report` produces error or empty output

**Causes:**
- No research data in state.json
- Missing elicitation context

**Solutions:**
1. Run `/sigint:status` to verify research exists
2. Run `/sigint:augment` to add more data
3. Check `./reports/<topic>/state.json` exists

### Mermaid Diagrams Not Rendering

**Symptom:** Diagrams show as code blocks

**Cause:** Viewing in editor without Mermaid support

**Solution:** View in:
- GitHub (renders Mermaid natively)
- VS Code with Mermaid extension
- Generated HTML file (includes Mermaid JS)

## GitHub Issues

### Issue Creation Fails

**Symptom:** `/sigint:issues` errors on GitHub API

**Causes:**
- `gh` CLI not installed
- Not authenticated
- No repository configured

**Solutions:**

1. Install GitHub CLI:
   ```bash
   brew install gh  # macOS
   ```

2. Authenticate:
   ```bash
   gh auth login
   ```

3. Verify repo access:
   ```bash
   gh repo view
   ```

### Wrong Repository

**Symptom:** Issues created in wrong repo

**Solution:** Configure default repo in `sigint.config.json`:

```json
{
  "version": "2.0",
  "defaults": {
    "default_repo": "owner/repo"
  }
}
```

Or set per-topic in the `topics` block. See [Configure Plugin](configure-plugin.md) for details.

Or specify at runtime:
```
/sigint:issues --repo owner/repo
```

## Atlatl Memory Issues

### Memory Not Persisting

**Symptom:** Research doesn't recall previous sessions

**Causes:**
- Atlatl MCP server not running
- Different namespace or tags

**Solutions:**

1. Check Atlatl status:
   ```
   Use system_status MCP tool
   ```

2. Manually search:
   ```
   recall_memories(query="sigint research", tags=["sigint-research"])
   ```

3. Re-initialize:
   ```
   /sigint:init
   ```

### Atlatl Not Available

**Symptom:** Memory tools not found

**Cause:** Atlatl MCP server not configured

**Solution:** sigint works without Atlatl — memory just won't persist across sessions. Research still saves to `./reports/`.

## Blackboard Issues

### Team Status Not Updating

**Symptom:** `/sigint:status` doesn't show analyst progress

**Causes:**
- Blackboard expired (TTL is 24h)
- Research orchestrator hasn't started yet

**Solutions:**
1. Check if research is active — orchestrator creates blackboard on start
2. If blackboard expired, findings are still in state.json
3. Re-run research to create fresh blackboard

### Analyst Not Completing

**Symptom:** Dimension analyst stuck or not reporting back

**Causes:**
- Web search returning no results
- Source too large for processing
- Network issues

**Solutions:**
1. Check `/sigint:status` for which analysts are pending
2. Re-run with `/sigint:augment {dimension}` for the stuck dimension
3. Narrow scope in elicitation to reduce research load

## Schema Validation Failures

### Validation Error After JSON Write

**Symptom:** Agent reports "SCHEMA VIOLATION" or validation failure during research

**Cause:** A JSON file written by an agent does not match its expected schema in `schemas/`.

**Solutions:**

1. Check the specific schema that failed:
   ```bash
   jq -f schemas/<schema>.jq ./reports/<topic>/file.json
   ```
   This prints `false` for failing checks.

2. Pinpoint the failing field:
   ```bash
   jq 'has("required_key")' ./reports/<topic>/file.json
   jq '.field | type' ./reports/<topic>/file.json
   ```

3. If the agent's retry-and-correct exhausted its 2 attempts, check for a `.invalid` sidecar file alongside the JSON file. This preserves the invalid data for debugging.

4. Re-run the failed step. Schema validation failures block the pipeline but do not corrupt existing data.

### "jq: command not found"

**Symptom:** Bash commands fail with jq not found

**Cause:** `jq` is not installed

**Solution:** Install jq:
```bash
brew install jq      # macOS
apt-get install jq   # Debian/Ubuntu
```

All sigint JSON operations require `jq`. Without it, research pipelines will fail at any JSON write step.

### Schema Mismatch After Plugin Update

**Symptom:** Existing JSON files from a previous sigint version fail validation

**Cause:** Schema validators may have been updated with new required fields

**Solutions:**
1. Re-run research to regenerate files with the current schema
2. Manually add missing fields using jq:
   ```bash
   jq '.missing_field = "default"' file.json > tmp.$$ && mv tmp.$$ file.json
   ```

## Performance Issues

### Research Taking Too Long

**Causes:**
- Many augment areas requested
- Large topic scope
- Slow network

**Solutions:**
1. Narrow scope in elicitation
2. Prioritize fewer research areas
3. Use `--area` flag for targeted updates

### Large Context Usage

**Symptom:** Claude runs out of context

**Solutions:**
1. Run `/compact` to summarize
2. Use agents (they run in isolated context)
3. Break research into smaller topics

## Large Document Issues

### Source Chunker Not Activating

**Symptom:** Large documents processed as single pass, missing content

**Cause:** Document under the 15K token threshold

**Solution:** Source chunker only activates for documents >15K tokens (~60K characters). For borderline documents, the single-pass analysis should be sufficient.

### Chunk Processing Fails

**Symptom:** Some chunks return errors during processing

**Causes:**
- Network timeout fetching large document
- Document format not supported

**Solutions:**
1. Download the document locally first, then reference the file path
2. Convert to markdown or plain text before processing
3. Split manually and use `/sigint:augment` with each section

## Getting Help

If issues persist:

1. Check GitHub issues: https://github.com/zircote/sigint/issues
2. Open new issue with:
   - sigint version
   - Claude Code version
   - Steps to reproduce
   - Error messages
