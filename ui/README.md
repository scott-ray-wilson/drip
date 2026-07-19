# ui

The source for Drip's UI elements: accessible, themeable
[Lustre](https://lustre.build) elements styled with Tailwind v4. Each element is
a Gleam module paired with a sibling stylesheet (`src/ui/<name>.gleam` +
`src/ui/<name>.css`), plus a `.ffi.mjs` for the few that need browser behavior.

`ui` is an **internal package**: it is never published to Hex (see
[`PUBLISHING.md`](../PUBLISHING.md)). Elements aren't a dependency you add; the
[`drip` CLI](../cli) **vendors** them into your project, copying an element's
files into `src/ui/` and rewriting the `ui/` import prefix to the one you chose.
This package is the source those copies come from and the
[docs site](https://drip.pink) renders.

## What's here

Each element is self-contained in `src/ui/`:

| File | Role |
|------|------|
| `<name>.gleam` | The element itself: its Lustre view functions and attributes. |
| `<name>.css` | Its styles, layered on the theme tokens and Tailwind. |
| `<name>.ffi.mjs` | Optional browser FFI, only where an element needs script (dialogs, menus, tabs). |

Alongside the elements sit a handful of shared modules:

| Module | What it is |
|--------|-----------|
| `theme.css` | The design tokens (`@theme` variables for surfaces, color, radii) every element builds on. The CLI's `init` fetches this. |
| `ui.css` | Aggregate stylesheet that pulls in Tailwind, the theme, and every element's CSS. The [`docs`](../docs) build imports it. |
| `icon.gleam` | Lucide icons consolidated into one module so `icon.<name>([..])` resolves the same way in an element and in a copied docs snippet. Never vendored: consumers regenerate `ui/icon` with `lucide_lustre`. |

## How an element reaches a project

These sources are the middle of a pipeline, not the thing consumers install:

1. [`registry`](../registry) lists which elements exist and how they depend on
   one another.
2. [`codegen`](../codegen) reads these sources and packages them into the
   release `dist/` the CLI fetches, plus the highlighted snippets the docs
   render.
3. The [`drip` CLI](../cli) vendors an element and its dependencies into a
   project, rewriting the import prefix as it copies.
4. [`docs`](../docs) takes `ui` as a path dependency and imports the modules
   directly to render live examples.

So an element's Gleam and CSS live here exactly once; everything downstream
reads from this package rather than duplicating it.

## Not everything here ships

An element only vendors and appears in the docs if it has an entry in
[`registry`](../registry). Modules that build in-repo without one are works in progress or docs-only helpers: they compile
alongside the rest but never reach `dist/`, `drip add`, or the catalog. Promoting one is a [`registry`](../registry) edit, not a change here.

## Development

```sh
gleam test   # render-contract tests
```

Each element's tests assert the DOM contract its CSS relies on: the `data-slot`
hooks, roles, and structure that must stay stable. The cross-element
slot-contract sweep and the emitted `dist/` are covered over in
[`codegen`](../codegen).

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for the full workflow. [MIT](LICENSE).
