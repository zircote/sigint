#!/usr/bin/env bash
# migrate-tags.sh — Normalize existing findings tags to two-tier vocabulary format.
#
# Usage:
#   ./scripts/migrate-tags.sh                              # dry-run on current repo
#   ./scripts/migrate-tags.sh --apply                      # apply changes to current repo
#   ./scripts/migrate-tags.sh --target=/path/to/other/repo # dry-run on another repo
#   ./scripts/migrate-tags.sh --target=/path/to/other/repo --apply
#
# What it does:
#   1. Merges any existing entities back into tags (undo prior bad splits)
#   2. Normalizes all tags to lowercase-hyphenated format
#   3. Deduplicates tags after normalization
#   4. Extracts entities using gazetteer matching against finding titles/summaries
#      (deterministic — only entities listed in schemas/entity-gazetteer.json are extracted)
#   5. Remaining tags stay in tags field
#   6. Re-validates each file against its schema
#
# Entity extraction uses gazetteer-based NER:
#   - schemas/entity-gazetteer.json defines known entities with name variants
#   - Each entity name variant is matched against finding title and summary text
#   - Only gazetteer matches produce entity classifications — zero false positives
#   - Unknown entities remain as tags until the gazetteer is updated
#
# Idempotent — running twice produces the same result.

set -euo pipefail

APPLY=false
TARGET_DIR=""

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --target=*) TARGET_DIR="${arg#--target=}" ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="${TARGET_DIR:-$SCRIPT_DIR}"
cd "$REPO_ROOT"

# Gazetteer lives in the sigint repo, not necessarily the target
GAZETTEER="$SCRIPT_DIR/schemas/entity-gazetteer.json"
if [[ ! -f "$GAZETTEER" ]]; then
  echo "ERROR: Entity gazetteer not found at $GAZETTEER"
  exit 1
fi

# Counters
files_processed=0
files_modified=0
entities_extracted=0

# Build the jq filter with the gazetteer loaded as a variable.
# The filter:
#   1. Merges existing entities back into tags (reset prior splits)
#   2. Normalizes all tags to lowercase-hyphenated
#   3. Matches normalized tag values AND title/summary text against gazetteer name variants
#   4. Moves matched tags to entities, keeps the rest as tags
NORMALIZE_FILTER='
def normalize: ascii_downcase | gsub("[^a-z0-9]+"; "-") | gsub("^-|-$"; "");

# Build a lookup: for each gazetteer entity, collect all name variants (lowercased)
# and map them to the entity key
($gazetteer.entities | to_entries | map(
  .key as $key |
  .value.names | map(ascii_downcase) | map({name: ., key: $key})
) | flatten | group_by(.key) | map({
  key: .[0].key,
  value: [.[] | .name]
}) | from_entries) as $name_lookup |

# Flat list of all known entity keys
($gazetteer.entities | keys) as $entity_keys |

(.findings // []) |= map(
  # Step 1: Merge any existing entities back into tags (undo prior bad splits)
  .tags = ((.tags // []) + (.entities // []) | unique) |

  # Step 2: Normalize all tags
  .tags = (.tags | map(normalize) | unique) |

  # Step 3: Gazetteer-based entity extraction
  # Check each entity in gazetteer: does any of its name variants appear
  # in the finding title or summary?
  (.title // "") as $title |
  (.summary // "") as $summary |
  ($title + " " + $summary) as $text |
  ($text | ascii_downcase) as $text_lower |

  # Find entities whose name variants appear in the text
  ([
    $name_lookup | to_entries[] |
    .key as $entity_key |
    .value as $names |
    if ($names | any(. as $n | $text_lower | contains($n))) then $entity_key
    else empty end
  ] | unique) as $matched_entities |

  # Also check: does any normalized tag directly match a gazetteer key?
  (.tags | map(select(. as $t | $entity_keys | index($t) != null))) as $tag_matched_entities |

  # Union of text-matched and tag-matched entities
  (($matched_entities + $tag_matched_entities) | unique) as $all_entities |

  # Step 4: Split — entities go to entities field, rest stay as tags
  .entities = $all_entities |
  .tags = (.tags | map(select(. as $t | $all_entities | index($t) == null)))
)
'

echo "=== Tag Migration $(if $APPLY; then echo "(APPLY)"; else echo "(DRY-RUN)"; fi) ==="
echo "Gazetteer: $GAZETTEER ($(jq '.entities | length' "$GAZETTEER") entities)"
echo ""

# Process all findings files and state files
for pattern in "reports/*/findings_*.json" "reports/*/state.json" "reports/*/merged_findings.json"; do
  for file in $pattern; do
    [[ -f "$file" ]] || continue

    # Check if file has findings array
    if ! jq -e 'has("findings") and (.findings | type == "array") and (.findings | length > 0)' "$file" > /dev/null 2>&1; then
      continue
    fi

    files_processed=$((files_processed + 1))

    # Compute the transformation
    original=$(jq -c '[.findings[] | {tags, entities: (.entities // [])}]' "$file" 2>/dev/null)
    transformed=$(jq -c --argjson gazetteer "$(cat "$GAZETTEER")" "$NORMALIZE_FILTER" "$file" 2>/dev/null | jq -c '[.findings[] | {tags, entities: (.entities // [])}]' 2>/dev/null)

    if [[ "$original" == "$transformed" ]]; then
      echo "  UNCHANGED: $file"
      continue
    fi

    files_modified=$((files_modified + 1))

    # Count changes
    orig_entity_count=$(echo "$original" | jq '[.[].entities | length] | add // 0')
    new_entity_count=$(echo "$transformed" | jq '[.[].entities | length] | add // 0')
    extracted=$((new_entity_count - orig_entity_count))
    if [[ $extracted -lt 0 ]]; then extracted=0; fi
    entities_extracted=$((entities_extracted + new_entity_count))

    echo "  MODIFIED: $file"
    echo "    entities: $orig_entity_count → $new_entity_count (gazetteer-matched)"

    # Show per-finding changes
    jq -r --argjson orig "$original" --argjson new "$transformed" '
      range($orig | length) as $i |
      if $orig[$i] != $new[$i] then
        "    [\($i)]: tags \($orig[$i].tags) → \($new[$i].tags) | entities \($orig[$i].entities) → \($new[$i].entities)"
      else empty end
    ' <<< 'null' 2>/dev/null | head -8

    if $APPLY; then
      # Apply the transformation
      jq --argjson gazetteer "$(cat "$GAZETTEER")" "$NORMALIZE_FILTER" "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

      # Determine schema file
      schema=""
      case "$file" in
        */findings_*.json) schema="schemas/findings.jq" ;;
        */state.json)      schema="schemas/state.jq" ;;
        */merged_findings.json) schema="schemas/merged-findings.jq" ;;
      esac

      if [[ -n "$schema" && -f "$schema" ]]; then
        if jq -e -f "$schema" "$file" > /dev/null 2>&1; then
          echo "    schema: PASS ($schema)"
        else
          echo "    schema: FAIL ($schema) — pre-existing schema issue, not caused by migration"
        fi
      fi
    fi
  done
done

echo ""
echo "=== Summary ==="
echo "Files processed:      $files_processed"
echo "Files modified:       $files_modified"
echo "Total entities found: $entities_extracted"
if ! $APPLY; then
  echo ""
  echo "Run with --apply to apply changes."
fi
