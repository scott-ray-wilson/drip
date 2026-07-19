# Contributing

Thanks for your interest in Drip. Contributions of all sizes are welcome: bug
reports, fixes, new elements, docs, and examples. Drip is a Gleam monorepo
([`README`](README.md) maps the packages), and participation is governed by our
[Code of Conduct](CODE_OF_CONDUCT.md).

## Before you start

For anything beyond a small fix or typo, please open an issue first to discuss
the change. This avoids duplicated effort and gives a chance to agree on the
shape of the API before code is written.

For security vulnerabilities, do **not** open a public issue. See
[`SECURITY.md`](SECURITY.md).

## Development

**Prerequisites.** The baseline suite (tests, CLI, elements) needs **Gleam**,
**Erlang/OTP**, and **`rebar3`**; CI pins Gleam `1.17.0`, OTP `27`, and rebar3
`3`. rebar3 is required, or the `cli` suite's mock HTTP server fails to build.
Working on the docs site additionally needs **Node** `22`+ (not CI-pinned) and
[`bun`](https://bun.sh) for Markdown generation; the live dev server also needs
[`watchexec`](https://github.com/watchexec/watchexec)
(`brew install watchexec bun`).

Point Git at the shared hooks, then use the scripts to work across the whole
monorepo:

```sh
git config core.hooksPath .githooks   # enable the commit-message hook
scripts/test.sh                       # codegen, then every package's suite
scripts/format.sh                     # gleam format across all packages
scripts/dev.sh                        # docs site with element + docs watchers
```

To run one package's tests on its own:

```sh
cd cli && gleam test          # the CLI
cd registry && gleam test && gleam test --target javascript   # ships to Erlang and JS
cd ui && gleam test           # the component library
cd codegen && gleam test      # the docs snippet generator
```

The `docs` suite needs two things `scripts/test.sh` handles for you. `docs`
imports generated, gitignored modules, so run `cd codegen && gleam run` first on
a fresh checkout; and the suite renders through an FFI that touches browser
globals, so preload the DOM stub:

```sh
cd docs && NODE_OPTIONS='--import ./test/dom_shim.mjs' gleam test
```

CI runs each package's tests and `gleam format --check src test`. Both must pass
before a PR can merge, so format locally before pushing.

## Adding an element

The registry is the single source of truth for what elements exist. Adding one
is two edits in
[`registry/src/drip/registry.gleam`](registry/src/drip/registry.gleam): define
its `Element` constant, then add it to `all`. Run `cd registry && gleam test`
afterward; a test enforces the invariants the CLI relies on.

Two things live outside that file:

- The element's sources (`<name>.gleam`, `<name>.css`, and `<name>.ffi.mjs` when
  `ffi` is `True`) go in `ui/src/ui/`.
- Each shipped element has a hand-authored docs page under
  `docs/src/docs/page/<name>/`; copy an existing one as a template.

An element not ready to ship simply has no registry entry: its sources can live
in `ui/src/ui/` and build in-repo without appearing in the published index, the
docs, or `drip add`. Add its `Element` constant and docs page when it is ready.

The CLI fetches the catalog at runtime, so your change reaches users through a
registry release (see [Releases](#releases)). To try it locally, run
`cd codegen && gleam run`, then point a test project at the build with
`[tools.drip].source`, e.g. `drip init --source=/path/to/drip/dist`.

## Pull requests

- Fork the repository, create a branch off `main` in your fork, and open the PR
  against `scott-ray-wilson/drip`'s `main`.
- Keep the change focused: one logical change per PR.
- Add or update tests for any behavior change. Changes to `registry` must pass
  on both targets (`gleam test` and `gleam test --target javascript`).
- Record the change in the matching changelog under its `## [Unreleased]`
  section, following the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
  format used by existing entries: `cli/CHANGELOG.md` for a change to the CLI
  (`cli/`), `registry/CHANGELOG.md` for a change to the element catalog (a new
  element or a CSS tweak).
- Format before pushing (`scripts/format.sh`); CI checks it.

## Commit messages

This project follows
[Conventional Commits](https://www.conventionalcommits.org/); the `commit-msg`
hook enforces the format. Types used here: `feat` (new functionality), `fix`
(bug fix), `docs`, `refactor`, `perf`, `test`, `style`, `chore`, `build`, `ci`,
and `revert`. Append `!` (e.g. `chore(deps)!:`) for a breaking change.

## Releases

Releases are cut by the maintainer, and Drip has two independent flows. A
**registry release** (tag `registry-v*`) ships the element catalog as a GitHub
Release the CLI fetches at runtime, cut on any catalog or element change. A
**CLI release** (tag `cli-v*`) publishes the `drip` Hex package, only when the
CLI's own code changes. See [`PUBLISHING.md`](PUBLISHING.md) for the full
process.

By contributing, you agree your contributions are licensed under the project's
[MIT license](LICENSE).
