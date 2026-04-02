# Schema: YYYY-MM-DD-issues.json / issues-dry-run.json
# Usage: jq -e -f schemas/issues.jq ./reports/{slug}/YYYY-MM-DD-issues.json > /dev/null

def valid_category: IN("feature", "enhancement", "research", "action-item");
def valid_priority: IN("P0", "P1", "P2", "P3");

(type == "object") and
has("generated_at") and (.generated_at | type == "string" and length > 0) and
has("topic")        and (.topic        | type == "string" and length > 0) and
has("topic_slug")   and (.topic_slug   | type == "string" and length > 0) and
has("target_repo")  and (.target_repo  | type == "string" and length > 0) and
has("dry_run")      and (.dry_run      | type == "boolean") and
has("issues")       and (.issues       | type == "array" and all(
  type == "object" and
  has("title")    and (.title    | type == "string" and length > 0) and
  has("body")     and (.body     | type == "string") and
  has("category") and (.category | type == "string" and valid_category) and
  has("priority") and (.priority | type == "string" and valid_priority) and
  has("labels")   and (.labels   | type == "array" and all(type == "string")) and
  has("finding_reference") and (.finding_reference | type == "string") and
  has("acceptance_criteria") and (.acceptance_criteria | type == "array" and length >= 2 and all(type == "string"))
)) and

has("categories_summary") and (.categories_summary | type == "object")
