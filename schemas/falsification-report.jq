# Schema: YYYY-MM-DD-falsification-report.json
# Usage: jq -e -f schemas/falsification-report.jq ./reports/{slug}/{date}-falsification-report.json > /dev/null

def valid_verdict: IN("falsified", "weakened", "survived", "inconclusive");
def valid_delta: IN("quarantine", "downgrade_one_level", "unchanged", "upgrade_one_level");
def valid_relation: IN("disconfirms", "weakens", "alternative_explanation", "irrelevant");

(type == "object") and
has("topic_slug")              and (.topic_slug              | type == "string" and length > 0) and
has("generated_at")            and (.generated_at            | type == "string" and length > 0) and
has("scope")                   and (.scope                   | type == "string" and length > 0) and
has("claim_budget")            and (.claim_budget            | type == "number") and
has("query_budget_per_claim")  and (.query_budget_per_claim  | type == "number") and
has("claims_evaluated")        and (.claims_evaluated        | type == "number") and
has("queries_executed_total")  and (.queries_executed_total  | type == "number") and
has("verdicts")                and (.verdicts                | type == "object" and
  has("falsified")    and (.falsified    | type == "number") and
  has("weakened")     and (.weakened     | type == "number") and
  has("survived")     and (.survived     | type == "number") and
  has("inconclusive") and (.inconclusive | type == "number")
) and
has("by_finding")              and (.by_finding              | type == "array" and all(
  type == "object" and
  has("finding_id")    and (.finding_id    | type == "string") and
  has("dimension")     and (.dimension     | type == "string") and
  has("verdicts")      and (.verdicts      | type == "object") and
  has("worst_verdict") and (.worst_verdict | type == "string" and valid_verdict)
)) and
has("remediation_queue")       and (.remediation_queue       | type == "array" and all(
  type == "object" and
  has("finding_id") and (.finding_id | type == "string") and
  has("action")     and (.action     | type == "string" and IN("quarantine", "downgrade", "annotate", "upgrade")) and
  has("reason")     and (.reason     | type == "string" and length > 0)
)) and
has("epistemic_caveat")        and (.epistemic_caveat        | type == "string" and length > 0)
