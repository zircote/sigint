# Schema: quarantine.json
# Usage: jq -e -f schemas/quarantine.jq ./reports/{slug}/quarantine.json > /dev/null

(type == "object") and
has("quarantined_at") and (.quarantined_at | type == "string" and length > 0) and
has("items")          and (.items          | type == "array" and all(
  type == "object" and
  has("finding_id")          and (.finding_id          | type == "string") and
  has("original_dimension")  and (.original_dimension  | type == "string") and
  has("reason")              and (.reason              | type == "string" and length > 0) and
  has("gate")                and (.gate                | type == "string" and IN("post-findings", "post-merge")) and
  has("gate_timestamp")      and (.gate_timestamp      | type == "string") and
  has("original_finding")    and (.original_finding    | type == "object")
))
