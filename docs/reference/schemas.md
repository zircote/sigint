---
diataxis_type: reference
title: Schemas Reference
description: Complete catalog of jq-based schema validators for all sigint JSON files, including field definitions, constraints, and validation commands
---

# Schemas Reference

All sigint JSON files are validated by jq-based schema validators in the `schemas/` directory. Schema validation is mandatory after every write or mutation.

## Validation commands

Standard validation pattern for any schema:

```bash
jq -e -f schemas/<SCHEMA>.jq <FILE> > /dev/null
```

Exit code 0 means valid. Non-zero means invalid. To diagnose a failure, drop the `-e` flag and inspect output:

```bash
jq -f schemas/<SCHEMA>.jq <FILE>
```

Quick reference for all schemas:

| Schema File | Validates | Command |
|---|---|---|
| `sigint-config.jq` | `sigint.config.json` | `jq -e -f schemas/sigint-config.jq ./sigint.config.json > /dev/null` |
| `state.jq` | `state.json` | `jq -e -f schemas/state.jq ./reports/{slug}/state.json > /dev/null` |
| `findings.jq` | `findings_{dim}.json` | `jq -e -f schemas/findings.jq ./reports/{slug}/findings_{dim}.json > /dev/null` |
| `elicitation.jq` | `elicitation.json` | `jq -e -f schemas/elicitation.jq ./reports/{slug}/elicitation.json > /dev/null` |
| `methodology-plan.jq` | `methodology_plan_{dim}.json` | `jq -e -f schemas/methodology-plan.jq ./reports/{slug}/methodology_plan_{dim}.json > /dev/null` |
| `reflection.jq` | `findings_{dim}_reflection.json` | `jq -e -f schemas/reflection.jq ./reports/{slug}/findings_{dim}_reflection.json > /dev/null` |
| `quarantine.jq` | `quarantine.json` | `jq -e -f schemas/quarantine.jq ./reports/{slug}/quarantine.json > /dev/null` |
| `merged-findings.jq` | `merged_findings.json` | `jq -e -f schemas/merged-findings.jq ./reports/{slug}/merged_findings.json > /dev/null` |
| `report-metadata.jq` | `YYYY-MM-DD-report-metadata.json` | `jq -e -f schemas/report-metadata.jq ./reports/{slug}/YYYY-MM-DD-report-metadata.json > /dev/null` |
| `issues.jq` | `YYYY-MM-DD-issues.json`, `issues-dry-run.json` | `jq -e -f schemas/issues.jq ./reports/{slug}/YYYY-MM-DD-issues.json > /dev/null` |
| `team-status.jq` | `team_status.json` | `jq -e -f schemas/team-status.jq ./reports/{slug}/team_status.json > /dev/null` |
| `conflicts.jq` | `conflicts.json` | `jq -e -f schemas/conflicts.jq ./reports/{slug}/conflicts.json > /dev/null` |
| `vocabulary.jq` | `vocabulary.json`, `base-vocabulary.json` | `jq -e -f schemas/vocabulary.jq ./reports/{slug}/vocabulary.json > /dev/null` |
| `delta-findings.jq` | `findings_delta_YYYY-MM-DD.json` | `jq -e -f schemas/delta-findings.jq ./reports/{slug}/findings_delta_YYYY-MM-DD.json > /dev/null` |
| *(inline)* | `findings_hashes.json` | `jq -e 'to_entries \| all(.value \| type == "string")' ./reports/{slug}/findings_hashes.json > /dev/null` |

---

## Core State

### sigint-config.jq

**File**: `schemas/sigint-config.jq`
**Validates**: `sigint.config.json`
**Writer(s)**: init, migrate

| Field | Type | Constraints |
|---|---|---|
| `version` | string | Must equal `"2.0"` |
| `defaults` | object | Required |
| `defaults.report_format` | string | One of: `markdown`, `html`, `both` |
| `defaults.audiences` | array of string | Non-empty |
| `research` | object | Required |
| `research.maxDimensions` | number | Greater than 0 |
| `research.dimensionTimeout` | number | Greater than 0 |
| `research.defaultPriorities` | array of string | Non-empty |
| `topics` | object | Required; each entry must be minimal or lifecycle-managed (see below) |

Topic entries support two forms:

- **Minimal** (legacy/context-only): object with `context_file`, no `status` field
- **Lifecycle-managed**: object with required `status`, `dimensions`, `created`, `reports_dir` and optional `updated` (string), `findings_count` (number >= 0), `context_file` (string)

`status` must be one of: `in_progress`, `complete`, `stale`.

### state.jq

**File**: `schemas/state.jq`
**Validates**: `reports/{slug}/state.json`
**Writer(s)**: orchestrator, augment

Enum definitions used in this schema:

| Enum | Values |
|---|---|
| `valid_status` | `active`, `complete`, `archived` |
| `valid_phase` | `discovery`, `analysis`, `synthesis`, `complete`, `augmented` |
| `valid_confidence` | `high`, `medium`, `low` |
| `valid_trend` | `INC`, `DEC`, `CONST` |
| `valid_derivation` | `direct_quote`, `synthesis`, `extrapolation` |
| `valid_action` | `initial_research`, `scheduled_update`, `augment` |

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `topic` | string | Non-empty |
| `topic_slug` | string | Non-empty |
| `started` | string | Non-empty |
| `status` | string | `valid_status` |
| `phase` | string | `valid_phase` |
| `elicitation` | object | Required |
| `findings` | array | Each entry validated (see below) |
| `sources` | array | Each entry validated (see below) |
| `lineage` | array | Each entry validated (see below) |

**Finding object fields:**

| Field | Type | Constraints | Required |
|---|---|---|---|
| `id` | string | -- | Yes |
| `title` | string | -- | Yes |
| `summary` | string | -- | Yes |
| `confidence` | string | `valid_confidence` | Yes |
| `trend` | string | `valid_trend` | Yes |
| `tags` | array of string | -- | Yes |
| `entities` | array of string | -- | No |
| `market_dynamic` | string | One of: `consolidation`, `disruption`, `maturation`, `emergence`, `fragmentation`, `commoditization`, `regulation`, `standardization` | No |
| `proposed_tags` | array of string | Max length 3 | No |
| `provenance` | object | Must contain `claim` (string), `sources` (array), `derivation` (`valid_derivation`) | Yes |

**Source object fields:**

| Field | Type | Constraints |
|---|---|---|
| `url` | string | -- |
| `title` | string | -- |
| `reliability` | string | `valid_confidence` |

**Lineage object fields:**

| Field | Type | Constraints | Required |
|---|---|---|---|
| `session_id` | string | -- | Yes |
| `action` | string | `valid_action` | Yes |
| `dimensions` | array | -- | Yes |
| `finding_count` | number | -- | Yes |
| `delta_from_previous` | object or null | v0.9.0+; requires `new_count`, `updated_count`, `confirmed_count`, `potentially_removed_count`, `trend_reversal_count`, `newsworthy_count` (all number); optional `update_breakdown` (object) | No |

---

## Research Output

### findings.jq

**File**: `schemas/findings.jq`
**Validates**: `reports/{slug}/findings_{dim}.json`
**Writer(s)**: dimension-analyst

Enum definitions used in this schema:

| Enum | Values |
|---|---|
| `valid_confidence` | `high`, `medium`, `low` |
| `valid_trend` | `INC`, `DEC`, `CONST` |
| `valid_derivation` | `direct_quote`, `synthesis`, `extrapolation` |
| `valid_dimension` | `competitive`, `sizing`, `trends`, `customer`, `tech`, `financial`, `regulatory`, `trend_modeling` |

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `dimension` | string | `valid_dimension` |
| `status` | string | One of: `complete`, `in_progress`, `partial` |
| `findings` | array | Each entry validated (see below) |
| `sources` | array | Each entry validated (see below) |
| `gaps` | array of string | -- |

**Finding object fields:**

| Field | Type | Constraints | Required |
|---|---|---|---|
| `id` | string | -- | Yes |
| `title` | string | -- | Yes |
| `summary` | string | -- | Yes |
| `confidence` | string | `valid_confidence` | Yes |
| `trend` | string | `valid_trend` | Yes |
| `tags` | array of string | -- | Yes |
| `entities` | array of string | -- | No |
| `market_dynamic` | string | Same enum as state.jq | No |
| `proposed_tags` | array of string | Max length 3 | No |
| `provenance` | object | Required (see below) | Yes |
| `delta_type` | string | One of: `NEW`, `UPDATED`, `CONFIRMED`, `POTENTIALLY_REMOVED`, `TREND_REVERSAL` | No |
| `delta_detail` | object | See delta-findings.jq for structure | No |

**Provenance object fields:**

| Field | Type | Constraints |
|---|---|---|
| `claim` | string | -- |
| `sources` | array | Each: `url` (string), `fetched_at` (string), `snippet` (string), `alive` (boolean) |
| `derivation` | string | `valid_derivation` |
| `confidence_basis` | string | -- |

**Source object fields** (top-level `sources` array):

| Field | Type | Constraints |
|---|---|---|
| `url` | string | -- |
| `title` | string | -- |
| `reliability` | string | `valid_confidence` |

### merged-findings.jq

**File**: `schemas/merged-findings.jq`
**Validates**: `reports/{slug}/merged_findings.json`
**Writer(s)**: orchestrator

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `findings` | array | Same finding shape as findings.jq (relaxed provenance: requires `claim`, `sources`, `derivation` without inner source structure enforcement) |
| `methodology_coverage` | object | Each value: object with `planned` (array) and `applied` (array) |
| `conflicts` | array | Optional; each: object with `dimension_a`, `dimension_b`, `description` |

### reflection.jq

**File**: `schemas/reflection.jq`
**Validates**: `reports/{slug}/findings_{dim}_reflection.json`
**Writer(s)**: dimension-analyst

| Field | Type | Constraints |
|---|---|---|
| `iteration` | number | >= 1 |
| `methodology_gaps_found` | array of string | -- |
| `evidence_gaps_found` | array of string | -- |
| `additional_searches` | number | >= 0 |
| `gaps_resolved` | array of string | -- |
| `gaps_remaining` | array of string | -- |

### delta-findings.jq

**File**: `schemas/delta-findings.jq`
**Validates**: `reports/{slug}/findings_delta_YYYY-MM-DD.json`
**Writer(s)**: orchestrator (augment mode)

Enum definitions used in this schema:

| Enum | Values |
|---|---|
| `valid_delta_type` | `NEW`, `UPDATED`, `CONFIRMED`, `POTENTIALLY_REMOVED`, `TREND_REVERSAL` |
| `valid_change_category` | `substantive`, `metadata`, `temporal`, `confidence_shift`, `source_refresh` |
| `valid_newsworthiness` | `high`, `medium`, `low` |
| `valid_changed_field` | `summary`, `confidence`, `trend`, `tags`, `entities`, `sources`, `market_dynamic`, `provenance` |

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `dimension` | string | -- |
| `mode` | string | -- |
| `baseline_date` | string | -- |
| `refresh_date` | string | -- |
| `status` | string | One of: `complete`, `in_progress`, `partial` |
| `findings` | array | Each entry validated (see below) |

**Finding object fields:**

| Field | Type | Constraints | Required |
|---|---|---|---|
| `id` | string | -- | Yes |
| `title` | string | -- | Yes |
| `summary` | string | -- | Yes |
| `delta_type` | string | `valid_delta_type` | Yes |
| `delta_detail` | object | Required when `delta_type` is `UPDATED`; see below | Conditional |
| `confidence` | string or number | `valid_confidence` when string | No |
| `trend` | string | `valid_trend` | No |
| `tags` | array of string | -- | No |
| `entities` | array of string | -- | No |
| `market_dynamic` | string | Same enum as findings.jq | No |

**delta_detail object fields** (required on `UPDATED` findings):

| Field | Type | Constraints | Required |
|---|---|---|---|
| `changed_fields` | array of string | Each must be `valid_changed_field` | Yes |
| `change_category` | string | `valid_change_category` | Yes |
| `newsworthiness` | string | `valid_newsworthiness` | Yes |
| `newsworthiness_basis` | string | -- | Yes |
| `summary_diff` | string or null | -- | No |
| `confidence_change` | object or null | `previous` and `current` fields | No |
| `trend_change` | object or null | `previous` and `current` fields | No |

---

## Pipeline Coordination

### elicitation.jq

**File**: `schemas/elicitation.jq`
**Validates**: `reports/{slug}/elicitation.json`
**Writer(s)**: orchestrator

| Field | Type | Constraints | Required |
|---|---|---|---|
| `decision_context` | string | Non-empty | Yes |
| `priorities` | array of string | Non-empty | Yes |
| `dimensions` | array of string | Non-empty | Yes |
| `audience` | string | -- | No |
| `audience_expertise` | string | -- | No |
| `scope` | object | -- | No |
| `hypotheses` | array of string | -- | No |
| `success_criteria` | array of string | -- | No |
| `anti_patterns` | array of string | -- | No |
| `budget_context` | string | -- | No |
| `timeline` | string | -- | No |
| `known_competitors` | array of string | -- | No |
| `default_repo` | string or null | -- | No |

### methodology-plan.jq

**File**: `schemas/methodology-plan.jq`
**Validates**: `reports/{slug}/methodology_plan_{dim}.json`
**Writer(s)**: dimension-analyst

| Field | Type | Constraints |
|---|---|---|
| `dimension` | string | `valid_dimension` (same enum as findings.jq) |
| `frameworks` | array of object | Non-empty; each: `name` (string), `required` (`"yes"` or `"conditional"`), `condition_met` (boolean or null) |
| `expected_sections` | array of string | -- |
| `reference_files` | array of string | -- |

### quarantine.jq

**File**: `schemas/quarantine.jq`
**Validates**: `reports/{slug}/quarantine.json`
**Writer(s)**: orchestrator

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `quarantined_at` | string | Non-empty |
| `items` | array | Each entry validated (see below) |

**Item object fields:**

| Field | Type | Constraints |
|---|---|---|
| `finding_id` | string | -- |
| `original_dimension` | string | -- |
| `reason` | string | Non-empty |
| `gate` | string | One of: `post-findings`, `post-merge` |
| `gate_timestamp` | string | -- |
| `original_finding` | object | -- |

### team-status.jq

**File**: `schemas/team-status.jq`
**Validates**: `reports/{slug}/team_status.json`
**Writer(s)**: orchestrator

| Field | Type | Constraints |
|---|---|---|
| `team_name` | string | Non-empty |
| `status` | string | One of: `active`, `complete` |
| `phase` | string | Non-empty |
| `analysts` | object | Each value: object with `status` (`pending`, `in_progress`, `complete`, `failed`) and `finding_count` (number >= 0) |
| `last_updated` | string | Non-empty |

### conflicts.jq

**File**: `schemas/conflicts.jq`
**Validates**: `reports/{slug}/conflicts.json`
**Writer(s)**: dimension-analyst, orchestrator

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `detected_at` | string | Non-empty |
| `conflicts` | array | Each entry validated (see below) |

**Conflict object fields:**

| Field | Type | Constraints | Required |
|---|---|---|---|
| `dimension_a` | string | -- | Yes |
| `dimension_b` | string | -- | Yes |
| `description` | string | Non-empty | Yes |
| `severity` | string | One of: `critical`, `high`, `medium`, `low` | No |

### report-metadata.jq

**File**: `schemas/report-metadata.jq`
**Validates**: `reports/{slug}/YYYY-MM-DD-report-metadata.json`
**Writer(s)**: report-synthesizer

| Field | Type | Constraints | Required |
|---|---|---|---|
| `generated_at` | string | Non-empty | Yes |
| `topic` | string | Non-empty | Yes |
| `topic_slug` | string | Non-empty | Yes |
| `format` | string | One of: `markdown`, `html`, `both` | Yes |
| `sections_included` | array of string | Non-empty | Yes |
| `dimensions_covered` | array of string | -- | Yes |
| `total_findings` | number | >= 0 | Yes |
| `total_sources` | number | >= 0 | Yes |
| `files_generated` | array of string | Non-empty | Yes |
| `confidence_levels` | object | `high`, `medium`, `low` fields | No |
| `quarantined_findings` | number | -- | No |

### issues.jq

**File**: `schemas/issues.jq`
**Validates**: `reports/{slug}/YYYY-MM-DD-issues.json`, `reports/{slug}/issues-dry-run.json`
**Writer(s)**: issue-architect

Enum definitions:

| Enum | Values |
|---|---|
| `valid_category` | `feature`, `enhancement`, `research`, `action-item` |
| `valid_priority` | `P0`, `P1`, `P2`, `P3` |

**Top-level fields:**

| Field | Type | Constraints |
|---|---|---|
| `generated_at` | string | Non-empty |
| `topic` | string | Non-empty |
| `topic_slug` | string | Non-empty |
| `target_repo` | string | Non-empty |
| `dry_run` | boolean | -- |
| `issues` | array | Each entry validated (see below) |
| `categories_summary` | object | -- |

**Issue object fields:**

| Field | Type | Constraints |
|---|---|---|
| `title` | string | Non-empty |
| `body` | string | -- |
| `category` | string | `valid_category` |
| `priority` | string | `valid_priority` |
| `labels` | array of string | -- |
| `finding_reference` | string | -- |
| `acceptance_criteria` | array of string | Minimum 2 items |

---

## Configuration

### vocabulary.jq

**File**: `schemas/vocabulary.jq`
**Validates**: `schemas/base-vocabulary.json`, `reports/{slug}/vocabulary.json`
**Writer(s)**: orchestrator

| Field | Type | Constraints | Required |
|---|---|---|---|
| `version` | string | Non-empty | Yes |
| `categories` | object | Non-empty; each value: non-empty array of lowercase-hyphenated strings matching `^[a-z0-9]+(-[a-z0-9]+)*$` | Yes |
| `inherits` | string | -- | No |
| `generated` | string | -- | No |
| `topic_slug` | string | -- | No |
| `all_terms` | array of string | Each matching `^[a-z0-9]+(-[a-z0-9]+)*$`; required when `inherits` is present (topic vocabularies), forbidden when absent (base vocabulary) | Conditional |

### findings_hashes.json (inline validation)

**File**: No dedicated `.jq` schema file
**Validates**: `reports/{slug}/findings_hashes.json`
**Writer(s)**: orchestrator

Validated inline with:

```bash
jq -e 'to_entries | all(.value | type == "string")' ./reports/{slug}/findings_hashes.json > /dev/null
```

Structure: a flat JSON object where every key is a dimension name (string) and every value is a SHA-256 file hash (string).

---

## See also

- [Protocols Reference](protocols.md) -- write-then-validate pattern and structured data protocol
- [Architecture](../explanation/architecture.md) -- how schemas fit into the pipeline
- [Troubleshooting: Schema Validation](../how-to/troubleshooting.md#schema-validation-failures) -- diagnosing and fixing validation failures
