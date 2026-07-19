#!/usr/bin/env bash

# Format every package in place with `gleam format`. Run before pushing: CI
# runs `gleam format --check src test` per package (.github/workflows/test.yml)
# and rejects anything unformatted.
#
# playground/ is omitted on purpose: it is a gitignored local scratch project,
# not a shipped package.

set -euo pipefail
cd "$(dirname "$0")/.."

for pkg in ui registry cli codegen docs; do
  echo "==> gleam format ($pkg)"
  ( cd "$pkg" && gleam format )
done

echo "==> done"
