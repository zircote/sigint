# Schema: vocabulary.json (tag vocabulary — base or topic-specific)
# Usage: jq -e -f schemas/vocabulary.jq schemas/base-vocabulary.json > /dev/null
# Usage: jq -e -f schemas/vocabulary.jq ./reports/{slug}/vocabulary.json > /dev/null

(type == "object") and
has("version")    and (.version    | type == "string" and length > 0) and
has("categories") and (.categories | type == "object" and length > 0) and

# Every category must be a non-empty array of lowercase-hyphenated strings
(.categories | to_entries | all(
  .value | type == "array" and length > 0 and all(
    type == "string" and test("^[a-z0-9]+(-[a-z0-9]+)*$")
  )
)) and

# Optional fields — typed when present
(if has("inherits")   then (.inherits   | type == "string") else true end) and
(if has("generated")  then (.generated  | type == "string") else true end) and
(if has("topic_slug") then (.topic_slug | type == "string") else true end) and

# all_terms required for topic vocabularies (inherits present), optional for base
(if has("all_terms") then (
  .all_terms | type == "array" and all(
    type == "string" and test("^[a-z0-9]+(-[a-z0-9]+)*$")
  )
) else
  # base vocabulary (no inherits) does not require all_terms
  (has("inherits") | not)
end)
