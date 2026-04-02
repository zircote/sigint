# Schema: YYYY-MM-DD-report-metadata.json
# Usage: jq -e -f schemas/report-metadata.jq ./reports/{slug}/YYYY-MM-DD-report-metadata.json > /dev/null

(type == "object") and
has("generated_at")       and (.generated_at       | type == "string" and length > 0) and
has("topic")              and (.topic              | type == "string" and length > 0) and
has("topic_slug")         and (.topic_slug         | type == "string" and length > 0) and
has("format")             and (.format             | type == "string" and IN("markdown", "html", "both")) and
has("sections_included")  and (.sections_included  | type == "array" and length > 0 and all(type == "string")) and
has("dimensions_covered") and (.dimensions_covered | type == "array" and all(type == "string")) and
has("total_findings")     and (.total_findings     | type == "number" and . >= 0) and
has("total_sources")      and (.total_sources      | type == "number" and . >= 0) and
has("files_generated")    and (.files_generated    | type == "array" and length > 0 and all(type == "string")) and

(if has("confidence_levels") then (.confidence_levels | type == "object" and
  has("high") and has("medium") and has("low")
) else true end) and

(if has("quarantined_findings") then (.quarantined_findings | type == "number") else true end)
