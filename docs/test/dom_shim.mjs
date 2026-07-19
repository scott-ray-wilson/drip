// Preloaded via `--import` before the test module graph (see scripts/test.sh and
// test.yml). Rendering a page pulls in lustre_portal, whose FFI defines
// `class Portal extends HTMLElement` at load time; node has no DOM, so stub just
// enough for the import to succeed. Mirrors the stub in scripts/generate_md.mjs.
globalThis.HTMLElement ??= class {};
globalThis.customElements ??= { define() {}, get() {} };
