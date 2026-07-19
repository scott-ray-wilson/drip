# Publishing

drip has **two independent publish flows**:

| Flow | Ships | When | GitHub Release? |
| --- | --- | --- | --- |
| **Registry release** | `dist/*` (`registry.json` + every element file + `theme.css`) as Release assets | any catalog or element change | **yes** (only this flow) |
| **CLI release** | the `drip` Hex package (`cli/`) | only when the CLI's own code changes | **no** (Hex only) |

A new element, a CSS tweak, a new dependency is a **registry release**: edit the
catalog (`registry/src/drip/registry.gleam`), tag, and the published CLI picks it
up on the next `drip add` with no Hex publish. Publish the CLI to Hex only when
its own behavior changes.

## The latest-release model

The CLI fetches every asset from one repo-wide URL:

```
https://github.com/scott-ray-wilson/drip/releases/latest/download/<asset>
```

`/latest/` resolves to the most recent **non-prerelease** Release across the whole
repo, with no tag lookup and no fallback. The model holds only if the latest
Release always carries the full `dist/*` set, so **only registry releases cut
Releases**. Keep the tag namespaces disjoint:

- `registry-v*`: registry release, **with** `dist/*`, cut by CI.
- `cli-v*`: CLI version tag, publishes to Hex, **no** Release.

## Schema versioning

`registry.json` carries a `schema_version` (stamped by `codegen`);
the CLI pins `supported_schema_version` and refuses any registry
advertising a newer one, telling the user to update `drip`. This couples the
otherwise-independent flows: a registry release that raises `schema_version`
breaks every already-installed CLI until users update. So don't bump it for a
routine release. Change it only when `registry.json`'s format changes
incompatibly, and ship a CLI carrying the matching `supported_schema_version`
first. Ordinary registry releases (new element, CSS tweak) never touch it.

## CLI versioning

The CLI's version lives only in `version` in `cli/gleam.toml`; bumping that field
is the whole version change. The `cli-vX.Y.Z` tag must match it: the publish
workflow asserts tag == `cli/gleam.toml` and refuses a mismatch.

## Publish a registry release

Cutting a `registry-v*` tag runs `.github/workflows/registry-release.yml`: it runs
`scripts/release-preflight.sh` (regenerates `dist/` via `codegen`, then validates
it) and uploads `dist/*` to a Release marked latest.

Before tagging, move the `[Unreleased]` entries in `registry/CHANGELOG.md` under a
new `[X.Y.Z]` heading, point its link references at the `registry-vX.Y.Z` tag, and
commit to `main`. Then:

```sh
git switch main                       # ui/ + registry/ hold what you want to ship
git tag registry-vX.Y.Z
git push origin registry-vX.Y.Z
```

Validate locally before tagging (needs `jq` on PATH):

```sh
bash scripts/release-preflight.sh     # registry.json parses, every file exists, set is dependency-closed
```

## Publish the CLI to Hex

Only when the CLI's own code changes. Pushing a `cli-v*` tag runs
`.github/workflows/cli-release.yml`: it asserts the tag matches `cli/gleam.toml`,
runs the CLI tests, and publishes to Hex. No Release (it runs with
`contents: read`).

1. Bump `version` in `cli/gleam.toml`, move the `[Unreleased]` entries in
   `cli/CHANGELOG.md` under a new `[X.Y.Z]` heading, and point its link
   references at the `cli-vX.Y.Z` tag (the tag this scheme cuts, not a bare
   `vX.Y.Z`). Commit both to `main`.
2. Tag and push (`X.Y.Z` must equal that `version`):

   ```sh
   git tag cli-vX.Y.Z
   git push origin cli-vX.Y.Z
   ```

A Hex version is immutable, so if the run fails nothing shipped: delete the tag,
fix, re-tag the same version. Never attach a GitHub Release to a `cli-*` tag (it
would become `/latest/` and 404 every `drip add`/`init`).

## Smoke test

In a throwaway directory outside the repo, drive the real commands against the
published package and the live `/latest/` Release. This is the one path in-repo
tests can't cover (they point `[tools.drip].source` at a local fixture), so it
also catches a non-public repo or a Release missing `dist/*`.

```sh
mkdir /tmp/drip-smoke && cd /tmp/drip-smoke
gleam new app && cd app
gleam add drip --dev
gleam run -m drip -- init
gleam run -m drip -- add button
gleam run -m drip -- list
```

Optionally `gleam add lustre && gleam build` to confirm the vendored element
compiles.
