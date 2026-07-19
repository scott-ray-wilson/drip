# codegen

Build-time tool that turns the [`registry`](../registry) catalog and [`ui`](../ui) element sources into:

- the syntax-highlighted code snippets the [docs site](https://drip.pink) renders, and
- the release `dist/` the `drip` CLI fetches when it vendors an element.

## Usage

```sh
gleam run    # generate docs snippets + rebuild dist/
gleam test   # characterization tests
```

`gleam run` writes generated modules into `../docs/src/docs/generated/` (gitignored) and rebuilds `../dist/` from scratch. The `docs` site won't compile until those modules exist, so codegen runs in CI on every build and in `scripts/dev.sh` on every local change.

## Output

Both trees are gitignored.

| Output | What it is |
|--------|-----------|
| `generated/installation/<name>.gleam` | Per element: its source, CSS, and any FFI, rendered to highlighted HTML. |
| `generated/installation.gleam` | `tabs_for(name)` lookup from element name to its snippets, keyed by filename. |
| `generated/example/<page>.gleam` | Per docs page: the `.gleam` and `.css` files in that page's `example/`. |
| `dist/registry.json` + element files | The flat release set the CLI fetches: the index plus every listed element's files and `theme.css`, by name. |

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for the full workflow. [MIT](LICENSE).
