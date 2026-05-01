# Schema: falsification-followups.json
# Usage: jq -e -f schemas/falsification-followups.jq ./reports/{slug}/falsification-followups.json > /dev/null

(type == "object") and
has("generated_at") and (.generated_at | type == "string" and length > 0) and
has("items")        and (.items        | type == "array" and all(
  type == "object" and
  has("finding_id")           and (.finding_id           | type == "string" and length > 0) and
  has("action")               and (.action               | type == "string" and IN("open_issue", "comment_issue", "close_issue", "annotate")) and
  has("reason")               and (.reason               | type == "string" and length > 0) and
  has("disconfirming_sources") and (.disconfirming_sources | type == "array" and all(type == "string")) and
  # Optional: set by /sigint:issues when this item has been actioned
  (if has("processed") then (.processed | type == "object" and
    has("at")  and (.at  | type == "string") and
    has("url") and (.url | type == "string")
  ) else true end)
))
