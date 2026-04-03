# Schema: sigint.config.json (v2.0)
# Usage: jq -e -f schemas/sigint-config.jq ./sigint.config.json > /dev/null
#
# Exit 0 = valid, non-zero = invalid
#
# Topic entries support two forms:
#   Minimal (legacy/context-only): { "context_file": "..." }
#   Lifecycle-managed: { "status": "...", "dimensions": [...], "created": "...", ... }

(type == "object") and
has("version")  and (.version  | type == "string" and . == "2.0") and
has("defaults") and (.defaults | type == "object") and
has("research") and (.research | type == "object") and
has("topics")   and (.topics   | type == "object") and

(.defaults |
  has("report_format") and (.report_format | type == "string" and IN("markdown", "html", "both")) and
  has("audiences")     and (.audiences     | type == "array" and length > 0 and all(type == "string")) and
  has("auto_atlatl")   and (.auto_atlatl   | type == "boolean")
) and

(.research |
  has("maxDimensions")     and (.maxDimensions     | type == "number" and . > 0) and
  has("dimensionTimeout")  and (.dimensionTimeout  | type == "number" and . > 0) and
  has("defaultPriorities") and (.defaultPriorities | type == "array" and length > 0 and all(type == "string"))
) and

# Validate each topic entry — either minimal or lifecycle-managed
(.topics | to_entries | all(.value |
  type == "object" and (
    # Minimal form: just context_file, no status field
    (has("context_file") and (has("status") | not)) or
    # Lifecycle-managed form: status + dimensions + created + reports_dir required
    (
      has("status")     and (.status     | type == "string" and IN("in_progress", "complete", "stale")) and
      has("dimensions") and (.dimensions | type == "array" and all(type == "string")) and
      has("created")    and (.created    | type == "string") and
      has("reports_dir") and (.reports_dir | type == "string") and
      # Optional fields validated when present
      (if has("updated")          then (.updated          | type == "string")             else true end) and
      (if has("findings_count")   then (.findings_count   | type == "number" and . >= 0)  else true end) and
      (if has("atlatl_memory_id") then (.atlatl_memory_id | type == "string")             else true end) and
      (if has("context_file")     then (.context_file     | type == "string")             else true end)
    )
  )
))
