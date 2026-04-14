---
diataxis_type: explanation
title: Tag Vocabulary
description: Design rationale behind sigint's two-tier controlled vocabulary system for consistent finding classification across research dimensions
---

# Tag Vocabulary

Sigint produces findings from multiple independent dimension-analysts working in parallel. Without a shared vocabulary, the same concept appears under different labels across dimensions -- "vendor lock-in" in one, "switching-cost" in another, "lock-in-risk" in a third. This document explains why controlled vocabulary exists, how its two-tier design works, and how the vocabulary evolves as research accumulates.

## Why controlled vocabulary matters

Three problems emerge when analysts tag findings without constraints.

**Inconsistency breaks entity resolution.** Downstream consumers of sigint output -- whether human reviewers or automated pipelines -- need to aggregate findings by topic. When the same concept carries different tag strings across dimensions, aggregation requires manual reconciliation. A controlled vocabulary eliminates this by giving every analyst the same term list to draw from.

**Cross-dimensional analysis depends on shared labels.** Sigint's value comes from connecting insights across dimensions (competitive landscape, technology trends, market dynamics, and so on). When two analysts independently tag a finding with `platform-play`, the orchestrator knows those findings are conceptually linked. Without shared vocabulary, discovering these connections requires fuzzy matching or manual review.

**Reporting becomes unreliable.** Tag frequency counts, co-occurrence matrices, and trend detection all assume that identical tags represent identical concepts. Vocabulary drift degrades every quantitative operation performed on findings.

## Two-tier vocabulary design

The vocabulary system uses two layers: a **base vocabulary** that persists across all research topics and a **topic-specific vocabulary** generated fresh for each research session.

### Base vocabulary

The base vocabulary lives at `schemas/base-vocabulary.json` and defines terms that apply universally regardless of research topic. It contains five structural categories:

| Category | Purpose | Example terms |
|---|---|---|
| `competitive_position` | Where a player sits in the market | `market-leader`, `disruptor`, `niche-specialist` |
| `strategy` | How a company competes | `platform-play`, `open-source-core`, `land-and-expand` |
| `business_model` | Revenue and delivery structure | `subscription`, `consumption-based`, `freemium` |
| `risk_factor` | Threats and vulnerabilities | `vendor-lock-in`, `regulatory-exposure`, `tech-debt` |
| `growth_pattern` | How companies expand | `organic-growth`, `acquisition-driven`, `partner-ecosystem` |

These categories reflect structural facets of market analysis that recur regardless of whether the research subject is observability platforms, cybersecurity tooling, or cloud databases. The base vocabulary changes infrequently and only through deliberate updates to the schema file.

### Topic-specific vocabulary

At the start of each research session, the orchestrator generates 15-25 additional terms tailored to the research topic. These terms fill categories that the base vocabulary cannot anticipate -- `market_segment`, `technology`, or `domain_specific` categories that only make sense in context.

For example, a research session on observability might generate terms like `distributed-tracing`, `log-aggregation`, `apm`, and `opentelemetry-native`. These terms would be meaningless in a study of enterprise CRM, which would generate its own topic-specific terms instead.

The generation process derives terms from the elicitation phase: the topic itself, the decision context, scope boundaries, research priorities, and known competitors. Each generated term must plausibly appear in findings from at least two dimensions -- this threshold prevents hyper-specific terms that only one analyst would ever use.

## Base vocabulary inheritance

Topic-specific vocabularies do not replace the base vocabulary. They inherit from it and extend it. The topic vocabulary file carries an `"inherits": "base"` field that signals this relationship. At build time, the orchestrator merges all base categories with the topic-specific categories, producing a single `all_terms` array that contains every valid tag for the session.

This inheritance model means:

- Every research session shares the structural categories from the base. A finding tagged `market-leader` in one study means the same thing as `market-leader` in another.
- Topic-specific categories layer on top without disturbing the shared foundation.
- If the base vocabulary gains a new term, every future session automatically inherits it.

The `all_terms` array serves as the authoritative reference for analysts. Dimension-analysts load this array and must select their `tags` values exclusively from it. Terms outside the vocabulary go into `proposed_tags` for orchestrator review.

## Tag normalization

Every tag, entity, and proposed tag in sigint uses **lowercase-hyphenated format**: letters and digits separated by hyphens, no uppercase, no spaces, no special characters. The schema enforces this with the pattern `^[a-z0-9]+(-[a-z0-9]+)*$`.

This constraint exists for several reasons:

- **Deterministic matching.** Case-insensitive comparison is locale-dependent and error-prone. Forcing a single canonical form means string equality is sufficient for tag comparison.
- **URL and filename safety.** Lowercase-hyphenated strings work as URL slugs, JSON keys, and filesystem paths without escaping.
- **Reduced ambiguity.** "OpenTelemetry" vs "opentelemetry" vs "open-telemetry" collapses to a single form. The normalization step in the orchestrator's compliance phase applies `ascii_downcase` and replaces non-alphanumeric characters with hyphens, so even if an analyst writes a tag in the wrong format, it gets corrected before merge.

Entity names follow the same convention. A company like "New Relic" becomes `new-relic`. The entity gazetteer (described below) provides the canonical mapping so analysts do not need to invent their own normalization.

## Proposed tag promotion

Controlled vocabularies face a tension: too restrictive and analysts cannot express what they observe; too permissive and the vocabulary provides no value. Sigint resolves this with a promotion mechanism.

When an analyst encounters a concept not covered by the vocabulary, they place up to three terms in the `proposed_tags` field of the finding. These terms are not official vocabulary -- they are candidates.

During the orchestrator's tag compliance phase, proposed tags from all dimensions are collected and counted. The promotion rule is straightforward: **if a proposed tag appears in findings from two or more different dimensions, it gets promoted to official vocabulary.** The orchestrator adds the term to the appropriate category in `vocabulary.json`, moves it from `proposed_tags` to `tags` in every finding that used it, and updates `all_terms`.

The two-dimension threshold is the key design decision. A term that only one analyst proposes might reflect a narrow observation or an idiosyncratic labeling choice. A term that two independent analysts working on different aspects of the same topic both reach for is likely capturing a real concept that the vocabulary should recognize. This threshold balances openness (the vocabulary can grow) with discipline (growth requires corroboration).

Promotion happens at merge time, which means vocabulary evolution is session-scoped. In update and augment sessions, the orchestrator loads the existing vocabulary rather than generating a new one, so promoted terms from earlier sessions persist and accumulate.

## Entity gazetteer

Tags describe concepts. Entities describe specific named things -- companies, products, standards, people. Sigint treats these as separate concerns.

The optional entity gazetteer (`entity-gazetteer.json`) provides a reference list of known entities with their canonical lowercase-hyphenated keys. When an analyst identifies an entity in a finding, they check the gazetteer for the canonical form. "Datadog" becomes `datadog`. "Amazon Web Services" becomes `amazon-web-services` or whatever key the gazetteer specifies.

The gazetteer is optional because not every research session starts with a known entity list. When it exists, the orchestrator validates entity values against it during compliance checking. Unregistered entities (those not in the gazetteer) are logged but accepted -- they represent new entities discovered during research rather than errors.

The gazetteer's role is consistency, not restriction. It prevents the same company from appearing as `new-relic`, `newrelic`, and `new-relic-inc` across different findings.

## Vocabulary evolution across sessions

Sigint supports three session modes -- full, update, and augment -- and the vocabulary behaves differently in each.

In a **full** session, the orchestrator generates a fresh topic-specific vocabulary from elicitation context and merges it with the base vocabulary. This is the vocabulary's initial state.

In **update** and **augment** sessions, the orchestrator loads the existing `vocabulary.json` from the previous session rather than regenerating it. This preserves all prior terms, including any that were promoted from proposed tags. The vocabulary only grows in these sessions; terms are never removed.

This accumulative behavior means that a research topic studied over multiple sessions develops an increasingly precise vocabulary. Early sessions establish the broad strokes. Later sessions fill in terminology that the initial generation could not anticipate. The promotion mechanism ensures that this growth is evidence-driven rather than arbitrary.

If a topic vocabulary file is missing when an update or augment session starts (for example, because the topic predates the vocabulary system), the orchestrator falls back to full generation mode, creating a vocabulary from the current elicitation context.

## See also

- [Skills Reference](../reference/skills.md) -- individual skill definitions including dimension-analyst tagging behavior
- [Architecture](architecture.md) -- how the orchestrator, analysts, and vocabulary system interact at runtime
- [Research Workflow](../how-to/research-workflow.md) -- step-by-step guide to running research sessions
