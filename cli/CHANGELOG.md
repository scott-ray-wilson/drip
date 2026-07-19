# Changelog

All notable changes to the `drip` CLI are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the CLI follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This changelog covers the `drip` CLI, the one Hex package the repository
publishes (in `cli/`). The element catalog (`registry/`) ships separately as a
GitHub Release the CLI fetches at runtime; its changes are tracked in
[`registry/CHANGELOG.md`](https://github.com/scott-ray-wilson/drip/blob/main/registry/CHANGELOG.md).

## [Unreleased]

## [1.0.0] - 2026-07-19

Initial public release of the `drip` CLI.

### Added

- `drip init`: scaffold `theme.css` and the generated `index.css`, and wire the
  Tailwind import into your entry stylesheet. `--prefix` sets the vendor
  directory and `--source` the registry, each recorded in `gleam.toml`'s
  `[tools.drip]` table for later commands; `--force` overwrites existing files.
- `drip add <element>...`: vendor elements and their transitive dependencies,
  fetching every file before writing any so a failed fetch leaves the project
  untouched. Any FFI `init()` wiring and extra package dependencies are surfaced
  as callouts rather than edited into your source or `gleam.toml`. `--force`
  re-vendors to take updates.
- `drip list`: show installed versus available elements, read from the registry
  index alone (no file downloads).
- `drip remove <element>...`: delete the named elements' files. Removal never
  cascades, so a dependency shared by another element is left in place.
- Registry fetch from the latest GitHub Release (a
  content-free `registry.json` index plus the element files), or from a local
  `dist/` directory or alternate `http(s)://` base via `--source`, for offline
  work and mirrors. A registry advertising a newer `schema_version` than the CLI
  supports is refused, with a prompt to update `drip`.
- Path-traversal validation for element names and the import prefix, so neither
  an argument nor a hand-edited `[tools.drip]` prefix can reach outside the
  project.

[Unreleased]: https://github.com/scott-ray-wilson/drip/compare/cli-v1.0.0...HEAD
[1.0.0]: https://github.com/scott-ray-wilson/drip/tree/cli-v1.0.0
