# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.5.x   | :white_check_mark: |
| 0.1.x   | :white_check_mark: |

## Security Considerations

sigint is a Claude Code plugin that performs web searches and fetches external content. Be aware:

- **Web Content**: Research commands fetch data from external sources
- **Report Storage**: Research findings are stored locally in `./reports/`
- **Atlatl Memory**: Optional memory persistence via Atlatl MCP server
- **GitHub Integration**: Issue creation requires `gh` CLI authentication

## Threat Model

### Prompt Injection via Web Content
sigint fetches arbitrary web content and passes it to LLM agents. Malicious web pages could embed instructions in their content. Mitigations:
- Web-scraped content wrapped in `<untrusted_data>` XML delimiters in all codex review gate prompts
- Codex review gates verify findings independently
- Dual-write pattern ensures findings are persisted before review

### Prompt Injection via User Input
User-supplied arguments (`$ARGUMENTS`) are interpolated into agent prompts. Mitigations:
- Input sanitized: truncated to 200 chars, backticks and angle brackets stripped
- User input wrapped in `<user_input>` XML tags in agent prompts

### Supply Chain
- GitHub Actions workflows pin reusable workflows to SHA, not mutable tags
- Dependabot automerge restricted to `dependabot[bot]` actor only

## In-Scope Categories

- **Prompt injection** — via web content, user input, or state.json manipulation
- **Supply chain** — compromised GitHub Actions, dependency confusion
- **Config injection** — malicious sigint.config.json values that escape into shell or agent prompts
- **Data exfiltration** — findings or memory data leaking to unintended destinations

## Reporting a Vulnerability

If you discover a security vulnerability:

1. **Do not** open a public issue
2. **Preferred**: Use [GitHub Security Advisories](https://github.com/zircote/sigint/security/advisories/new) for encrypted reporting
3. **Alternative**: Email security@zircote.com
4. Include:
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
- Use project-specific `./sigint.config.json` for configuration (overrides global `~/.claude/sigint.config.json`)
- Keep `gh` CLI credentials secure
