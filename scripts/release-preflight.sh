#!/usr/bin/env bash

# Release preflight for a drip *registry* release: regenerate dist/ and validate
# it before the assets go to a GitHub Release. These are the checks no `gleam
# test` can make. See PUBLISHING.md.
#
# It re-runs codegen first, so it can never validate a stale dist/. Then it
# guards:
#   1. dist/registry.json parses as JSON.
#   2. Every file the index references exists in dist/ (plus theme.css).
#   3. The emitted set is dependency-closed: every listed element's dependencies
#      are themselves in the index. (codegen also fails on this; this is the
#      dist-level backstop, independent of the in-process check.)

set -euo pipefail
cd "$(dirname "$0")/.."

fail() {
  echo "release-preflight: $1" >&2
  exit 1
}

command -v jq >/dev/null 2>&1 \
  || fail "need jq on PATH to validate dist/registry.json"

( cd codegen && gleam run ) || fail "codegen failed"

dist="dist"
index="$dist/registry.json"

[ -f "$index" ] || fail "missing $index (codegen should have written it)"
[ -f "$dist/theme.css" ] || fail "missing $dist/theme.css"
jq empty "$index" 2>/dev/null || fail "$index is not valid JSON"

# Every referenced element file must exist in dist/.
missing=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if [ ! -f "$dist/$f" ]; then
    echo "release-preflight: referenced file absent from $dist/: $f" >&2
    missing=1
  fi
done < <(jq -r '.elements[].files[]' "$index")
[ "$missing" -eq 0 ] || fail "one or more referenced files are absent from $dist/"

# Dependency closure: every dependency must be an element name in the index. An
# element depending on one missing from the index would dead-end the CLI's
# closure on Unknown.
names=$(jq -r '.elements[].name' "$index" | sort -u)
unclosed=0
while IFS='|' read -r element dep; do
  [ -n "$dep" ] || continue
  if ! grep -qxF -- "$dep" <<<"$names"; then
    echo "release-preflight: $element depends on '$dep', absent from the index (not dependency-closed)" >&2
    unclosed=1
  fi
done < <(jq -r '.elements[] | .name as $n | .registry_dependencies[]? | "\($n)|\(.)"' "$index")
[ "$unclosed" -eq 0 ] || fail "the emitted set is not dependency-closed"

count=$(jq '.elements | length' "$index")
assets=$(find "$dist" -type f | wc -l | tr -d ' ')
echo "release-preflight: OK"
echo "  index:  $index ($count elements)"
echo "  assets: $assets files in $dist/"
