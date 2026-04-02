# Schema: methodology_plan_{dimension}.json
# Usage: jq -e -f schemas/methodology-plan.jq ./reports/{slug}/methodology_plan_{dim}.json > /dev/null

def valid_dimension: IN("competitive", "sizing", "trends", "customer", "tech", "financial", "regulatory", "trend_modeling");

(type == "object") and
has("dimension")  and (.dimension  | type == "string" and valid_dimension) and
has("frameworks") and (.frameworks | type == "array" and length > 0 and all(
  type == "object" and
  has("name") and (.name | type == "string") and
  has("required") and (.required | type == "string" and IN("yes", "conditional")) and
  has("condition_met") and (.condition_met | type == "boolean" or . == null)
)) and
has("expected_sections") and (.expected_sections | type == "array" and all(type == "string")) and
has("reference_files")   and (.reference_files   | type == "array" and all(type == "string"))
