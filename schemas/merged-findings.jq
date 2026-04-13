# Schema: merged_findings.json
# Usage: jq -e -f schemas/merged-findings.jq ./reports/{slug}/merged_findings.json > /dev/null

def valid_confidence: IN("high", "medium", "low");
def valid_trend: IN("INC", "DEC", "CONST");
def valid_derivation: IN("direct_quote", "synthesis", "extrapolation");

(type == "object") and
has("findings")              and (.findings              | type == "array") and
has("methodology_coverage")  and (.methodology_coverage  | type == "object") and

# Validate each finding (same shape as findings_{dim}.json findings)
(.findings | all(
  type == "object" and
  has("id") and (.id | type == "string") and
  has("title") and (.title | type == "string") and
  has("summary") and (.summary | type == "string") and
  has("confidence") and (.confidence | type == "string" and valid_confidence) and
  has("trend") and (.trend | type == "string" and valid_trend) and
  has("tags") and (.tags | type == "array" and all(type == "string")) and
  (if has("entities") then (.entities | type == "array" and all(type == "string")) else true end) and
  (if has("market_dynamic") then (.market_dynamic | type == "string" and IN("consolidation", "disruption", "maturation", "emergence", "fragmentation", "commoditization", "regulation", "standardization")) else true end) and
  (if has("proposed_tags") then (.proposed_tags | type == "array" and length <= 3 and all(type == "string")) else true end) and
  has("provenance") and (.provenance | type == "object" and
    has("claim") and has("sources") and has("derivation")
  )
)) and

# Validate methodology_coverage entries
(.methodology_coverage | to_entries | all(.value |
  type == "object" and
  has("planned") and (.planned | type == "array") and
  has("applied") and (.applied | type == "array")
)) and

# Validate conflicts if present
(if has("conflicts") then (.conflicts | type == "array" and all(
  type == "object" and
  has("dimension_a") and has("dimension_b") and has("description")
)) else true end)
