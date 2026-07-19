// Writes docs/assets/<page>.md (e.g. assets/elements/button.md) from each docs
// page's `markdown()`. The dev server serves `assets/` at `/`, and
// `lustre/dev build` copies it into `dist/`, so the files reach production.
//
// Run with bun or node, after compiling docs (bun ships with lustre_dev_tools):
//
//   (cd docs && gleam build) && bun scripts/generate_md.mjs
//
// The `docs` package returns the Markdown as strings; this runner writes the files,
// so `docs` needs no filesystem dependency of its own.

import { mkdir, writeFile, readdir, rm } from "node:fs/promises";
import { dirname, join, sep } from "node:path";
import { fileURLToPath } from "node:url";

// The dynamic import of the compiled docs page module (below) runs lustre_portal's
// FFI, which touches browser globals at load time. Neither bun nor node has a browser,
// so stub them enough for the import to succeed; `markdown()` only builds strings, so they're unused.
globalThis.HTMLElement ??= class {};
globalThis.customElements ??= { define() {}, get() {} };

const docsDir = fileURLToPath(new URL("../docs", import.meta.url));
const page = new URL(
  "../docs/build/dev/javascript/docs/docs/page.mjs",
  import.meta.url,
).href;

const { markdown_files, sitemap } = await import(page);

// `markdown_files()` returns a Gleam List of `#(path, markdown)` tuples; Gleam
// compiles lists to a class with `.toArray()` and tuples to plain JS arrays.
const assetsDir = join(docsDir, "assets");
const written = new Set();
for (const [relativePath, markdown] of markdown_files().toArray()) {
  const path = join(assetsDir, relativePath);
  await mkdir(dirname(path), { recursive: true });
  await writeFile(path, markdown);
  written.add(relativePath);
  console.log("wrote assets/" + relativePath);
}

// Prune stale output. This generator only ever writes, so a renamed or hidden
// element leaves its old `.md` behind (e.g. input.md lingering after input
// became text-field), diverging local output from the registry. Every `.md`
// under assets/ is generator-owned, so delete any this run did not write.
for (const entry of await readdir(assetsDir, { recursive: true })) {
  if (!entry.endsWith(".md")) continue;
  const relativePath = entry.split(sep).join("/");
  if (written.has(relativePath)) continue;
  await rm(join(assetsDir, entry));
  console.log("pruned assets/" + relativePath);
}

// Sitemap: canonical URLs for search engines. Not a `.md`, so the prune pass
// above leaves it alone.
await writeFile(join(assetsDir, "sitemap.xml"), sitemap());
console.log("wrote assets/sitemap.xml");
