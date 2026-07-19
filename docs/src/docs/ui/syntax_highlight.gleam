import contour.{type Token as GleamToken}
import gleam/list
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import swatch.{type Token as CssToken}

// Inline syntax-highlighting helpers for the docs site.

// --- Gleam Function Signature ------------------------------------------------

/// Syntax coloring for `<module>.<name>` and `<module>.<name>(<args>)`
/// identifiers in API tables and prose. contour marks a module qualifier only
/// on a call or pipe; a bare `module.name` reference renders plain, as the
/// build-time code blocks do.
pub fn signature(source: String) -> Element(message) {
  html.span(
    [wrapper_class(), attribute.class("whitespace-nowrap")],
    list.map(contour.to_tokens(source), gleam_token),
  )
}

fn gleam_token(token: GleamToken) -> Element(message) {
  case token {
    contour.Whitespace(content) -> html.text(content)
    contour.Keyword(content) -> span("text-syntax-keyword", content)
    contour.String(content) | contour.Number(content) ->
      span("text-syntax-literal", content)
    contour.Comment(content) -> span("text-syntax-comment italic", content)
    contour.Function(content) -> span("text-syntax-function", content)
    contour.Module(content) -> span("text-syntax-type", content)
    contour.Variant(content) -> span(variant_class(content), content)
    contour.Operator(content) -> span("text-syntax-operator", content)
    contour.Other(content) -> gleam_other(content)
  }
}

// contour has no boolean token; True/False arrive as ordinary variants.
fn variant_class(content: String) -> String {
  case content {
    "True" | "False" -> "text-syntax-boolean"
    _ -> "text-syntax-type"
  }
}

// contour lumps brackets, delimiters, and bare identifiers into `Other`.
fn gleam_other(content: String) -> Element(message) {
  case content {
    "(" | ")" | "[" | "]" | "{" | "}" | "." | ".." | "," -> punctuation(content)
    _ -> html.text(content)
  }
}

// --- CSS Selector ------------------------------------------------------------

/// Coloring for the CSS selectors in the API reference's Selectors table:
/// attribute groups, chains, and descendant selectors like
/// `[data-slot="checkbox"] > input:checked`.
pub fn selector(source: String) -> Element(message) {
  html.span(
    [wrapper_class(), attribute.class("md:whitespace-nowrap")],
    list.map(swatch.to_tokens(source), css_token),
  )
}

// Every token except whitespace pins itself unbroken, so a wrapping selector
// breaks only at its spaces, never inside a hyphenated name like aria-invalid.
fn css_token(token: CssToken) -> Element(message) {
  case token {
    swatch.Whitespace(content) -> html.text(content)
    swatch.PseudoSelector(content) -> span("whitespace-nowrap", content)
    swatch.Punctuation(content) | swatch.Other(content) ->
      span("text-syntax-punctuation whitespace-nowrap", content)
    swatch.Comment(content) ->
      span("text-syntax-comment italic whitespace-nowrap", content)
    swatch.AtRule(content)
    | swatch.Important(content)
    | swatch.AttributeName(content)
    | swatch.AttributeValue(content)
    | swatch.AttributeFlag(content)
    | swatch.Property(content)
    | swatch.Variable(content)
    | swatch.Keyword(content) ->
      span("text-syntax-keyword whitespace-nowrap", content)
    swatch.ClassSelector(content)
    | swatch.IdSelector(content)
    | swatch.Function(content)
    | swatch.Selector(content) ->
      span("text-syntax-function whitespace-nowrap", content)
    swatch.Operator(content) | swatch.Unit(content) ->
      span("text-syntax-operator whitespace-nowrap", content)
    swatch.String(content)
    | swatch.Number(content)
    | swatch.HexColor(content) ->
      span("text-syntax-literal whitespace-nowrap", content)
  }
}

// --- Shell -------------------------------------------------------------------

/// Render-time coloring for shell snippets.
pub fn shell(source: String) -> List(Element(message)) {
  source
  |> string.split("\n")
  |> list.map(shell_line)
  |> list.intersperse([html.text("\n")])
  |> list.flatten
}

/// Coloring for a lone CLI flag in an options table, matching how the shell
/// highlighter colors flags inside a snippet.
pub fn flag(source: String) -> Element(message) {
  html.span([wrapper_class(), attribute.class("whitespace-nowrap")], [
    shell_word(source, False),
  ])
}

fn shell_line(line: String) -> List(Element(message)) {
  let #(code, comment) = split_comment(line)
  let code_elements = shell_words(string.to_graphemes(code), True, [])
  case comment {
    "" -> code_elements
    _ ->
      list.append(code_elements, [span("text-syntax-comment italic", comment)])
  }
}

// Splits at the first `#` that begins a word; a mid-token `#` (`foo#bar`)
// stays code. Quoting isn't handled; these snippets don't use `#` in strings.
fn split_comment(line: String) -> #(String, String) {
  do_split_comment(string.to_graphemes(line), True, "")
}

fn do_split_comment(
  graphemes: List(String),
  at_boundary: Bool,
  acc: String,
) -> #(String, String) {
  case graphemes {
    [] -> #(acc, "")
    ["#", ..rest] ->
      case at_boundary {
        True -> #(acc, "#" <> string.concat(rest))
        False -> do_split_comment(rest, False, acc <> "#")
      }
    [grapheme, ..rest] ->
      do_split_comment(rest, is_shell_space(grapheme), acc <> grapheme)
  }
}

// Splits words on whitespace alone (quoting isn't handled; these snippets
// don't quote spaces). `first` survives whitespace runs so an indented
// command still colors as the command.
fn shell_words(
  graphemes: List(String),
  first: Bool,
  acc: List(Element(message)),
) -> List(Element(message)) {
  case graphemes {
    [] -> list.reverse(acc)
    [grapheme, ..] ->
      case is_shell_space(grapheme) {
        True -> {
          let #(space, rest) = list.split_while(graphemes, is_shell_space)
          shell_words(rest, first, [html.text(string.concat(space)), ..acc])
        }
        False -> {
          let #(word, rest) =
            list.split_while(graphemes, fn(c) { !is_shell_space(c) })
          let word = string.concat(word)
          shell_words(rest, False, [shell_word(word, first), ..acc])
        }
      }
  }
}

fn shell_word(word: String, first: Bool) -> Element(message) {
  case first, string.starts_with(word, "-") {
    True, _ -> span("text-syntax-function", word)
    False, True -> span("text-syntax-keyword", word)
    False, False -> html.text(word)
  }
}

fn is_shell_space(grapheme: String) -> Bool {
  grapheme == " " || grapheme == "\t"
}

// --- TOML --------------------------------------------------------------------

pub fn toml(source: String) -> List(Element(message)) {
  source
  |> string.split("\n")
  |> list.map(toml_line)
  |> list.intersperse([html.text("\n")])
  |> list.flatten
}

fn toml_line(line: String) -> List(Element(message)) {
  let #(code, comment) = split_comment(line)
  let code_elements = walk_toml(string.to_graphemes(code), [])
  case comment {
    "" -> code_elements
    _ ->
      list.append(code_elements, [span("text-syntax-comment italic", comment)])
  }
}

fn walk_toml(
  graphemes: List(String),
  acc: List(Element(message)),
) -> List(Element(message)) {
  case graphemes {
    [] -> list.reverse(acc)
    ["\"", ..rest] -> {
      let #(body, after) = take_until_quote(rest, "")
      walk_toml(after, [
        span("text-syntax-literal", "\"" <> body <> "\""),
        ..acc
      ])
    }
    ["=", ..rest] -> walk_toml(rest, [span("text-syntax-operator", "="), ..acc])
    [grapheme, ..rest] ->
      case is_toml_punctuation(grapheme), is_toml_word(grapheme) {
        True, _ -> walk_toml(rest, [punctuation(grapheme), ..acc])
        _, True -> {
          let #(word, after) = list.split_while(graphemes, is_toml_word)
          walk_toml(after, [toml_word(string.concat(word)), ..acc])
        }
        _, _ -> {
          let #(plain, after) = list.split_while(graphemes, is_toml_plain)
          walk_toml(after, [html.text(string.concat(plain)), ..acc])
        }
      }
  }
}

// The bare values TOML spells without quotes (booleans, numbers) color as
// literals; every other bare word is a key.
fn toml_word(word: String) -> Element(message) {
  let literal = case word, string.first(word) {
    "true", _ | "false", _ -> True
    _, Ok(grapheme) -> is_digit(grapheme)
    _, Error(_) -> False
  }
  let class = case literal {
    True -> "text-syntax-literal"
    False -> "text-syntax-function"
  }
  span(class, word)
}

fn take_until_quote(
  graphemes: List(String),
  acc: String,
) -> #(String, List(String)) {
  case graphemes {
    [] -> #(acc, [])
    ["\"", ..rest] -> #(acc, rest)
    [grapheme, ..rest] -> take_until_quote(rest, acc <> grapheme)
  }
}

fn is_toml_punctuation(grapheme: String) -> Bool {
  string.contains("[]{},.", grapheme)
}

fn is_toml_word(grapheme: String) -> Bool {
  is_ident_char(grapheme) || grapheme == "-"
}

fn is_toml_plain(grapheme: String) -> Bool {
  !is_toml_word(grapheme)
  && !is_toml_punctuation(grapheme)
  && grapheme != "\""
  && grapheme != "="
}

// --- Helpers -----------------------------------------------------------------

fn span(class: String, content: String) -> Element(message) {
  html.span([attribute.class(class)], [html.text(content)])
}

fn punctuation(content: String) -> Element(message) {
  span("text-syntax-punctuation", content)
}

// text-foreground so unspanned tokens (argument names, delimiters, pseudo
// classes) read as base code text inside muted table cells.
fn wrapper_class() -> Attribute(message) {
  attribute.class(
    "font-mono tracking-wide text-foreground text-[length:calc(1em-1px)]",
  )
}

fn is_ident_char(g: String) -> Bool {
  string.contains(
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_",
    g,
  )
}

fn is_digit(g: String) -> Bool {
  string.contains("0123456789", g)
}
