# Changelog

All notable changes to the Sigint Market Intelligence Plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- **Topic lifecycle tracking**: Research sessions now register in `sigint.config.json` topics throughout the lifecycle — `/sigint:start` registers with `in_progress`, orchestrator sets `complete` on finish, `/sigint:augment` and `/sigint:update` update dimensions and timestamps
- **Session index**: `/sigint:status` and `/sigint:resume --list` now use `sigint.config.json` topics as primary session index instead of only globbing report directories
- **Schema validation**: `sigint-config.jq` updated to validate both minimal (context-only) and lifecycle-managed topic entries with status, dimensions, created/updated timestamps, findings count, and optional Atlatl memory ID
- **Dimension-analyst reports directory**: Orchestrator now passes explicit `REPORTS_DIR` and `TOPIC_SLUG` to each analyst spawn prompt; analysts use the path verbatim instead of deriving it from the topic title (fixes slug truncation causing findings to land in wrong directory)
- **Pre-review file validation** (Phase 2.6): Orchestrator validates all expected findings files exist in the canonical reports directory *before* the codex review gate (not after), ensuring relocated files go through the blocking review. Recovery is fail-closed: single-match relocations only, refuses on ambiguous multiple candidates, never imports from sibling topic directories
- **Config write atomicity**: Orchestrator Phase 4.1 now writes all topic completion fields (status, findings_count, dimensions, atlatl_memory_id) in a single jq call to prevent race conditions

## [0.5.0] - 2026-04-02

### Added
- **Harness pattern**: Research-orchestrator follows the Anthropic long-running agent harness pattern with `research-progress.md` for cross-session continuity
- **Codex review gates**: 4 blocking gates at pipeline boundaries (post-findings, post-merge, post-report, post-issues) with quarantine mechanism for failures
- **Provenance enforcement**: Every finding must carry a provenance record (claim, sources with URLs, derivation, confidence basis)
- **Delta detection protocol**: Update mode classifies findings as NEW, UPDATED, CONFIRMED, POTENTIALLY_REMOVED, or TREND_REVERSAL with generated delta reports
- **Structured Data Protocol** (`protocols/STRUCTURED-DATA.md`): All JSON operations use `jq` via Bash with mandatory schema validation after every write
- **12 jq schema validators** in `schemas/` directory: state, findings, elicitation, methodology-plan, reflection, quarantine, merged-findings, report-metadata, issues, team-status, conflicts, sigint-config
- **Config Resolution Protocol** (`protocols/CONFIG-RESOLUTION.md`): Defines config cascade for `sigint.config.json` v2.0 with project > global > hardcoded resolution
- **Migrate skill** (`skills/migrate/SKILL.md`): Converts legacy `sigint.local.md` or `.sigint.config.json` v1.0 to `sigint.config.json` v2.0 with per-topic support, dry-run preview, and idempotent execution
- **`trend_modeling` dimension**: 8th research dimension using three-valued logic scenario modeling (note: uses underscore, not hyphen)
- **6 operational skills**: start, update, augment, migrate, issues, report — thin launchers that delegate to specialized agents via swarm orchestration

### Changed
- **All JSON file operations now use `jq` via Bash** — `Edit` tool removed from all agents and skills per `/refactor:xq` structured data reliability patterns
- **Configuration format**: Migrated from `sigint.local.md` YAML to `sigint.config.json` v2.0 JSON with per-topic overrides
- **Schema validation is mandatory**: Write-then-validate pattern required after every JSON mutation with retry-and-correct (max 2 retries)
- **Dual-write is default**: Blackboard + file persistence for all findings (not just a Cowork fallback)
- **Research-orchestrator** upgraded to v0.5.0 with codex gates, provenance, delta detection, and harness pattern
- **Dimension-analyst** now includes `Bash` in tools list for Structured Data Protocol compliance
- **Report-synthesizer** now includes `Bash` in tools list for Structured Data Protocol compliance
- **Resume command** follows harness initialization protocol (read progress files before acting)

### Removed
- **`Edit` tool** from all agents — replaced by `Bash` + `jq` for JSON operations
- **`sigint.local.md` as primary config** — replaced by `sigint.config.json` v2.0 (legacy format supported via `/sigint:migrate`)

## [0.4.0] - 2026-03-20

### Added
- **Swarm-orchestrated parallel research**: New research-orchestrator agent coordinates multiple dimension-analysts running concurrently
- **Dimension-analyst agent**: Generic research analyst parameterized by dimension (competitive, sizing, trends, customer, tech, financial, regulatory)
- **Source-chunker agent**: RLM processor for large documents — partitions, spawns chunk analysts, synthesizes findings
- **Atlatl blackboard coordination**: Ephemeral session blackboard for inter-agent communication during research
- **Orchestration hints** in all 9 skill SKILL.md files for team-based research participation
- **Live team status** in `/sigint:status` showing dimension-analyst progress via blackboard

### Changed
- **Replaced monolithic market-researcher** with research-orchestrator + dimension-analyst swarm (3→5 agents)
- **Migrated from Subcog to Atlatl** memory system across all commands and agents
- **Replaced TodoWrite with TaskCreate/TaskUpdate** in all commands
- **Replaced Task/subagent_type delegation with Agent tool** in all commands
- **Report-synthesizer** now reads blackboard findings in addition to state.json
- **Issue-architect** now uses Atlatl instead of Subcog for memory persistence

### Removed
- **market-researcher agent** (decomposed into research-orchestrator + dimension-analyst)
- **Subcog integration** (replaced by Atlatl MCP tools)
- **TodoWrite usage** (replaced by TaskCreate/TaskUpdate)

## [0.3.7] - 2026-01-23

### Fixed
- Init command now creates project `sigint.local.md` with default template if missing

## [0.3.0] - 2026-01-23

### Added
- Cascading configuration support: global defaults (`~/.claude/sigint.local.md`) with project overrides (`./.claude/sigint.local.md`)
- Marketplace installation option (`/plugins add sigint`)
- **README.md generation for report folders**:
  - Master index (`./reports/README.md`) listing all research topics with status and summaries
  - Topic index (`./reports/<topic>/README.md`) with:
    - Research query summary
    - Configuration/elicitation settings used
    - Links to all artifacts (reports, state, issues)
    - Key findings summary

### Changed
- Configuration resolution order: Project > Global > Built-in defaults
- Updated installation documentation with three options (marketplace, local dev, manual)
- market-researcher agent now generates README.md on initial research
- report-synthesizer agent updates README.md when generating reports

### Fixed
- Broken links in executive-brief.md example (now correctly reference cross-skill examples)
- Documentation clarity for configuration paths across all docs

## [0.2.1] - 2026-01-23

### Fixed
- Agent delegation: Commands now delegate to specialized agents instead of executing research/reports directly in the main REPL

## [0.2.0] - 2026-01-22

### Changed
- Reorganized plugin structure with comprehensive elicitation workflow
- Enhanced `/sigint:start` command with structured research brief questions

### Added
- User documentation in `docs/` directory:
  - `quick-start.md` - 5-minute getting started guide
  - `workflow-guide.md` - Complete research lifecycle documentation
  - `troubleshooting.md` - Common issues and solutions
- GitHub social preview image (`.github/social-preview.svg`)
- README infographic showing research workflow
- Quick Start section in README with example workflow
- `CONTRIBUTING.md` - Contribution guidelines and development setup
- `SECURITY.md` - Security policy and vulnerability reporting
- `.gitattributes` - Line ending normalization

### Fixed
- License field in `plugin.json` corrected from Apache-2.0 to MIT
- LICENSE file year updated to 2026

## [0.1.0] - 2026-01-22

### Added

#### Agents
- **market-researcher** - Comprehensive market research, competitive intelligence, and strategic insights
- **report-synthesizer** - Transforms raw research findings into polished, executive-ready documents
- **issue-architect** - Converts research findings into actionable GitHub issues

#### Commands
- `/sigint:start` - Begin a new market research session with comprehensive scoping and elicitation
- `/sigint:augment` - Deep-dive into a specific research area
- `/sigint:init` - Initialize plugin configuration for a project
- `/sigint:issues` - Generate GitHub issues from research findings
- `/sigint:report` - Generate a comprehensive report from research
- `/sigint:resume` - Resume an existing research session
- `/sigint:status` - Show current research session state and progress
- `/sigint:update` - Refresh data and findings for existing research

#### Skills
- **Competitive Analysis** - Porter's Five Forces, competitive matrices
- **Market Sizing** - Top-down and bottom-up methodologies
- **Trend Forecasting** - Three-valued logic trend models
- **Customer Research** - Persona development and journey mapping
- **Technology Assessment** - Build vs. buy analysis frameworks
- **Financial Analysis** - Unit economics and SaaS metrics
- **Regulatory Review** - Compliance and regulatory impact assessment
- **Report Writing** - Executive briefs and comprehensive reports
- **Data Collection** - Primary and secondary research techniques

#### Templates
- Market sizing report template
- Competitive analysis report template
- Trend analysis report template
- Technology assessment report template

#### Reference Materials
- Porter's Five Forces framework guide
- Competitive matrix templates
- Market sizing methodologies
- Three-valued logic documentation
- SaaS metrics reference
- Regulatory compliance checklists

#### Examples
- Competitive analysis report example
- Market sizing report example
- Trend analysis report example
- Technology assessment example
- Financial analysis example
- Customer journey map example
- Executive brief example
- Full comprehensive report example

### Documentation
- README with plugin overview and quick start guide
- Research methodology citations (arXiv:2601.10768)
- MIT license

[Unreleased]: https://github.com/zircote/sigint/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/zircote/sigint/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/zircote/sigint/compare/v0.3.7...v0.4.0
[0.3.7]: https://github.com/zircote/sigint/compare/v0.3.0...v0.3.7
[0.3.0]: https://github.com/zircote/sigint/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/zircote/sigint/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/zircote/sigint/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/zircote/sigint/releases/tag/v0.1.0
