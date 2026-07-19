#!/usr/bin/env bash

# Run every package's test suite, mirroring CI (.github/workflows/test.yml).
#
# Like CI (fail-fast: false), it runs all suites even when one fails and then
# prints a summary, so a single broken package does not hide the rest. Exits
# non-zero if any suite failed.
#
# playground/ is omitted on purpose: it is a gitignored local scratch project.

set -uo pipefail
cd "$(dirname "$0")/.."

failures=()

# cd into a package and run `gleam <args>`, recording the label on failure.
test_pkg() {
  local pkg=$1; shift
  echo
  echo "==> gleam $* ($pkg)"
  ( cd "$pkg" && gleam "$@" ) || failures+=("$pkg: gleam $*")
}

# docs imports codegen's generated, gitignored modules, so they must exist
# before docs will compile. This also refreshes the release dist/ (gitignored).
echo "==> codegen (writes docs/src/docs/generated/**)"
( cd codegen && gleam run ) || failures+=("codegen: gleam run")

test_pkg ui test
# registry ships to both targets (erlang: cli/codegen, javascript: docs).
test_pkg registry test
test_pkg registry test --target javascript
test_pkg cli test
test_pkg codegen test
# docs renders pages via lustre_portal's FFI, which needs a DOM stub preloaded;
# see docs/test/dom_shim.mjs.
echo
echo "==> gleam test (docs)"
( cd docs && NODE_OPTIONS='--import ./test/dom_shim.mjs' gleam test ) \
  || failures+=("docs: gleam test")

echo
if [ ${#failures[@]} -eq 0 ]; then
  echo "==> all suites passed"
else
  echo "==> FAILED:"
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi
