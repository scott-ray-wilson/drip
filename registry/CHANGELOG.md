# Changelog

All notable changes to the Drip element catalog are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This changelog covers the element catalog (`registry/`, compiled with `ui/` into
`dist/` by `codegen`). The catalog is not a Hex package: each release ships
`dist/*` as assets on a `registry-v*` GitHub Release the `drip` CLI fetches at
runtime, and any element or catalog change is a release (see
[`PUBLISHING.md`](../PUBLISHING.md)). The CLI's own changes are tracked in
[`cli/CHANGELOG.md`](../cli/CHANGELOG.md).

## [Unreleased]

## [0.1.0] - 2026-07-19

First public release of the element catalog. Pre-1.0: the set is still growing
and the default theme's token names may change before 1.0.

### Added

- 15 elements: `accordion`, `alert`, `button`, `button_group`, `card`,
  `checkbox`, `empty`, `field`, `radio_group`, `separator`, `spinner`, `switch`,
  `table`, `text_area`, `text_field`.
- `theme.css`: the design-token base theme `drip init` scaffolds.
- `registry.json`: the catalog index (per-element metadata and the dependency
  graph the CLI resolves for `drip add`), emitted by `codegen`.

[Unreleased]: https://github.com/scott-ray-wilson/drip/compare/registry-v0.1.0...HEAD
[0.1.0]: https://github.com/scott-ray-wilson/drip/tree/registry-v0.1.0
