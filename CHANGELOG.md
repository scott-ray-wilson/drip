# Changelog

drip releases the CLI and the element catalog independently, each with its own
changelog:

- **[`cli/CHANGELOG.md`](cli/CHANGELOG.md)**: the `drip` CLI, the Hex package
  published from `cli/` (tagged `cli-v*`).
- **[`registry/CHANGELOG.md`](registry/CHANGELOG.md)**: the element catalog,
  shipped as `dist/*` on a GitHub Release the CLI fetches at runtime (tagged
  `registry-v*`).

See [`PUBLISHING.md`](PUBLISHING.md) for how each is released.
