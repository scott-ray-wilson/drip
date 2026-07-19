import docs/ui/code_block
import docs/ui/installation
import docs/ui/preview
import docs/ui/prose.{type Anchor}
import docs/ui/syntax_highlight
import drip/registry.{type Element as RegistryElement}
import gleam/list
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon
import ui/kbd
import ui/table
import ui/typography

// --- Content -----------------------------------------------------------------

pub type Block(message) {
  Heading(Anchor)
  Subheading(Anchor)
  Paragraph(List(Inline))
  BulletList(List(List(Inline)))
  Table(headers: List(String), rows: List(Row))
  Example(code: String, body: List(Element(message)))
  SectionExample(
    anchor: Anchor,
    description: List(Inline),
    code: String,
    body: List(Element(message)),
  )
  /// A single named file shown as a code block: the tabbed file widget in the
  /// page and a fenced snippet in Markdown, both recovered from the same
  /// prerendered, syntax-highlighted HTML. The fence language comes from the
  /// file extension.
  CodeFile(name: String, code: String)
  /// A whole source file: rendered like `CodeFile` but collapsed behind an
  /// "Expand code" pill so a long file doesn't swallow the page. Fenced in
  /// full in Markdown.
  SourceFile(name: String, code: String)
  /// A shell-command block: plain-text source rendered under a filename header
  /// in the page and fenced verbatim in Markdown. The fence language comes
  /// from the extension (`sh` when there is none), and a `.toml` name swaps
  /// the shell coloring for TOML.
  Shell(name: String, source: String)
  /// An element's install section: the CLI/Manual install widget in the page,
  /// a concise CLI instruction in Markdown, both derived from the registry
  /// entry.
  Installation(element: RegistryElement)
  /// A boxed callout: the neutral accessibility alert. A bold title and a prose
  /// body, written once and rendered as an `alert` in the page and as a
  /// `**title.** body` paragraph in Markdown.
  Callout(title: String, body: List(Inline))
  /// Escape hatch: a block the model doesn't represent yet. Carries its live
  /// element for the page and a Markdown string for the copy/`.md` output. Pass
  /// `markdown: ""` to omit it from the Markdown entirely.
  Custom(view: Element(message), markdown: String)
  Group(List(Block(message)))
}

pub type Inline {
  Text(String)
  Strong(String)
  Signature(String)
  Selector(String)
  Flag(String)
  Code(String)
}

pub type Row =
  List(Cell)

pub type Cell {
  InlineCell(List(Inline))
  /// A prose cell pinned to one line: a multi-word value like "latest release"
  /// in a narrow column that would otherwise wrap. Plain text in Markdown.
  NoWrapCell(String)
  /// A keyboard-shortcut cell: key names rendered as `kbd` glyphs in the page
  /// and joined with `+` in Markdown.
  KeyCell(List(String))
}

// --- Cell Helpers ------------------------------------------------------------

pub fn signature_cell(source: String) -> Cell {
  InlineCell([Signature(source)])
}

pub fn selector_cell(source: String) -> Cell {
  InlineCell([Selector(source)])
}

pub fn flag_cell(source: String) -> Cell {
  InlineCell([Flag(source)])
}

pub fn text_cell(text: String) -> Cell {
  InlineCell([Text(text)])
}

pub fn nowrap_cell(text: String) -> Cell {
  NoWrapCell(text)
}

/// A keyboard-shortcut cell built from a single list of key names: rendered as
/// `kbd` glyphs in the page (a combo joined by `+` separators when there is more
/// than one key) and as `"A + B"` in Markdown.
pub fn key_cell(keys: List(String)) -> Cell {
  KeyCell(keys)
}

// --- Lustre ------------------------------------------------------------------

pub fn to_lustre(block: Block(message)) -> Element(message) {
  case block {
    Heading(anchor) -> prose.heading(anchor)
    Subheading(anchor) -> prose.subheading(anchor)
    Paragraph(inlines) -> prose.body(list.map(inlines, inline_to_lustre))
    BulletList(items) ->
      prose.bullet_list(
        list.map(items, fn(item) { list.map(item, inline_to_lustre) }),
      )
    Table(headers:, rows:) -> table_to_lustre(headers, rows)
    Example(code:, body:) -> preview.with_code(body:, code:)
    SectionExample(anchor:, description:, code:, body:) ->
      preview.section_with_code(
        anchor:,
        description: list.map(description, inline_to_lustre),
        body:,
        code:,
      )
    CodeFile(name:, code:) -> code_block.file([#(name, code)], expand: False)
    SourceFile(name:, code:) -> code_block.file([#(name, code)], expand: True)
    Shell(name:, source:) ->
      case string.ends_with(name, ".toml") {
        True -> code_block.toml(name, source)
        False -> code_block.shell(name, source)
      }
    Installation(element) -> installation.view(element)
    Callout(title:, body:) ->
      alert.root([alert.neutral()], [
        alert.icon([], [icon.person_standing([])]),
        alert.title([], [html.text(title)]),
        alert.description([], list.map(body, inline_to_lustre)),
      ])
    Custom(view:, ..) -> view
    Group(blocks) -> element.fragment(list.map(blocks, to_lustre))
  }
}

/// Render a run of inline content to Lustre elements. Exposed for bespoke
/// widgets that lay out their own container (the introduction page's FAQ
/// accordion, say) but still want `Text`, `Code`, and the rest rendered the
/// same way the model renders them inside a `Paragraph`.
pub fn inlines_to_lustre(inlines: List(Inline)) -> List(Element(message)) {
  list.map(inlines, inline_to_lustre)
}

fn inline_to_lustre(inline: Inline) -> Element(message) {
  case inline {
    Text(content) -> html.text(content)
    Strong(content) -> html.strong([], [html.text(content)])
    Signature(content) -> syntax_highlight.signature(content)
    Selector(content) -> syntax_highlight.selector(content)
    Flag(content) -> syntax_highlight.flag(content)
    Code(content) -> typography.code(code_wrap(content), [html.text(content)])
  }
}

// A single-token chip (a CSS variable, a path) moves to the next line whole
// instead of splitting at a hyphen; multi-word chips keep wrapping so long
// commands can still break across lines.
fn code_wrap(content: String) -> List(Attribute(message)) {
  case string.contains(content, " ") {
    True -> []
    False -> [attribute.class("whitespace-nowrap")]
  }
}

fn table_to_lustre(headers: List(String), rows: List(Row)) -> Element(message) {
  table.root([], [
    table.header([], [
      table.row(
        [],
        list.map(headers, fn(header) { table.head([], [html.text(header)]) }),
      ),
    ]),
    table.body([], list.map(rows, row_to_lustre)),
  ])
}

fn row_to_lustre(row: Row) -> Element(message) {
  table.row([], list.map(row, cell_to_lustre))
}

fn cell_to_lustre(cell: Cell) -> Element(message) {
  case cell {
    InlineCell(inlines) -> table.cell([], list.map(inlines, inline_to_lustre))
    NoWrapCell(text) ->
      table.cell([attribute.class("whitespace-nowrap")], [html.text(text)])
    KeyCell(keys) -> table.cell([], key_glyphs(keys))
  }
}

fn key_glyphs(keys: List(String)) -> List(Element(message)) {
  case keys {
    [key] -> [kbd.kbd([], [html.text(key)])]
    _ -> [
      kbd.combo(
        [],
        list.intersperse(
          list.map(keys, fn(key) { kbd.kbd([], [html.text(key)]) }),
          kbd.separator([], [html.text("+")]),
        ),
      ),
    ]
  }
}

// --- Markdown ----------------------------------------------------------------

pub fn to_markdown(block: Block(message)) -> String {
  case block {
    Heading(anchor) -> "## " <> anchor.label
    Subheading(anchor) -> "### " <> anchor.label
    Paragraph(inlines) -> inlines_to_markdown(inlines)
    BulletList(items) ->
      items
      |> list.map(fn(item) { "- " <> inlines_to_markdown(item) })
      |> string.join("\n")
    Table(headers:, rows:) -> table_to_markdown(headers, rows)
    Example(code:, ..) -> code_fence(code)
    SectionExample(anchor:, description:, code:, ..) ->
      "### "
      <> anchor.label
      <> "\n\n"
      <> inlines_to_markdown(description)
      <> "\n\n"
      <> code_fence(code)
    CodeFile(name:, code:) ->
      highlighted_fence(code, language: fence_language(name))
    SourceFile(name:, code:) ->
      highlighted_fence(code, language: fence_language(name))
    Shell(name:, source:) ->
      "```" <> fence_language(name) <> "\n" <> source <> "\n```"
    Installation(element) ->
      "## Installation\n\nInstall this element and its dependencies with the Drip CLI:\n\n```sh\ngleam run -m drip -- add "
      <> registry.to_string(element.name)
      <> "\n```"
    Callout(title:, body:) ->
      "**" <> title <> ".** " <> inlines_to_markdown(body)
    Custom(markdown:, ..) -> markdown
    Group(blocks) ->
      blocks
      |> list.map(to_markdown)
      |> list.filter(fn(s) { s != "" })
      |> string.join("\n\n")
  }
}

// Recover clean source from a prerendered, syntax-highlighted HTML snippet and
// wrap it in a fenced code block with the given language.
fn highlighted_fence(
  highlighted_html: String,
  language language: String,
) -> String {
  "```" <> language <> "\n" <> unescape(strip_tags(highlighted_html)) <> "\n```"
}

// "app.gleam" -> "gleam", "src/my_app.css" -> "css", "gleam.toml" -> "toml".
// Names with no extension (a `Shell` block titled "shell", say) fence as `sh`.
fn fence_language(name: String) -> String {
  case list.last(string.split(name, on: ".")) {
    Ok(extension) if extension != name && extension != "" -> extension
    _ -> "sh"
  }
}

fn inlines_to_markdown(inlines: List(Inline)) -> String {
  inlines
  |> list.map(inline_to_markdown)
  |> string.concat
}

fn inline_to_markdown(inline: Inline) -> String {
  case inline {
    Text(content) -> collapse_lines(content)
    Strong(content) -> "**" <> collapse_lines(content) <> "**"
    Signature(content) -> "`" <> collapse_lines(content) <> "`"
    Selector(content) -> "`" <> collapse_lines(content) <> "`"
    Flag(content) -> "`" <> collapse_lines(content) <> "`"
    Code(content) -> "`" <> collapse_lines(content) <> "`"
  }
}

/// Long prose strings are written across several source lines, indented to read
/// cleanly in the editor. Those soft breaks are a source-layout artifact, not
/// content, so collapse each line break and its trailing indentation back into
/// a single space. Leading and trailing spaces on the whole string are
/// preserved, so an inline that pads an edge to sit against a neighbor still
/// joins correctly.
fn collapse_lines(content: String) -> String {
  case string.split(content, on: "\n") {
    [only] -> only
    lines -> {
      let last = list.length(lines) - 1
      lines
      |> list.index_map(fn(line, i) {
        case i == 0, i == last {
          True, _ -> string.trim_end(line)
          _, True -> string.trim_start(line)
          _, _ -> string.trim(line)
        }
      })
      |> string.join(" ")
    }
  }
}

fn table_to_markdown(headers: List(String), rows: List(Row)) -> String {
  let header_line =
    "| " <> string.join(list.map(headers, escape_pipes), " | ") <> " |"
  let rule =
    "| " <> string.join(list.map(headers, fn(_) { "---" }), " | ") <> " |"
  let body_lines = list.map(rows, row_to_markdown)
  [header_line, rule, ..body_lines]
  |> string.join("\n")
}

fn row_to_markdown(row: Row) -> String {
  "| " <> string.join(list.map(row, cell_to_markdown), " | ") <> " |"
}

fn cell_to_markdown(cell: Cell) -> String {
  case cell {
    InlineCell(inlines) -> escape_pipes(inlines_to_markdown(inlines))
    NoWrapCell(text) -> escape_pipes(collapse_lines(text))
    KeyCell(keys) -> escape_pipes(string.join(keys, " + "))
  }
}

// The `code` constants are prerendered, syntax-highlighted HTML. Strip the
// `<span>` wrappers and decode the entities to recover the original Gleam
// source, then fence it.
fn code_fence(highlighted_html: String) -> String {
  highlighted_fence(highlighted_html, language: "gleam")
}

// Tail recursive so a snippet with thousands of tags can't overflow the stack
// on the JavaScript target.
fn strip_tags(content: String) -> String {
  do_strip_tags(content, "")
}

fn do_strip_tags(s: String, acc: String) -> String {
  case string.split_once(s, "<") {
    Error(_) -> acc <> s
    Ok(#(before, rest)) ->
      case string.split_once(rest, ">") {
        Error(_) -> acc <> before <> rest
        Ok(#(_tag, after)) -> do_strip_tags(after, acc <> before)
      }
  }
}

// Mirrors `escape_html` in codegen's `internal/highlight` module, which
// escapes only `&`, `<`, and `>` today; if that set grows, this one must
// follow. The quote entities are decoded defensively.
fn unescape(s: String) -> String {
  s
  |> string.replace("&lt;", "<")
  |> string.replace("&gt;", ">")
  |> string.replace("&quot;", "\"")
  |> string.replace("&#39;", "'")
  // `&amp;` last so an already-decoded entity isn't re-expanded.
  |> string.replace("&amp;", "&")
}

// Selectors like [data-variant="primary|secondary|..."] carry literal pipes
// that would otherwise split a GFM table cell.
fn escape_pipes(s: String) -> String {
  string.replace(s, each: "|", with: "\\|")
}
