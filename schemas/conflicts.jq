# Schema: conflicts.json
# Usage: jq -e -f schemas/conflicts.jq ./reports/{slug}/conflicts.json > /dev/null

(type == "object") and
has("detected_at") and (.detected_at | type == "string" and length > 0) and
has("conflicts")   and (.conflicts   | type == "array" and all(
  type == "object" and
  has("dimension_a")  and (.dimension_a  | type == "string") and
  has("dimension_b")  and (.dimension_b  | type == "string") and
  has("description")  and (.description  | type == "string" and length > 0) and
  (if has("severity") then (.severity | type == "string" and IN("critical", "high", "medium", "low")) else true end)
))
