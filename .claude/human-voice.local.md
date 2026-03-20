---
# Human Voice Plugin Configuration
# Project-specific settings for sigint report generation

detection:
  character_patterns:
    emojis: false  # Emojis are intentional in sigint reports — do not flag

content_directories:
  - reports

severity_overrides: {}
---

# Sigint Voice Review Notes

## Intentional Emoji Usage

Sigint reports use emojis deliberately for visual scanning and status indicators.
These are intentional authorial choices and should not be flagged as character issues.

## Report Context

Reports are market research documents targeting business audiences (executives, PMs, investors, developers). Voice review should ensure language is natural and human-sounding while preserving analytical rigor, data precision, and professional tone.
