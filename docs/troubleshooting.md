# Troubleshooting

Common issues and solutions.

## Installation Issues

### Plugin Not Loading

**Symptom:** `/sigint:start` not recognized

**Solutions:**
1. Verify plugin is in correct location:
   ```bash
   ls ~/.claude/plugins/sigint/.claude-plugin/plugin.json
   ```

2. Restart Claude Code after installation

3. Check plugin is enabled:
   ```
   /plugins
   ```

### Commands Not Appearing

**Symptom:** Plugin loads but commands don't show

**Solution:** Commands are in `commands/` directory. Verify:
```bash
ls ~/.claude/plugins/sigint/commands/
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

**Solution:** Configure default repo in `.claude/sigint.local.md`:
```yaml
---
default_repo: owner/repo
---
```

Or specify at runtime:
```
/sigint:issues --repo owner/repo
```

## Subcog Issues

### Memory Not Persisting

**Symptom:** Research doesn't recall previous sessions

**Causes:**
- Subcog MCP server not running
- Different namespace

**Solutions:**

1. Check Subcog status:
   ```
   /subcog:status
   ```

2. Manually initialize:
   ```
   /sigint:init
   ```

### Subcog Not Available

**Symptom:** Subcog tools not found

**Cause:** Subcog MCP server not configured

**Solution:** sigint works without Subcog - memory just won't persist across sessions. Research still saves to `./reports/`.

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

## Getting Help

If issues persist:

1. Check GitHub issues: https://github.com/zircote/sigint/issues
2. Open new issue with:
   - sigint version
   - Claude Code version
   - Steps to reproduce
   - Error messages
