---
diataxis_type: how-to
title: Work with Quarantine
description: Inspect quarantined findings, diagnose rejection reasons, fix them, and re-run the pipeline
---

# Work with Quarantine

When a codex review gate rejects findings during research, those findings are moved to `quarantine.json` and removed from the active pipeline. This guide covers inspecting quarantined findings, diagnosing rejections, applying fixes, and re-running research.

**Prerequisites:**

- `jq` installed (`brew install jq` on macOS)
- A completed or partially completed research run with a `quarantine.json` file in `./reports/<topic>/`

---

## Inspect quarantine.json

Each quarantine entry contains six fields: `finding_id`, `original_dimension`, `reason`, `gate`, `gate_timestamp`, and `original_finding` (the full finding object as it existed at rejection time).

### List all quarantined findings

```bash
jq '.items[] | {finding_id, dimension: .original_dimension, gate, reason}' \
  ./reports/<topic>/quarantine.json
```

### Count quarantined findings

```bash
jq '.items | length' ./reports/<topic>/quarantine.json
```

### Filter by gate

Show only findings rejected at the post-findings gate:

```bash
jq '[.items[] | select(.gate == "post-findings")]' \
  ./reports/<topic>/quarantine.json
```

Show only findings rejected at the post-merge gate:

```bash
jq '[.items[] | select(.gate == "post-merge")]' \
  ./reports/<topic>/quarantine.json
```

### Filter by dimension

```bash
jq --arg dim "competitive" \
  '[.items[] | select(.original_dimension == $dim)]' \
  ./reports/<topic>/quarantine.json
```

### Extract rejection reasons

Get a summary of unique rejection reasons and how many findings each affected:

```bash
jq '[.items[].reason] | group_by(.) | map({reason: .[0], count: length}) | sort_by(-.count)' \
  ./reports/<topic>/quarantine.json
```

---

## Identify which gate rejected a finding

The `gate` field on each quarantine item tells you where rejection occurred. The two gates that quarantine findings are:

| Gate | When it runs | What it checks |
|------|-------------|----------------|
| `post-findings` | After each dimension-analyst completes | Evidence sufficiency, source validity, methodology coverage, provenance completeness, fabrication detection |
| `post-merge` | After findings from all dimensions are consolidated | Cross-dimension consistency, duplicate detection, gap identification, overall coherence |

To check a specific finding:

```bash
jq --arg id "finding-abc-123" \
  '.items[] | select(.finding_id == $id) | {gate, reason, gate_timestamp}' \
  ./reports/<topic>/quarantine.json
```

If the `gate` is `post-findings`, the issue is within a single dimension's data quality. If it is `post-merge`, the issue involves cross-dimension conflicts or duplicates.

---

## Fix common rejection reasons

### Missing provenance

**Symptom:** Reason contains "provenance" or "no source URL"

**Cause:** The finding lacks required provenance fields. Every finding must have: `claim`, `sources[].url`, `sources[].fetched_at`, `sources[].snippet`, and `derivation`.

**Solution:**

1. Extract the incomplete finding:
   ```bash
   jq --arg id "<finding_id>" \
     '.items[] | select(.finding_id == $id) | .original_finding' \
     ./reports/<topic>/quarantine.json
   ```

2. Check which provenance fields are missing:
   ```bash
   jq --arg id "<finding_id>" \
     '.items[] | select(.finding_id == $id) | .original_finding |
     {
       has_claim: has("claim"),
       has_sources: has("sources"),
       has_derivation: has("derivation"),
       source_urls: (.sources // [] | map(has("url"))),
       source_fetched: (.sources // [] | map(has("fetched_at"))),
       source_snippets: (.sources // [] | map(has("snippet")))
     }' \
     ./reports/<topic>/quarantine.json
   ```

3. Add the missing fields to the finding in the dimension findings file (`findings_<dimension>.json`), then re-run the pipeline (see [Re-trigger the pipeline](#re-trigger-the-pipeline-after-manual-fixes) below).

### Insufficient sources

**Symptom:** Reason mentions "evidence sufficiency" or "insufficient sources"

**Cause:** A finding marked with `confidence: "high"` has fewer than 2 independent sources.

**Solution:**

Either locate additional sources to add to the finding's `sources` array, or downgrade the finding's confidence level to `"medium"` or `"low"` in the dimension findings file:

```bash
jq --arg id "<finding_id>" \
  '(.findings[] | select(.id == $id)).confidence = "medium"' \
  ./reports/<topic>/findings_<dimension>.json > tmp.$$ && \
  mv tmp.$$ ./reports/<topic>/findings_<dimension>.json
```

### Methodology gaps

**Symptom:** Reason mentions "methodology" or "framework"

**Cause:** The dimension's findings do not cover all required frameworks from its methodology plan. The post-findings gate compares findings against `methodology_plan_<dimension>.json` and flags missing required frameworks.

**Solution:**

1. Check which frameworks are required:
   ```bash
   jq '[.frameworks[] | select(.required == "yes") | .name]' \
     ./reports/<topic>/methodology_plan_<dimension>.json
   ```

2. Check which are present in the current findings:
   ```bash
   jq '[.findings[].methodology_framework] | unique' \
     ./reports/<topic>/findings_<dimension>.json
   ```

3. The difference identifies the gaps. Use `/sigint:augment <dimension>` to run targeted research for the missing frameworks, or add findings manually.

Note: The pipeline retries methodology gaps automatically (up to 2 retries per dimension). If findings reached quarantine, the retries were either exhausted or the gaps involve non-methodology issues.

### Cross-dimension contradictions

**Symptom:** Reason mentions "contradiction" or "inconsistent"

**Cause:** The post-merge gate found findings from different dimensions that make contradictory claims.

**Solution:**

1. Identify the contradicting findings:
   ```bash
   jq --arg id "<finding_id>" \
     '.items[] | select(.finding_id == $id) | .reason' \
     ./reports/<topic>/quarantine.json
   ```
   The reason text typically identifies both findings and the nature of the conflict.

2. Decide which finding is correct based on source quality and recency. Remove or revise the incorrect finding in its dimension findings file.

3. If both findings are valid (the contradiction is nuanced), revise the claims so they do not conflict -- for example, by scoping each claim to its specific context.

---

## Re-trigger the pipeline after manual fixes

After editing dimension findings files to address quarantine issues:

1. **Validate the edited findings file** against its schema:
   ```bash
   jq -e -f schemas/findings.jq ./reports/<topic>/findings_<dimension>.json > /dev/null
   ```

2. **Remove fixed entries from quarantine.json.** Filter out the findings you corrected:
   ```bash
   jq --argjson ids '["finding-id-1", "finding-id-2"]' \
     '.items |= map(select(.finding_id as $fid | $ids | index($fid) | not))' \
     ./reports/<topic>/quarantine.json > tmp.$$ && \
     mv tmp.$$ ./reports/<topic>/quarantine.json
   ```

3. **Validate quarantine.json** still conforms to schema:
   ```bash
   jq -e -f schemas/quarantine.jq ./reports/<topic>/quarantine.json > /dev/null
   ```

4. **Re-run the pipeline** using the augment command targeting the affected dimensions:
   ```
   /sigint:augment <dimension>
   ```
   This re-triggers the dimension analyst and subsequent codex review gates. Fixed findings will pass through the gates and rejoin the active pipeline.

---

## Prevent quarantine in future research runs

These practices reduce the chance of findings being quarantined:

- **Provide specific elicitation context.** Narrow, well-scoped research topics produce higher-quality findings with better source coverage. Broad or vague topics lead to thin evidence and provenance gaps.

- **Review methodology plans before research.** After elicitation, check the methodology plan files to confirm the required frameworks are appropriate for the topic. Remove frameworks that are irrelevant before the pipeline runs.

- **Use augment for depth, not breadth.** When `/sigint:augment` targets a specific dimension or area, the analyst focuses its search effort and produces findings with stronger provenance.

- **Check source availability.** The post-findings gate verifies source URLs. If your research topic relies on paywalled, ephemeral, or frequently-rotated sources, findings may fail the source validity check. Prefer sources with stable URLs.

---

## See also

- [Architecture -- Codex review gates](../explanation/architecture.md) -- how gates work and why they exist
- [Troubleshooting](troubleshooting.md) -- solutions for common pipeline issues including schema validation failures
- [Protocols reference](../reference/protocols.md) -- full protocol specifications for research orchestration
