---
diataxis_type: how-to
title: Falsify Research Findings
description: Run adversarial assessment on findings to identify and remediate defeasible claims
---

# Falsify Research Findings

`/sigint:falsify` runs adversarial assessment on the active research session. Unlike codex review (which checks whether sources are real), falsification asks whether claims can be **disconfirmed** — and remediates the ones that can.

**Prerequisites:**

- `jq` installed
- An active research session in `./reports/<topic>/state.json` with at least one finding
- Web access (the falsification analyst uses `WebSearch` and `WebFetch` exclusively)

---

## Quick start

Run with defaults — block-mode, all findings, 6 queries per claim, 50-claim budget:

```bash
/sigint:falsify
```

The skill will:

1. Decompose each finding into 1–3 atomic claims.
2. Generate 5 template negation queries + 1 LLM-counter-hypothesis query per claim.
3. Execute web-only adversarial search for disconfirming evidence.
4. Assign one of four ordinal verdicts per claim: `falsified`, `weakened`, `survived`, `inconclusive`.
5. Apply remediation atomically — quarantine, downgrade, or annotate findings.
6. Write a falsification report and a follow-up queue for `/sigint:issues`.

---

## Verdict and remediation table

| Verdict | What it means | Remediation applied |
|---|---|---|
| `falsified` | A high-credibility source directly contradicts the claim | Move to `quarantine.json` with `gate: "post-falsification"`; queue retraction issue |
| `weakened` | A credible source qualifies, narrows, or supplies an alternative explanation | Downgrade confidence one level; append disconfirming source to provenance; narrow summary text; queue follow-up issue comment |
| `survived` | All queries executed; no disconfirming evidence found | Annotate `provenance.falsification_attempts`; optional confidence upgrade if 2+ credible non-disconfirming sources |
| `inconclusive` | Search budget exhausted, queries failed, or claim too vague to test | Annotate only; no state change |

**Bounded epistemics**: `survived` is not proof. The report includes the actual query budget used so readers can judge how exhaustive the attempt was.

---

## Common scopes

```bash
# Single dimension
/sigint:falsify --scope dimension:competitive

# Single finding
/sigint:falsify --scope finding:f_competitive_3

# Advisory mode — annotate only, do not block downstream phases
/sigint:falsify --mode advisory

# Tighten budgets for a fast pass
/sigint:falsify --query-budget 4 --claim-budget 25
```

---

## Inspect the falsification report

Each run writes two paired files:

```bash
jq '.verdicts, .by_finding' ./reports/<topic>/$(date -u +%Y-%m-%d)-falsification-report.json
```

```bash
cat ./reports/<topic>/$(date -u +%Y-%m-%d)-falsification-report.md
```

The Markdown companion is human-readable: executive summary, per-claim verdicts (sorted falsified → weakened → inconclusive → survived), disconfirming evidence with citations, remediation queue, and the epistemic caveat.

---

## Inspect a finding's falsification history

```bash
jq '.findings[] | select(.id == "f_competitive_3") | .provenance.falsification_attempts' \
  ./reports/<topic>/state.json
```

Each entry records the round (`attempted_at`, `scope`), every claim tested, the queries executed, the disconfirming sources found, and the verdict with rationale.

---

## Process the followups queue

`/sigint:falsify` writes `YYYY-MM-DD-falsification-followups.json` listing findings that need new or updated GitHub issues:

```bash
jq '.items' ./reports/<topic>/YYYY-MM-DD-falsification-followups.json
```

Run `/sigint:issues` to apply them:

```bash
/sigint:issues
```

The issue-architect picks up the followups file automatically. Each item maps to one of: `open_issue` (new retraction), `comment_issue` (new evidence on existing issue), `close_issue` (retract prior issue), or `annotate` (log only).

---

## When falsification runs automatically

The orchestrator invokes `/sigint:falsify` as **Phase 3.6** after post-merge codex review and before progress rendering. This happens during:

- `/sigint:start` — initial research
- `/sigint:update` — refresh
- `/sigint:augment` — single-dimension addition

To skip the gate during orchestration, set in `sigint.config.json`:

```json
{
  "global": {
    "falsify": {
      "enabled": false
    }
  }
}
```

To run only standalone (not as a gate), set `enabled: false` and invoke `/sigint:falsify` manually when desired.

---

## Re-running on the same session

The skill enforces a **one-round-per-session rule**. Findings that already carry `provenance.falsification_attempts` from the current session are skipped (verdict: `inconclusive`, reason: `already_falsified_this_session`). To re-falsify after applying fixes, run `/sigint:augment <dimension>` first to refresh the affected dimension's findings — the new findings will not have prior attempts attached.

---

## Troubleshooting

**"Working set has N findings; claim budget is M. Proceed?"**
The skill never silently truncates. Either raise the claim budget, narrow the scope, or cancel.

**"Query budget exhausted"**
The analyst hit `QUERY_BUDGET × claim_count` total queries before finishing. Remaining claims are marked `inconclusive`. Either raise `--query-budget` or narrow scope.

**Falsified findings disappeared from `state.json`**
By design — they were moved to `quarantine.json` with `gate: "post-falsification"`. See [Work with Quarantine](work-with-quarantine.md) for inspection and recovery.

**A `survived` verdict feels overconfident**
Read the report's epistemic caveat. `survived` only means N adversarial queries did not produce disconfirming evidence. Increase `--query-budget` for a more aggressive attempt.
