# Schema: findings_{dimension}.json (per-dimension findings)
# Usage: jq -e -f schemas/findings.jq ./reports/{slug}/findings_{dim}.json > /dev/null

def valid_confidence: IN("high", "medium", "low");
def valid_trend: IN("INC", "DEC", "CONST");
def valid_derivation: IN("direct_quote", "synthesis", "extrapolation");
def valid_dimension: IN("competitive", "sizing", "trends", "customer", "tech", "financial", "regulatory", "trend_modeling");

(type == "object") and
has("dimension") and (.dimension | type == "string" and valid_dimension) and
has("status")    and (.status    | type == "string" and IN("complete", "in_progress", "partial")) and
has("findings")  and (.findings  | type == "array") and
has("sources")   and (.sources   | type == "array") and
has("gaps")      and (.gaps      | type == "array" and all(type == "string")) and

# Validate each finding
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
    has("claim") and (.claim | type == "string") and
    has("sources") and (.sources | type == "array" and all(
      type == "object" and
      has("url") and (.url | type == "string") and
      has("fetched_at") and (.fetched_at | type == "string") and
      has("snippet") and (.snippet | type == "string") and
      has("alive") and (.alive | type == "boolean")
    )) and
    has("derivation") and (.derivation | type == "string" and valid_derivation) and
    has("confidence_basis") and (.confidence_basis | type == "string")
  ) and

  # Optional delta fields (present in delta output files)
  (if has("delta_type") then (.delta_type | type == "string" and IN("NEW", "UPDATED", "CONFIRMED", "POTENTIALLY_REMOVED", "TREND_REVERSAL")) else true end) and
  (if has("delta_detail") then (.delta_detail | type == "object" and
    has("changed_fields") and (.changed_fields | type == "array" and all(type == "string" and IN("summary", "confidence", "trend", "tags", "entities", "sources", "market_dynamic", "provenance"))) and
    has("change_category") and (.change_category | type == "string" and IN("substantive", "metadata", "temporal", "confidence_shift", "source_refresh")) and
    has("newsworthiness") and (.newsworthiness | type == "string" and IN("high", "medium", "low")) and
    has("newsworthiness_basis") and (.newsworthiness_basis | type == "string") and
    (if has("summary_diff") then (.summary_diff | type == "string" or . == null) else true end) and
    (if has("confidence_change") then (.confidence_change | . == null or (type == "object" and has("previous") and has("current"))) else true end) and
    (if has("trend_change") then (.trend_change | . == null or (type == "object" and has("previous") and has("current"))) else true end)
  ) else true end)
)) and

# Validate each source
(.sources | all(
  type == "object" and
  has("url") and (.url | type == "string") and
  has("title") and (.title | type == "string") and
  has("reliability") and (.reliability | type == "string" and valid_confidence)
))
