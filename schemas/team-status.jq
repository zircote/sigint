# Schema: team_status.json
# Usage: jq -e -f schemas/team-status.jq ./reports/{slug}/team_status.json > /dev/null

def valid_analyst_status: IN("pending", "in_progress", "complete", "failed");

(type == "object") and
has("team_name")    and (.team_name    | type == "string" and length > 0) and
has("status")       and (.status       | type == "string" and IN("active", "complete")) and
has("phase")        and (.phase        | type == "string" and length > 0) and
has("analysts")     and (.analysts     | type == "object" and (to_entries | all(.value |
  type == "object" and
  has("status") and (.status | type == "string" and valid_analyst_status) and
  has("finding_count") and (.finding_count | type == "number" and . >= 0)
))) and
has("last_updated") and (.last_updated | type == "string" and length > 0)
