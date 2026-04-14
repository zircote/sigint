# Schema: findings_delta_YYYY-MM-DD.json (delta detection output)
# Usage: jq -e -f schemas/delta-findings.jq ./reports/{slug}/findings_delta_YYYY-MM-DD.json > /dev/null

def valid_confidence: IN("high", "medium", "low");
def valid_trend: IN("INC", "DEC", "CONST");
def valid_derivation: IN("direct_quote", "synthesis", "extrapolation");
def valid_dimension: IN("competitive", "sizing", "trends", "customer", "tech", "financial", "regulatory", "trend_modeling");
def valid_delta_type: IN("NEW", "UPDATED", "CONFIRMED", "POTENTIALLY_REMOVED", "TREND_REVERSAL");
def valid_change_category: IN("substantive", "metadata", "temporal", "confidence_shift", "source_refresh");
def valid_newsworthiness: IN("high", "medium", "low");
def valid_changed_field: IN("summary", "confidence", "trend", "tags", "entities", "sources", "market_dynamic", "provenance");

(type == "object") and
has("dimension")     and (.dimension     | type == "string") and
has("mode")          and (.mode          | type == "string") and
has("baseline_date") and (.baseline_date | type == "string") and
has("refresh_date")  and (.refresh_date  | type == "string") and
has("status")        and (.status        | type == "string" and IN("complete", "in_progress", "partial")) and
has("findings")      and (.findings      | type == "array") and

# Validate each finding
(.findings | all(
  type == "object" and
  has("id") and (.id | type == "string") and
  has("title") and (.title | type == "string") and
  has("summary") and (.summary | type == "string") and
  has("delta_type") and (.delta_type | type == "string" and valid_delta_type) and

  # delta_detail is required on UPDATED findings, optional otherwise
  (if .delta_type == "UPDATED" then
    has("delta_detail") and (.delta_detail | type == "object" and
      has("changed_fields") and (.changed_fields | type == "array" and all(type == "string" and valid_changed_field)) and
      has("change_category") and (.change_category | type == "string" and valid_change_category) and
      has("newsworthiness") and (.newsworthiness | type == "string" and valid_newsworthiness) and
      has("newsworthiness_basis") and (.newsworthiness_basis | type == "string") and
      (if has("summary_diff") then (.summary_diff | type == "string" or . == null) else true end) and
      (if has("confidence_change") then (.confidence_change | . == null or (type == "object" and has("previous") and has("current"))) else true end) and
      (if has("trend_change") then (.trend_change | . == null or (type == "object" and has("previous") and has("current"))) else true end)
    )
  else true end) and

  # Standard finding fields (relaxed — delta findings may omit some)
  (if has("confidence") then (.confidence | (type == "string" and valid_confidence) or type == "number") else true end) and
  (if has("trend") then (.trend | type == "string" and valid_trend) else true end) and
  (if has("tags") then (.tags | type == "array" and all(type == "string")) else true end) and
  (if has("entities") then (.entities | type == "array" and all(type == "string")) else true end) and
  (if has("market_dynamic") then (.market_dynamic | type == "string" and IN("consolidation", "disruption", "maturation", "emergence", "fragmentation", "commoditization", "regulation", "standardization")) else true end)
))
