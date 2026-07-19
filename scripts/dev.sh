#!/usr/bin/env bash
# Drip dev mode with file watchers.
#
# - Starts the docs dev server (`lustre/dev start` in docs/), which serves the
#   site, live-reloads on changes under docs/src, and runs Tailwind in --watch.
# - One watcher covers what lustre can't: on any source change it rebuilds the
#   stylesheet and reruns codegen (the docs/src/docs/generated/** snippets plus the
#   release dist/ at the repo root). Codegen's write is what triggers the reload.
# - On start it first stops any previous session for this repo, so re-running the
#   script can't leave a second server/watcher orphaned behind the port.
#
# Requires watchexec and bun (`brew install watchexec bun`).

set -e

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

if ! command -v watchexec >/dev/null 2>&1; then
  echo "watchexec is required: brew install watchexec" >&2
  exit 1
fi

# Resolve bun: prefer one on PATH, fall back to the copy lustre downloaded.
bun=$(command -v bun || find "$repo_root/docs/.lustre/bin" -name bun -type f 2>/dev/null | head -1)
if [ -z "$bun" ]; then
  echo "bun is required: brew install bun" >&2
  exit 1
fi

# A dev session already running collides with this one: the script backgrounds the
# server and watcher below, and a second `lustre/dev start` that can't bind the port
# just exits, orphaning its watchexec (so two watchers then run codegen on every
# save). Reap any prior session for this repo before starting a fresh one.
port=1234
echo "Stopping any existing Drip dev session..."
pkill -f "project-origin $repo_root" 2>/dev/null || true                   # our watchexec, scoped by --project-origin
kill $(lsof -ti tcp:$port -sTCP:LISTEN 2>/dev/null) 2>/dev/null || true     # the docs server; its bun/tailwind ports close with it
pkill -f "$repo_root.*bun-watcher.js" 2>/dev/null || true                  # any bun file watcher it orphaned

# Wait (a few seconds at most) for the port to free up so the new server can bind.
for _ in $(seq 1 20); do
  lsof -ti tcp:$port -sTCP:LISTEN >/dev/null 2>&1 || break
  sleep 0.25
done

# Initial codegen + Markdown so the dev server starts with everything fresh.
( cd codegen && gleam run )
( cd docs && gleam build ) && "$bun" "$repo_root/scripts/generate_md.mjs"

# Start the docs dev server (long-running). Its startup downloads (if needed) and
# runs Tailwind, so the binary the watcher below resolves is present by first edit.
( cd docs && gleam run -m lustre/dev start ) &
docs_pid=$!

# On any source change: rebuild the stylesheet, then rerun codegen. Two jobs lustre
# can't do itself, ordered so the edit yields a single reload:
#
#  - Codegen has no lustre hook. Its output (the highlighted-source snippets under
#    docs/src/docs/generated/**) is the only thing here the dev server watches, so
#    it's the sole reload trigger; it must stay --ignore'd or each run re-fires the
#    watcher.
#  - lustre runs Tailwind in --watch from docs/, and that watcher only tracks files
#    under its cwd. The theme/component CSS lives in the sibling ui/src (via
#    `@import "../../ui/src/ui.css"`), so edits there never rebuild the served
#    stylesheet. A one-shot build follows the @import chain fine; only -w is
#    cwd-scoped. So we rebuild it ourselves first, into build/ (unwatched, so no
#    reload); the codegen write that follows reloads once, with fresh CSS in place.
#
# The page Markdown (generate_md.mjs) is a build artifact, not part of the rendered
# site: generated once at startup and by scripts/build.sh, not per edit, since
# writing into docs/assets/ here would cost a second reload. So /elements/<slug>.md
# reflects the last generation during dev.
#
watchexec \
  --watch codegen/src \
  --watch ui/src \
  --watch registry/src \
  --watch docs/src \
  --exts gleam,css,mjs \
  --ignore '**/generated/**' \
  --restart \
  --postpone \
  --debounce 200ms \
  --project-origin "$repo_root" \
  -- "cd '$repo_root/docs' && \$(find .lustre/bin -name 'tailwindcss*' -type f | head -1) -i ./src/docs.css -o ./build/dev/javascript/docs.css; cd '$repo_root/codegen' && gleam run" &
codegen_pid=$!

trap 'kill $docs_pid $codegen_pid 2>/dev/null; wait 2>/dev/null' INT TERM EXIT
wait
