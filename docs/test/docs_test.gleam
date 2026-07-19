//// These render pages via `docs/page`, so they need the DOM preload (see
//// `test/dom_shim.mjs`): run `scripts/test.sh`, or `gleam test` with
//// `NODE_OPTIONS='--import ./test/dom_shim.mjs'`. A bare `gleam test` crashes.

import docs/content
import docs/generated/example/accordion
import docs/page
import docs/route.{type Route}
import docs/ui/code_block
import drip/registry
import gleam/list
import gleam/string
import gleam/uri
import gleeunit
import lustre/element

pub fn main() -> Nil {
  gleeunit.main()
}

fn occurrences(haystack: String, needle: String) -> Int {
  list.length(string.split(haystack, needle)) - 1
}

// The tab strip's FFI pairs tabs with panels through a shared `data-tab`
// index, and the panels carry tabpanel semantics with the filename as their
// accessible name. Drift here breaks tab switching silently, so pin the
// rendered contract.
pub fn code_block_tabs_pair_with_panels_by_index_test() {
  let html =
    element.to_string(code_block.file(
      [#("app.gleam", "<span>a</span>"), #("app.css", "<span>b</span>")],
      expand: False,
    ))
  assert string.contains(html, "role=\"tablist\"")
  assert occurrences(html, "role=\"tab\"") == 2
  assert occurrences(html, "role=\"tabpanel\"") == 2
  assert occurrences(html, "data-tab=\"0\"") == 2
  assert occurrences(html, "data-tab=\"1\"") == 2
  assert string.contains(html, "aria-label=\"app.gleam\"")
  assert string.contains(html, "aria-label=\"app.css\"")
  // roving tabindex: the active tab plus both panels are focusable, the
  // inactive tab is reachable through the FFI's arrow-key handler, which
  // finds tabs by their slot
  assert occurrences(html, "tabindex=\"0\"") == 3
  assert occurrences(html, "tabindex=\"-1\"") == 1
  assert occurrences(html, "data-slot=\"code-block-tab\"") == 2
  // only the non-first panel starts hidden and inert (lustre renders the
  // empty-valued attributes bare, sorted between the panel's other attributes)
  assert occurrences(html, "hidden inert role=\"tabpanel\"") == 1
  // the overlay copy button announces itself
  assert string.contains(html, "aria-label=\"Copy code\"")
}

// A single entry renders shell's static filename bar rather than a one-tab
// tablist, while keeping the collapse affordances of `expand: True`.
pub fn code_block_single_file_renders_static_bar_test() {
  let html =
    element.to_string(code_block.file([#("app.gleam", "x")], expand: True))
  assert !string.contains(html, "role=\"tab")
  assert string.contains(html, "data-slot=\"code-block-filename\"")
  assert string.contains(html, "data-expanded=\"false\"")
  assert string.contains(html, "data-slot=\"expand-toggle\"")
  assert string.contains(html, "data-slot=\"collapse-toggle\"")
}

// Prose strings are written across several indented source lines for
// readability; their Markdown should collapse back to a single flowing line.
pub fn markdown_collapses_soft_wrapped_prose_test() {
  let block =
    content.Callout(title: "Native semantics, screen reader ready", body: [
      content.Text(
        "Field roots carry role=\"group\" so the label, control, and helper text
        announce as one unit, and field error carries role=\"alert\" so validation
        is announced the moment it appears.",
      ),
    ])
  let md = content.to_markdown(block)
  assert md
    == "**Native semantics, screen reader ready.** Field roots carry role=\"group\" so the label, control, and helper text announce as one unit, and field error carries role=\"alert\" so validation is announced the moment it appears."
}

// `CodeFile` Markdown recovers source from prerendered HTML by stripping the
// highlighter's spans and decoding its entities. The fixture mirrors codegen's
// `escape_html` (`&` first, then `<` and `>`), so drift on either side shows
// up as residue or double-decoding here.
pub fn code_file_markdown_recovers_source_test() {
  let highlighted =
    "<span class=\"text-syntax-keyword\">pub fn</span> go() { a &lt;&gt; b &amp;&amp; c }"
  assert content.to_markdown(content.CodeFile("app.gleam", highlighted))
    == "```gleam\npub fn go() { a <> b && c }\n```"
}

// Source that itself contains entity text must survive one decode exactly:
// a literal `&lt;` arrives highlighted as `&amp;lt;` and must come back as
// `&lt;`, not `<`.
pub fn code_file_markdown_does_not_double_decode_test() {
  assert content.to_markdown(content.CodeFile("app.gleam", "\"&amp;lt;\""))
    == "```gleam\n\"&lt;\"\n```"
}

// Pin the decode set against real codegen output: any tag or entity residue
// means `unescape` has drifted from codegen's `escape_html`.
pub fn code_file_markdown_leaves_no_residue_test() {
  let md =
    content.to_markdown(content.CodeFile(
      "app.gleam",
      accordion.introduction_html,
    ))
  assert string.starts_with(md, "```gleam\n")
  assert string.ends_with(md, "\n```")
  assert !string.contains(md, "<span")
  assert !string.contains(md, "&amp;")
  assert !string.contains(md, "&lt;")
  assert !string.contains(md, "&gt;")
}

// A snippet with thousands of tags must not overflow the stack on the
// JavaScript target.
pub fn strip_tags_handles_long_snippets_test() {
  let highlighted =
    "<span class=\"x\">a</span>"
    |> list.repeat(50_000)
    |> string.concat
  assert content.to_markdown(content.CodeFile("app.gleam", highlighted))
    == "```gleam\n" <> string.repeat("a", 50_000) <> "\n```"
}

// The fence language comes from the file extension, falling back to `sh` for
// names without one (a `Shell` block titled "shell", say).
pub fn code_file_fences_by_extension_test() {
  assert content.to_markdown(content.CodeFile("src/my_app.css", "a { b: c }"))
    == "```css\na { b: c }\n```"
}

// `Shell` source is plain text, not highlighted HTML: it must be fenced
// verbatim, with no tag stripping or entity decoding.
pub fn shell_markdown_is_verbatim_test() {
  assert content.to_markdown(content.Shell("shell", "echo \"<b> &amp;\""))
    == "```sh\necho \"<b> &amp;\"\n```"
  assert content.to_markdown(content.Shell(
      "gleam.toml",
      "[tools.drip]\nprefix = \"ui\"",
    ))
    == "```toml\n[tools.drip]\nprefix = \"ui\"\n```"
}

// A `.toml`-named `Shell` block colors as TOML rather than shell: bare words
// are keys wherever they sit, `=` the operator, strings literals, and the
// header's brackets and dots punctuation.
pub fn shell_toml_blocks_highlight_as_toml_test() {
  let html =
    element.to_string(
      content.to_lustre(content.Shell(
        "gleam.toml",
        "[tools.drip]\nprefix = \"ui\"",
      )),
    )
  assert string.contains(
    html,
    "<span class=\"text-syntax-punctuation\">[</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-function\">tools</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-function\">drip</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-function\">prefix</span>",
  )
  assert string.contains(html, "<span class=\"text-syntax-operator\">=</span>")
  assert occurrences(html, "text-syntax-literal") == 1
}

// Inline signatures tokenize through contour with the build-time class
// mapping: module as type, function name, delimiters punctuation, and
// argument names plain (white via the wrapper's text-foreground).
pub fn signature_highlights_call_test() {
  let html =
    element.to_string(
      element.fragment(
        content.inlines_to_lustre([
          content.Signature("alert.title(attrs, children)"),
        ]),
      ),
    )
  assert string.contains(html, "<span class=\"text-syntax-type\">alert</span>")
  assert string.contains(
    html,
    "<span class=\"text-syntax-function\">title</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-punctuation\">.</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-punctuation\">(</span>",
  )
  assert string.contains(html, ">attrs<")
  assert string.contains(
    html,
    "<span class=\"text-syntax-punctuation\">,</span> children",
  )
}

// Inline selectors tokenize through swatch: attribute names keyword, values
// literal, combinators operators, and pseudo-classes uncolored. Every token
// pins itself unbroken so narrow-screen wraps land on the selector's spaces.
pub fn selector_highlights_groups_test() {
  let html =
    element.to_string(
      element.fragment(
        content.inlines_to_lustre([
          content.Selector("[data-slot=\"checkbox\"] > input:checked"),
        ]),
      ),
    )
  assert string.contains(
    html,
    "<span class=\"text-syntax-keyword whitespace-nowrap\">data-slot</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-literal whitespace-nowrap\">&quot;checkbox&quot;</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-operator whitespace-nowrap\">&gt;</span>",
  )
  assert string.contains(
    html,
    "<span class=\"text-syntax-function whitespace-nowrap\">input</span>",
  )
  assert string.contains(html, ">:checked<")
}

// A lone CLI flag colors like a flag in a shell snippet, not a signature.
pub fn flag_highlights_as_shell_flag_test() {
  let html =
    element.to_string(
      element.fragment(content.inlines_to_lustre([content.Flag("--force")])),
    )
  assert string.contains(
    html,
    "<span class=\"text-syntax-keyword\">--force</span>",
  )
}

// The install section derives its Markdown from the registry entry alone.
pub fn installation_markdown_test() {
  assert content.to_markdown(content.Installation(registry.button_group))
    == "## Installation\n\nInstall this element and its dependencies with the Drip CLI:\n\n```sh\ngleam run -m drip -- add button_group\n```"
}

// Header cells must escape literal pipes just like body cells, or a header
// like `primary|secondary` splits the GFM table at the wrong column.
pub fn markdown_table_escapes_header_pipes_test() {
  let md =
    content.to_markdown(
      content.Table(headers: ["Selector", "primary|secondary"], rows: [
        [content.text_cell("a|b"), content.text_cell("c")],
      ]),
    )
  assert md
    == "| Selector | primary\\|secondary |\n| --- | --- |\n| a\\|b | c |"
}

// --- Routing -----------------------------------------------------------------

// Every route, including one per registry element. `NotFound` round-trips too:
// its `/404` path parses straight back to `NotFound`.
fn all_routes() -> List(Route) {
  list.append(
    [
      route.Introduction,
      route.GettingStarted,
      route.Theming,
      route.Cli,
      route.Elements,
      route.NotFound,
    ],
    list.map(registry.all, fn(element) { route.Element(element.name) }),
  )
}

// `path` and `parse` are inverses: a link a page builds parses back to its
// route. The slug hop (`button_group` <-> `button-group`) is the easy break.
pub fn every_route_round_trips_through_its_path_test() {
  let broken =
    list.filter(all_routes(), fn(r) {
      case uri.parse(route.path(r)) {
        Ok(url) -> route.parse(url) != r
        Error(Nil) -> True
      }
    })
  assert list.map(broken, route.path) == []
}

// An unknown element slug is a 404, not a crash or a stray match.
pub fn unknown_element_slug_is_not_found_test() {
  let assert Ok(url) = uri.parse("/elements/does-not-exist")
  assert route.parse(url) == route.NotFound
}

// --- Page Coverage -----------------------------------------------------------

// Every registry element must resolve to a real page. The compiler forces a
// `page_for` arm for each element but not a *working* one, so an element wired
// to a placeholder would 404 or ship an empty page. Assert each has a page whose
// markdown opens with an `# H1` title.
pub fn every_element_has_a_page_test() {
  let broken =
    list.filter(registry.all, fn(entry) {
      let element_route = route.Element(entry.name)
      page.is_not_found(element_route)
      || case page.markdown(element_route) {
        Ok(md) -> !string.starts_with(md, "# ")
        Error(Nil) -> True
      }
    })
  assert list.map(broken, fn(entry) { registry.to_string(entry.name) }) == []
}

// `markdown_files` feeds `generate_md.mjs`, which writes one file per entry.
// Duplicate paths would clobber on write; an empty body is a dropped page.
pub fn markdown_files_are_unique_nonempty_md_paths_test() {
  let files = page.markdown_files()
  let paths = list.map(files, fn(file) { file.0 })

  assert list.all(paths, string.ends_with(_, ".md"))
  assert list.length(list.unique(paths)) == list.length(paths)
  assert list.all(files, fn(file) { file.1 != "" })
  // Spot-check both page kinds survive.
  assert list.contains(paths, "introduction.md")
  assert list.contains(paths, "elements/button.md")
}

// --- Table of Contents Integrity ---------------------------------------------

// The routes that carry an on-this-page nav: the prose pages plus every element
// page.
fn toc_routes() -> List(Route) {
  list.append(
    [route.Introduction, route.GettingStarted, route.Theming, route.Cli],
    element_routes(),
  )
}

fn element_routes() -> List(Route) {
  list.map(registry.all, fn(entry) { route.Element(entry.name) })
}

// Each TOC entry links to `#id`; each heading renders that id. The two lists are
// hand-maintained and share only the `Anchor` constants, so drift leaves a TOC
// link pointing at nothing (0 ids) or an ambiguous scroll-spy target (2+ ids).
// Exactly one is the contract.
pub fn every_toc_target_resolves_to_one_page_id_test() {
  let broken =
    list.flat_map(toc_routes(), fn(r) {
      let page_html = element.to_string(page.view(r))
      let toc_html = element.to_string(page.table_of_contents(r))
      list.filter_map(ids_after(toc_html, "href=\"#"), fn(id) {
        case occurrences(page_html, "id=\"" <> id <> "\"") {
          1 -> Error(Nil)
          n -> Ok(#(route.to_string(r), id, n))
        }
      })
    })
  assert broken == []
}

// The other direction: a heading on the page but missing from the TOC. Every
// heading wraps an anchor link (`data-anchor-link` + `href="#id"`), so its id
// must be a TOC target. Element pages only: prose pages carry in-body anchor
// links that aren't headings.
pub fn every_element_heading_has_a_toc_entry_test() {
  let broken =
    list.flat_map(element_routes(), fn(r) {
      let page_html = element.to_string(page.view(r))
      let toc_targets =
        element.to_string(page.table_of_contents(r))
        |> ids_after("href=\"#")
      page_html
      |> ids_after("data-anchor-link=\"true\" href=\"#")
      |> list.filter_map(fn(id) {
        case list.contains(toc_targets, id) {
          True -> Error(Nil)
          False -> Ok(#(route.to_string(r), id))
        }
      })
    })
  assert broken == []
}

// Collect the quoted value that follows each occurrence of `marker` in `html`:
// with `marker` ending at an opening quote, the value runs to the next quote.
fn ids_after(html: String, marker: String) -> List(String) {
  case string.split(html, marker) {
    [_before, ..chunks] ->
      list.filter_map(chunks, fn(chunk) {
        case string.split_once(chunk, "\"") {
          Ok(#(id, _rest)) -> Ok(id)
          Error(Nil) -> Error(Nil)
        }
      })
    _ -> []
  }
}
