---
description: Refresh data and findings for existing research
version: 0.1.0
argument-hint: [--area <specific-area>] [--since <date>]
allowed-tools: Read, Write, Grep, Glob, WebSearch, WebFetch
---

Update existing research with fresh data and recent developments.

**Arguments:**
- `--area` - Optional: specific area to update (otherwise updates all)
- `--since` - Optional: only fetch news/data since this date

**Process:**

1. **Load research state:**
   Read `./reports/[current-topic]/state.json`.
   Identify existing findings and their dates.

2. **Check for staleness:**
   Flag findings older than 30 days as potentially stale.
   Prioritize updating market size, competitive landscape, and trend data.

3. **Gather fresh data:**
   Use WebSearch with date filters to find recent:
   - News articles and press releases
   - Market reports and analyses
   - Competitor announcements
   - Regulatory changes
   - Technology developments

4. **Compare with existing findings:**
   Identify:
   - Confirmations (data still valid)
   - Updates (values changed)
   - New information (previously unknown)
   - Contradictions (conflicting data)

5. **Update trend models:**
   Recalculate trend directions (INC/DEC/CONST).
   Update transitional scenario graphs with new data.
   Identify if any terminal scenarios have shifted.

6. **Update research state:**
   Modify state.json with:
   - Updated findings
   - New sources
   - Last updated timestamp
   - Change log

7. **Capture to Subcog:**
   Store significant changes and learnings.
   Note any trend reversals or unexpected developments.

**Output:**
- Summary of what changed since last update
- Updated findings with change indicators
- Revised scenario graphs (if applicable)
- Recommendations based on changes

**Example usage:**
```
/sigint:update
/sigint:update --area "competitive landscape"
/sigint:update --since 2024-01-01
```
