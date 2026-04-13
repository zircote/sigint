# Schema: state.json (research session state)
# Usage: jq -e -f schemas/state.jq ./reports/{slug}/state.json > /dev/null

def valid_status: IN("active", "complete", "archived");
def valid_phase: IN("discovery", "analysis", "synthesis", "complete", "augmented");
def valid_confidence: IN("high", "medium", "low");
def valid_trend: IN("INC", "DEC", "CONST");
def valid_derivation: IN("direct_quote", "synthesis", "extrapolation");
def valid_action: IN("initial_research", "scheduled_update", "augment");

(type == "object") and
has("topic")      and (.topic      | type == "string" and length > 0) and
has("topic_slug") and (.topic_slug | type == "string" and length > 0) and
has("started")    and (.started    | type == "string" and length > 0) and
has("status")     and (.status     | type == "string" and valid_status) and
has("phase")      and (.phase      | type == "string" and valid_phase) and
has("elicitation") and (.elicitation | type == "object") and
has("findings")   and (.findings   | type == "array") and
has("sources")    and (.sources    | type == "array") and
has("lineage")    and (.lineage    | type == "array") and

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
    has("sources") and (.sources | type == "array") and
    has("derivation") and (.derivation | type == "string" and valid_derivation)
  )
)) and

# Validate each source
(.sources | all(
  type == "object" and
  has("url") and (.url | type == "string") and
  has("title") and (.title | type == "string") and
  has("reliability") and (.reliability | type == "string" and valid_confidence)
)) and

# Validate each lineage entry
(.lineage | all(
  type == "object" and
  has("session_id") and (.session_id | type == "string") and
  has("action") and (.action | type == "string" and valid_action) and
  has("dimensions") and (.dimensions | type == "array") and
  has("finding_count") and (.finding_count | type == "number")
))
