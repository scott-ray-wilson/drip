#!/usr/bin/env bash

# Builds the docs site. Two file sets under docs/ must be generated first, in order:
#
#   1. docs/src/docs/generated/** - code samples + highlighted source, from codegen
#   2. docs/assets/<page>.md - per-page Markdown, one file per docs page (prose
#      pages at the root, elements under elements/), served at /<page>.md
#
# Step 2 imports the *compiled* docs module, so `gleam build` runs between them.

set -euo pipefail
cd "$(dirname "$0")/.."

if command -v bun >/dev/null 2>&1; then runner=bun; else runner=node; fi

echo "==> codegen (writes docs/src/docs/generated/**)"
(cd codegen && gleam run)

echo "==> compile docs"
(cd docs && gleam build)

echo "==> generate markdown (writes docs/assets/<page>.md)"
"$runner" scripts/generate_md.mjs

echo "==> build site (copies docs/assets into docs/dist)"
(cd docs && gleam run -m lustre/dev build)

echo "==> done: docs/dist"
