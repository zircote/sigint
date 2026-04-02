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
  )
)) and

# Validate each source
(.sources | all(
  type == "object" and
  has("url") and (.url | type == "string") and
  has("title") and (.title | type == "string") and
  has("reliability") and (.reliability | type == "string" and valid_confidence)
))
