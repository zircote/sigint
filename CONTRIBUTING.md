# Contributing to sigint

Thank you for your interest in contributing to sigint!

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/zircote/sigint.git
   cd sigint
   ```

2. Install as a local plugin:
   ```bash
   claude plugins add ./
   ```

3. Test your changes:
   ```bash
   claude
   /sigint:status
   ```

## Plugin Structure

```
sigint/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest
├── commands/            # Slash commands
├── agents/              # Subagent definitions
├── skills/              # Research methodologies
│   └── */SKILL.md       # Skill definitions
└── hooks/               # Event handlers
```

## Making Changes

### Commands

- Located in `commands/*.md`
- Use YAML frontmatter for metadata
- Include `version`, `description`, `allowed-tools`

### Agents

- Located in `agents/*.md`
- Include `version`, `description`, `model`, `color`, `tools`
- Write clear system prompts

### Skills

- Each skill in `skills/<name>/SKILL.md`
- Include `references/` and `examples/` subdirectories
- Document methodology clearly

## Code Style

- Use kebab-case for file names
- Follow existing patterns in similar files
- Keep YAML frontmatter consistent
- Document tool dependencies

## Pull Request Process

1. Create a feature branch from `main`
2. Make changes with clear commit messages
3. Update CHANGELOG.md under `[Unreleased]`
4. Submit PR with description of changes

## Commit Messages

Follow conventional commits:
- `feat:` New commands, agents, or skills
- `fix:` Bug fixes
- `docs:` Documentation updates
- `refactor:` Code restructuring
- `chore:` Maintenance tasks

## Testing

Before submitting:
- Verify commands work: `/sigint:status`
- Test affected workflows
- Check that hooks don't interfere with normal operation

## Questions?

Open an issue for questions or discussion.
