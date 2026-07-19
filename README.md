# drip

[![Package Version](https://img.shields.io/hexpm/v/drip)](https://hex.pm/packages/drip)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/drip/)
[![Test](https://github.com/scott-ray-wilson/drip/actions/workflows/test.yml/badge.svg)](https://github.com/scott-ray-wilson/drip/actions/workflows/test.yml)
[![License](https://img.shields.io/hexpm/l/drip)](https://github.com/scott-ray-wilson/drip/blob/main/LICENSE)

Vendor Lustre UI elements (Gleam, CSS, and sometimes a little browser FFI)
straight into your project and own them outright, the way
[shadcn/ui](https://ui.shadcn.com) does for React. There is no component library
to depend on: `drip add button` copies the element's source into your `src/ui/`,
wires its styles in, and gets out of the way.

> **Status: the CLI is v1; the elements and theme are pre-1.0.** The commands and
> config are settled. The element catalog is still being filled out and
> hardened, and the default theme is not final (token names may still change
> before 1.0). Because elements are vendored as source, nothing you have already
> added moves under you: you take changes deliberately by re-adding an element
> with `--force`.

## Quickstart

Drip assumes a Gleam + Lustre project served by
[`lustre_dev_tools`](https://hexdocs.pm/lustre_dev_tools/), which supplies the
Tailwind CSS v4 build the elements are styled with. `init` wires the Tailwind
import into your entry stylesheet, so there is no separate Tailwind step to set
up.

```sh
gleam add drip --dev                  # add the CLI as a dev dependency
gleam run -m drip -- init             # scaffold the stylesheets
gleam run -m drip -- add button       # vendor an element (and its dependencies)
gleam run -m drip -- list             # installed vs available elements
```

New to Lustre or starting fresh? The
[getting-started guide](https://drip.pink/getting-started) walks through a new
project end to end. See [`cli/README.md`](cli/README.md) for full usage, custom
registry sources, and how taking updates works.

## Documentation

The element catalog, live examples, and API reference are at
<https://drip.pink>.

## Packages

This is a Gleam monorepo. `cli` is the only package published to Hex (as `drip`);
the rest are path dependencies within the repo.

- [`cli`](cli/): the `drip` CLI that vendors elements into a project
- [`registry`](registry/): the element catalog, the source of truth `codegen` and `docs` read from
- [`ui`](ui/): the component library whose elements are vendored into consumer projects
- [`docs`](docs/): the documentation site, deployed to <https://drip.pink>
- [`codegen`](codegen/): compiles `registry` + `ui` into the `dist/` release the CLI fetches at runtime (the `registry.json` index + element files), plus the docs snippets

The `dist/` release is the only GitHub Release this repo cuts, one per catalog or
element change; `cli` goes to Hex on its own cadence, when its code changes. See
[`PUBLISHING.md`](PUBLISHING.md); [`cli/CHANGELOG.md`](cli/CHANGELOG.md) and
[`registry/CHANGELOG.md`](registry/CHANGELOG.md) track the CLI and the catalog.

## Contributing

After cloning, point Git at the shared hooks directory so the commit-message
check runs locally:

```sh
git config core.hooksPath .githooks
```

Commits follow [Conventional Commits](https://www.conventionalcommits.org/). See
[`CONTRIBUTING.md`](CONTRIBUTING.md) for prerequisites, the development workflow,
and how to run the tests. Participation is governed by our [Code of
Conduct](CODE_OF_CONDUCT.md).

## Security

To report a vulnerability, see [`SECURITY.md`](SECURITY.md).

## License

[MIT](LICENSE). Icons are from [Lucide](https://lucide.dev) (ISC), including
icons it carries over from [Feather](https://github.com/feathericons/feather)
(MIT); see [`NOTICE`](NOTICE) for the full license texts.
