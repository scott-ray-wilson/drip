# docs

The Drip documentation site, served at [drip.pink](https://drip.pink). A
[Lustre](https://lustre.build) single-page app that reads the
[`registry`](../registry) catalog directly and renders the [`ui`](../ui)
elements it documents live on the page.

`docs` is an **internal package**: it is never published to Hex (see
[`PUBLISHING.md`](../PUBLISHING.md)); it exists only to build the site.

## What's here

One Lustre model-view-update app. `src/docs.gleam` owns the shell; every page
hangs off the current route.

| Path | What it is |
|------|-----------|
| `src/docs.gleam` | The MVU application: shell, navigation, search, theme. |
| `src/docs/route.gleam` | The `Route` type and URL parsing. `Element(name)` is one parametric variant covering every element page. |
| `src/docs/page.gleam` | Route to page dispatch, plus `markdown_files` for the `.md` endpoints. |
| `src/docs/element_page.gleam` | Scaffolds an element's page from its registry `Element` and an ordered list of sections. |
| `src/docs/content.gleam` | A small content model rendered two ways: to the live page and to Markdown. |
| `src/docs/page/<name>/` | One folder per page: a `page.gleam`, its `section/` modules, and an `example/` folder of live demos. |
| `src/docs/ui/` | The site's own presentational helpers (prose, code blocks, previews, table of contents), distinct from the `ui` elements on display. |
| `src/docs/generated/` | Highlighted source and example snippets from [`codegen`](../codegen). Gitignored; the site won't compile without them. |
| `assets/` | Static files served at `/`: fonts, icons, the OG image, the `_redirects` rule, and the generated per-page `.md` files. |

The entry stylesheet is `src/docs.css` (it pulls in Tailwind and the `ui`
theme); `src/docs.ffi.mjs` carries the browser bits the app needs: theme
persistence, search wiring, and fragment scrolling.

## Registry-derived routing

Nothing is hard-coded per element. `route.Element(name)` is a single parametric
variant, and the sidebar, the ⌘K palette, and the `/elements` grid all map over
`registry.all`. Registering an element in [`registry`](../registry) gives it a
URL, a nav entry, and a search item for free.

Registry names are snake_case (`button_group`); URLs hyphenate them
(`/elements/button-group`), matching prose routes like `/getting-started`.

## The content model

Each section builds a `content.Block` tree once and renders it two ways:

- `to_lustre` produces the page you see.
- `to_markdown` produces the same content as GitHub-flavored Markdown.

That second rendering feeds the "Copy Page" button and a `.md` endpoint for
every page (`/introduction.md`, `/elements/button.md`, and so on):
`scripts/generate_md.mjs` walks `page.markdown_files()` and writes them into
`assets/`. A block the vocabulary can't yet express drops in through `Custom`,
which carries its live element and a Markdown string side by side.

## Adding an element's page

1. Register the element in [`registry`](../registry): that alone earns it a
   route, a sidebar entry, and a search item.
2. Add a clause for its name to the `element_page` and `markdown` dispatches in
   `src/docs/page.gleam`.
3. Create `src/docs/page/<name>/`: a `page.gleam` that assembles the `Page` from
   `registry.<name>` and its sections, plus the `section/` and `example/`
   modules those sections render.
4. Run [`codegen`](../codegen) so the element's snippets land under
   `src/docs/generated/`.

## Develop and build

Two gitignored inputs must exist before the SPA compiles: the
`src/docs/generated/` snippets from [`codegen`](../codegen), and the per-page
`assets/*.md`. `scripts/dev.sh` and `scripts/build.sh` build both in order, so
prefer them over the raw tools:

```sh
scripts/dev.sh     # codegen + Markdown + dev server, with watchers
scripts/build.sh   # full production build into docs/dist
```

With those inputs present, the underlying `docs/` commands are:

```sh
gleam run -m lustre/dev start   # serve with live reload
gleam run -m lustre/dev build   # compile the SPA into dist/, copying assets/ in
gleam test                      # run the tests
```

The built `dist/` deploys to Cloudflare Pages; `assets/_redirects` gives the
single-page-app fallback so client-side routes like `/elements/button` resolve
to `index.html`.

## Configuration

The static HTML head (title, meta, Open Graph and Twitter tags, font preloads,
favicons, and the pre-paint theme script) lives in `[tools.lustre.html]` in
`gleam.toml`; `lustre/dev build` inlines it into `index.html`. The Open Graph
image is `assets/og-image.png`, exported from `assets/og-image.svg`.

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for the full workflow. [MIT](LICENSE).
