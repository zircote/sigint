# Schema: findings_{dimension}_reflection.json
# Usage: jq -e -f schemas/reflection.jq ./reports/{slug}/findings_{dim}_reflection.json > /dev/null

(type == "object") and
has("iteration")               and (.iteration               | type == "number" and . >= 1) and
has("methodology_gaps_found")  and (.methodology_gaps_found  | type == "array" and all(type == "string")) and
has("evidence_gaps_found")     and (.evidence_gaps_found     | type == "array" and all(type == "string")) and
has("additional_searches")     and (.additional_searches     | type == "number" and . >= 0) and
has("gaps_resolved")           and (.gaps_resolved           | type == "array" and all(type == "string")) and
has("gaps_remaining")          and (.gaps_remaining          | type == "array" and all(type == "string"))
