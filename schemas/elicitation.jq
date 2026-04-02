# Schema: elicitation.json (research elicitation context)
# Usage: jq -e -f schemas/elicitation.jq ./reports/{slug}/elicitation.json > /dev/null

(type == "object") and
has("decision_context") and (.decision_context | type == "string" and length > 0) and
has("priorities")       and (.priorities       | type == "array" and length > 0 and all(type == "string")) and
has("dimensions")       and (.dimensions       | type == "array" and length > 0 and all(type == "string")) and

# Optional but typed fields
(if has("audience") then (.audience | type == "string") else true end) and
(if has("audience_expertise") then (.audience_expertise | type == "string") else true end) and
(if has("scope") then (.scope | type == "object") else true end) and
(if has("hypotheses") then (.hypotheses | type == "array" and all(type == "string")) else true end) and
(if has("success_criteria") then (.success_criteria | type == "array" and all(type == "string")) else true end) and
(if has("anti_patterns") then (.anti_patterns | type == "array" and all(type == "string")) else true end) and
(if has("budget_context") then (.budget_context | type == "string") else true end) and
(if has("timeline") then (.timeline | type == "string") else true end) and
(if has("known_competitors") then (.known_competitors | type == "array" and all(type == "string")) else true end) and
(if has("default_repo") then (.default_repo | type == "string" or . == null) else true end)
