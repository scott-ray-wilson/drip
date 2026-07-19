//// Syntax highlighters turning Gleam, JavaScript, and CSS source into the
//// highlighted HTML the docs site renders.

import contour.{type Token as GleamToken}
import gleam/int
import gleam/list
import gleam/string
import just.{type HighlightToken as JavascriptToken}
import swatch.{type Token as CssToken}

// --- Gleam -> HTML -----------------------------------------------------------

pub fn gleam_to_html(source: String) -> String {
  contour.to_tokens(source)
  |> list.map(gleam_token_to_html)
  |> string.concat
}

fn gleam_token_to_html(token: GleamToken) -> String {
  case token {
    contour.Whitespace(token) -> escape_html(token)
    contour.Keyword(token) -> span("text-syntax-keyword", token)
    contour.String(token) | contour.Number(token) ->
      span("text-syntax-literal", token)
    contour.Comment(token) -> span("text-syntax-comment italic", token)
    contour.Function(token) -> span("text-syntax-function", token)
    contour.Module(token) -> span("text-syntax-type", token)
    contour.Variant(token) -> span(variant_class(token), token)
    contour.Operator(token) -> span("text-syntax-operator", token)
    contour.Other(token) -> gleam_other_to_html(token)
  }
}

// contour has no boolean token; True/False arrive as ordinary variants.
fn variant_class(token: String) -> String {
  case token {
    "True" | "False" -> "text-syntax-boolean"
    _ -> "text-syntax-type"
  }
}

// contour lumps brackets, delimiters, and bare identifiers into `Other`.
fn gleam_other_to_html(token: String) -> String {
  case token {
    "(" | ")" | "[" | "]" | "{" | "}" | "." | ".." | "," ->
      span("text-syntax-punctuation", token)
    _ -> escape_html(token)
  }
}

// --- JavaScript -> HTML ------------------------------------------------------

pub fn javascript_to_html(source: String) -> String {
  just.highlight_tokens(source)
  |> list.map(javascript_token_to_html)
  |> string.concat
}

fn javascript_token_to_html(token: JavascriptToken) -> String {
  case token {
    just.HighlightWhitespace(token)
    | just.HighlightVariable(token)
    | just.HighlightOther(token) -> escape_html(token)
    just.HighlightPunctuation(token) -> span("text-syntax-punctuation", token)
    just.HighlightKeyword(token) -> span("text-syntax-keyword", token)
    just.HighlightString(token) -> javascript_string_to_html(token)
    just.HighlightRegexp(token) | just.HighlightNumber(token) ->
      span("text-syntax-literal", token)
    just.HighlightComment(token) -> span("text-syntax-comment italic", token)
    just.HighlightFunction(token) -> span("text-syntax-function", token)
    just.HighlightClass(token) -> span("text-syntax-type", token)
    just.HighlightOperator(token) -> span("text-syntax-operator", token)
  }
}

// `just` folds template-literal delimiters into its string tokens so we split
// the interpolation braces (`${` and `}`) into their own span.
fn javascript_string_to_html(token: String) -> String {
  case token {
    // Template head: backtick + text + `${`
    "`" <> _ ->
      case string.ends_with(token, "${") {
        True -> string_segment(string.drop_end(token, 2)) <> interpolation("${")
        False -> span("text-syntax-literal", token)
      }
    // Template middle (`}…${`) or tail (`}…` ``)
    "}" <> rest ->
      case string.ends_with(token, "${") {
        True ->
          interpolation("}")
          <> string_segment(string.drop_end(rest, 2))
          <> interpolation("${")
        False -> interpolation("}") <> string_segment(rest)
      }
    // Ordinary "…" / '…' string literal
    _ -> span("text-syntax-literal", token)
  }
}

fn string_segment(segment: String) -> String {
  case segment {
    "" -> ""
    _ -> span("text-syntax-literal", segment)
  }
}

fn interpolation(delimiter: String) -> String {
  span("text-syntax-operator", delimiter)
}

// --- CSS ---------------------------------------------------------------------

pub fn css_to_html(source: String) -> String {
  swatch.to_tokens(source)
  |> merge_apply_utilities
  |> list.map(css_token_to_html)
  |> string.concat
}

fn css_token_to_html(token: CssToken) -> String {
  case token {
    swatch.Whitespace(token) | swatch.PseudoSelector(token) ->
      escape_html(token)
    swatch.Punctuation(token) | swatch.Other(token) ->
      span("text-syntax-punctuation", token)
    swatch.Comment(token) -> span("text-syntax-comment italic", token)
    swatch.AtRule(token)
    | swatch.Important(token)
    | swatch.AttributeName(token)
    | swatch.AttributeValue(token)
    | swatch.AttributeFlag(token)
    | swatch.Property(token)
    | swatch.Variable(token)
    | swatch.Keyword(token) -> span("text-syntax-keyword", token)
    swatch.ClassSelector(token)
    | swatch.IdSelector(token)
    | swatch.Function(token)
    | swatch.Selector(token) -> span("text-syntax-function", token)
    swatch.Operator(token) | swatch.Unit(token) ->
      span("text-syntax-operator", token)
    swatch.String(token) | swatch.Number(token) | swatch.HexColor(token) ->
      span("text-syntax-literal", token)
  }
}

// swatch tokenises as plain CSS, so a Tailwind utility like `bg-primary/10`
// lands as several tokens; fuse them back into one inside `@apply`.

type ApplyState {
  ApplyState(in_apply: Bool, bracket_depth: Int)
}

fn merge_apply_utilities(tokens: List(CssToken)) -> List(CssToken) {
  merge(tokens, ApplyState(False, 0), [])
}

fn merge(
  tokens: List(CssToken),
  state: ApplyState,
  acc: List(CssToken),
) -> List(CssToken) {
  case tokens {
    [] -> list.reverse(acc)
    [token, ..rest] -> {
      let blending = state.in_apply && state.bracket_depth == 0
      let next_acc = case blending, token, acc {
        // Fuse `/10`, `.5`, `!` etc. into the preceding utility name.
        True, swatch.Number(token), [swatch.Keyword(prev), ..tail]
        | True, swatch.Operator(token), [swatch.Keyword(prev), ..tail]
        -> [swatch.Keyword(prev <> token), ..tail]
        // Recolour a variant separator like `has-checked:` or
        // `:w-full` as a keyword.
        True, swatch.PseudoSelector(token), _ -> [swatch.Keyword(token), ..acc]
        _, _, _ -> [token, ..acc]
      }
      merge(rest, advance(token, state), next_acc)
    }
  }
}

fn advance(token: CssToken, state: ApplyState) -> ApplyState {
  case token {
    swatch.AtRule(name) ->
      case string.lowercase(name) == "@apply" {
        True -> ApplyState(..state, in_apply: True)
        False -> state
      }
    swatch.Punctuation(";") | swatch.Punctuation("}") -> ApplyState(False, 0)
    swatch.Punctuation("[") ->
      ApplyState(..state, bracket_depth: state.bracket_depth + 1)
    swatch.Punctuation("]") ->
      ApplyState(..state, bracket_depth: int.max(0, state.bracket_depth - 1))
    _ -> state
  }
}

// --- HTML Emission -----------------------------------------------------------

fn span(class: String, content: String) -> String {
  "<span class=\"" <> class <> "\">" <> escape_html(content) <> "</span>"
}

fn escape_html(content: String) -> String {
  content
  |> string.replace("&", "&amp;")
  |> string.replace("<", "&lt;")
  |> string.replace(">", "&gt;")
}
