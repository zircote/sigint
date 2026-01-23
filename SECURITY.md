# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Security Considerations

sigint is a Claude Code plugin that performs web searches and fetches external content. Be aware:

- **Web Content**: Research commands fetch data from external sources
- **Report Storage**: Research findings are stored locally in `./reports/`
- **Subcog Memory**: Optional memory persistence via MCP server
- **GitHub Integration**: Issue creation requires `gh` CLI authentication

## Reporting a Vulnerability

If you discover a security vulnerability:

1. **Do not** open a public issue
2. Email: security@zircote.com
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact

## Response Timeline

- Initial response: 48 hours
- Assessment: 7 days
- Fix timeline: Based on severity

## Best Practices

When using sigint:

- Review generated reports before sharing externally
- Don't store sensitive data in research topics
- Use project-specific `./.claude/sigint.local.md` for configuration (overrides global `~/.claude/sigint.local.md`)
- Keep `gh` CLI credentials secure
