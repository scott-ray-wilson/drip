# drip

[![Package Version](https://img.shields.io/hexpm/v/drip)](https://hex.pm/packages/drip)
[![Downloads](https://img.shields.io/hexpm/dt/drip)](https://hex.pm/packages/drip)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/drip/)
[![Test](https://github.com/scott-ray-wilson/drip/actions/workflows/test.yml/badge.svg)](https://github.com/scott-ray-wilson/drip/actions/workflows/test.yml)
[![License](https://img.shields.io/hexpm/l/drip)](https://github.com/scott-ray-wilson/drip/blob/main/cli/LICENSE)

A CLI that vendors Lustre UI elements (Gleam, CSS, and sometimes a little browser FFI) straight into your project. There is no component library to depend on: `drip add button` copies the element's source into your `src/ui/` directory, wires its styles in, and gets out of the way.

## Install

`drip` is a build-time tool, so add it as a dev dependency:

```sh
gleam add drip --dev
```

## Quick start

From the root of an existing Gleam + Lustre project:

```sh
gleam run -m drip -- init           # scaffold the stylesheets
gleam run -m drip -- list           # see which elements are available
gleam run -m drip -- add button     # vendor an element and its dependencies
gleam run -m drip -- remove button  # remove previously vendored elements
```

`init` writes the design tokens and wires them into your entry stylesheet; `add` copies elements into `src/ui/` and keeps the index in sync. Every command that writes files prints a diff of what it touched:

```
Vendored 1 element into src/ui.

  + created  src/ui/button.css
  + created  src/ui/button.gleam
  ~ modified src/ui/index.css
```

Further documentation, the element catalog, and live examples are available at <https://drip.pink>.

## Commands

| Command | What it does |
|---------|--------------|
| `init` | Scaffolds `theme.css`, the generated `index.css`, and wires up your entry stylesheet. |
| `list` | Lists the elements in the registry, marking which are already vendored. |
| `add <element>...` | Vendors one or more elements and their dependencies into `src/<prefix>/`. |
| `remove <element>...` | Deletes the named elements' files. |

Flags:

| Flag | Commands | Description |
|------|----------|-------------|
| `--prefix <dir>` | `init` | Directory under `src/` that elements vendor into, saved to `[tools.drip]` in your `gleam.toml` (default: `ui`). |
| `--source <url-or-path>` | `init` | Registry to vendor from, a URL or local path, saved to `[tools.drip]` in your `gleam.toml` (default: the latest GitHub release). |
| `--force` | `init`, `add` | Overwrite files that already exist on disk. |

Pass `--help` to any command (for example `gleam run -m drip -- add --help`) to see its usage.

## How it works

Elements land flat in `src/<prefix>/`, which defaults to `src/ui/`. You own every file that lands there.

- **`init`** fetches `theme.css` (your design tokens) from the source, generates `src/<prefix>/index.css` (it imports the theme plus every vendored element), and adds an `@import` for the index to your entry stylesheet. The index is regenerated on every `add` and `remove`.
- **`add`** vendors each element you name along with everything it depends on in turn, so `add field` also brings in `separator`.
- **`remove`** deletes only the elements you name. It does not cascade to dependencies, since another vendored element might still rely on them.
- Re-running `add` leaves files already on disk untouched unless you pass `--force`.

Two kinds of follow-up are printed as next steps rather than done for you: Hex packages an element needs (`gleam add ...`) and any browser FFI an element ships (`call <name>.init()` at app start).

Each row in the output is prefixed with what happened to the file:

| Glyph | Meaning |
|-------|---------|
| `+` | created |
| `~` | modified |
| `=` | unchanged or skipped |
| `-` | deleted |

## Configuration

`drip` reads its settings from a `[tools.drip]` table in your `gleam.toml`:

```toml
[tools.drip]
prefix = "ui"
source = "https://github.com/scott-ray-wilson/drip/releases/latest/download"
```

Both keys are optional, and the defaults above apply when they are absent. `init --prefix` and `init --source` write your choices here so later commands stay consistent. The prefix must be a valid Gleam module path (lowercase identifier segments such as `ui` or `lib/ui`), because vendored modules are imported through it.

## Custom registries

A source is everything `drip` reads from: a `registry.json` index alongside the element files and `theme.css` it references. The default source is the latest GitHub release, but `source` can point at any HTTP(S) URL or a local directory, which is handy for testing your own catalog. The index looks like this:

```json
{
  "schema_version": 1,
  "name": "drip",
  "homepage": "https://drip.pink",
  "elements": [
    {
      "name": "field",
      "description": "A layout that pairs a form control with its label, description, and message.",
      "category": "forms",
      "registry_dependencies": ["separator"],
      "dependencies": [],
      "files": ["field.css", "field.gleam"]
    }
  ]
}
```

`registry_dependencies` are other elements, resolved and vendored automatically; `dependencies` are Hex packages, surfaced as `gleam add` steps. Because elements vendor flat, `files` must be plain file names (no `/`, `\`, or `..`). If a registry advertises a `schema_version` newer than your installed `drip` supports, the CLI will ask you to update.

## Development

```sh
gleam test   # run the tests
gleam build  # compile the CLI
```

This package lives in the [drip](https://github.com/scott-ray-wilson/drip) monorepo. See [`CONTRIBUTING.md`](https://github.com/scott-ray-wilson/drip/blob/main/CONTRIBUTING.md) for prerequisites and the full workflow.

## License

[MIT](https://github.com/scott-ray-wilson/drip/blob/main/cli/LICENSE). Inspired by [shadcn/ui](https://ui.shadcn.com) and built for [Lustre](https://lustre.build).
