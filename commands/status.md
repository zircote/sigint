---
description: Show current research session state and progress
argument-hint: [--verbose]
allowed-tools: Read, Grep, Glob
---

Display the current sigint research session status and progress.

**Arguments:**
- `--verbose` - Show detailed findings and sources

**Process:**

1. **Find active research session:**
   Scan `./reports/*/state.json` for sessions with status "active".

2. **Load session state:**
   Read state.json and parse:
   - Topic and scope
   - Current phase
   - Findings count by category
   - Sources count
   - Last activity

3. **Calculate progress metrics:**
   - Research completeness (based on methodology coverage)
   - Data freshness (age of newest finding)
   - Coverage gaps (areas not yet researched)

4. **Display status dashboard:**
   ```
   ╔══════════════════════════════════════════════════════════╗
   ║  SIGINT Research Status                                  ║
   ╠══════════════════════════════════════════════════════════╣
   ║  Topic: [research topic]                                 ║
   ║  Phase: [discovery | analysis | synthesis]               ║
   ║  Started: [date]  |  Last Updated: [date]                ║
   ╠══════════════════════════════════════════════════════════╣
   ║  FINDINGS                                                ║
   ║  ├─ Market Overview:     [✓ | ○ | ─]                    ║
   ║  ├─ Competitive:         [✓ | ○ | ─]                    ║
   ║  ├─ Market Sizing:       [✓ | ○ | ─]                    ║
   ║  ├─ Trends:              [✓ | ○ | ─]                    ║
   ║  ├─ Customer Research:   [✓ | ○ | ─]                    ║
   ║  ├─ Tech Assessment:     [✓ | ○ | ─]                    ║
   ║  ├─ Financial:           [✓ | ○ | ─]                    ║
   ║  └─ Regulatory:          [✓ | ○ | ─]                    ║
   ╠══════════════════════════════════════════════════════════╣
   ║  Sources: [count]  |  Findings: [count]                  ║
   ║  Freshness: [days since last update]                     ║
   ╠══════════════════════════════════════════════════════════╣
   ║  NEXT STEPS                                              ║
   ║  • [suggested action 1]                                  ║
   ║  • [suggested action 2]                                  ║
   ╚══════════════════════════════════════════════════════════╝
   ```
   Legend: ✓ = complete, ○ = in progress, ─ = not started

5. **If `--verbose`:**
   Show list of all findings with summaries.
   Show list of all sources.
   Show current trend indicators (INC/DEC/CONST).

6. **Suggest next actions:**
   Based on coverage gaps and phase:
   - Missing areas → suggest `/sigint:augment [area]`
   - All areas covered → suggest `/sigint:report`
   - Stale data → suggest `/sigint:update`

**Output:**
- Visual status dashboard
- Progress indicators
- Suggested next steps

**Example usage:**
```
/sigint:status
/sigint:status --verbose
```
