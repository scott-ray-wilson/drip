import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/dialog
import ui/icon

@external(javascript, "./command.ffi.mjs", "init")
pub fn init() -> Nil

// Root --------------------------------------------------------------------------------

/// Searchable, keyboard-first list of actions. Default width is 560px;
/// pair with `sm()` / `lg()` for narrower/wider surfaces, or `inline()` /
/// `slash()` for the inline panel and editor-popover variants.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "command"), ..attributes], children)
}

// Modifiers ---------------------------------------------------------------------------

/// Narrow palette (420px).
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Wide palette (680px).
pub fn lg() -> Attribute(message) {
  attribute.data("size", "lg")
}

/// Sit inline in a panel: drops the elevation shadow.
pub fn inline() -> Attribute(message) {
  attribute.data("style", "inline")
}

/// 280px popover form for editor "/" menus.
pub fn slash() -> Attribute(message) {
  attribute.data("style", "slash")
}

// Dialog wrapper ----------------------------------------------------------------------

/// Mount the command surface inside a dialog so it floats over a scrim: the
/// classic ⌘K palette.
pub fn dialog(
  id: String,
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  dialog.root(id, [attribute.data("style", "command"), ..attrs], children)
}

// Input -------------------------------------------------------------------------------

/// Search input with a built-in leading icon. `trailing` lets you drop a
/// `kbd` (or anything else) at the right edge of the row (e.g. an ESC hint).
pub fn input(
  placeholder placeholder: String,
  attrs attrs: List(Attribute(message)),
  trailing trailing: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "command-input-wrapper")],
    list.flatten([
      [
        html.span([attribute.data("slot", "command-icon")], [icon.search([])]),
        html.input([
          attribute.type_("text"),
          attribute.data("slot", "command-input"),
          attribute.attribute("autocomplete", "off"),
          attribute.placeholder(placeholder),
          ..attrs
        ]),
      ],
      trailing,
    ]),
  )
}

// Kbd ---------------------------------------------------------------------------------

/// Small monospaced key cap. Drop it as `trailing` content on the input,
/// inside a footer, or anywhere a keyboard hint helps.
pub fn kbd(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-kbd"), ..attributes], children)
}

// List --------------------------------------------------------------------------------

pub fn list(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "command-list"),
      attribute.attribute("role", "listbox"),
      ..attributes
    ],
    children,
  )
}

// Empty -------------------------------------------------------------------------------

pub fn empty(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "command-empty"), ..attributes], children)
}

// Group -------------------------------------------------------------------------------

pub fn group(
  heading heading: String,
  attrs attrs: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let heading_el = case heading {
    "" -> []
    _ -> [
      html.div([attribute.data("slot", "command-group-heading")], [
        html.text(heading),
      ]),
    ]
  }
  html.div(
    [
      attribute.data("slot", "command-group"),
      attribute.attribute("role", "group"),
      ..attrs
    ],
    list.append(heading_el, children),
  )
}

// Separator ---------------------------------------------------------------------------

pub fn separator(attrs: List(Attribute(message))) -> Element(message) {
  html.hr([
    attribute.data("slot", "command-separator"),
    attribute.attribute("role", "separator"),
    ..attrs
  ])
}

// Item --------------------------------------------------------------------------------

/// Selectable row. Compose with `command.label`, `command.shortcut`, and
/// `command.meta` for the right-aligned hints.
pub fn item(
  value value: String,
  attrs attrs: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "command-item"),
      attribute.data("value", value),
      attribute.attribute("role", "option"),
      attribute.type_("button"),
      ..attrs
    ],
    children,
  )
}

/// Selectable row rendered as an anchor: Enter and click follow `href`
/// natively. Use for navigation-style palettes (e.g. site search). The
/// `value` attribute is set to `href` so the existing filter/select pipeline
/// keeps working.
pub fn item_link(
  href href: String,
  attrs attrs: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  html.a(
    [
      attribute.data("slot", "command-item"),
      attribute.data("value", href),
      attribute.attribute("role", "option"),
      attribute.href(href),
      ..attrs
    ],
    children,
  )
}

// Label -------------------------------------------------------------------------------

/// Flex-1 text content used inside an item.
pub fn label(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-label"), ..attrs], children)
}

// Description -------------------------------------------------------------------------

/// Muted one-line summary of an item: nest it inside `command.label` after
/// the label text and it renders as the row's second line. Its text counts
/// toward the search filter, so descriptions widen what a query matches.
pub fn description(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-description"), ..attrs], children)
}

// Shortcut ----------------------------------------------------------------------------

/// Keyboard shortcut hint pinned to the right of an item: render each key
/// as a child span.
pub fn shortcut(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-shortcut"), ..attrs], children)
}

// Meta --------------------------------------------------------------------------------

/// Right-aligned meta text on an item: typically the item's type
/// ("Action", "Component") or a timestamp.
pub fn meta(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-meta"), ..attrs], children)
}

// Footer ------------------------------------------------------------------------------

/// Bottom hint row: typically a sequence of "<key> action" pairs.
pub fn footer(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "command-footer"), ..attrs], children)
}

/// A single key cap used inside a footer hint.
pub fn key(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "command-key"), ..attrs], children)
}

/// Flex spacer for the footer: pushes following children to the right.
pub fn spacer() -> Element(message) {
  html.span([attribute.data("slot", "command-spacer")], [])
}

// Trigger -----------------------------------------------------------------------------

/// Subtle search-shaped button that opens the palette. Drop it in a header
/// or sidebar and pair it with the ⌘K shortcut hint.
pub fn trigger(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "command-trigger"),
      attribute.type_("button"),
      ..attrs
    ],
    list.flatten([
      [html.span([attribute.data("slot", "command-icon")], [icon.search([])])],
      children,
    ]),
  )
}

/// Flex-1 label inside a trigger: left-aligns the text between the icon and
/// the kbd hint.
pub fn trigger_label(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [attribute.data("slot", "command-trigger-label"), ..attrs],
    children,
  )
}
