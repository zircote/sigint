# Schema: sigint.config.json (v2.0)
# Usage: jq -e -f schemas/sigint-config.jq ./sigint.config.json > /dev/null
#
# Exit 0 = valid, non-zero = invalid

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

(.topics | to_entries | all(.value | type == "object"))
