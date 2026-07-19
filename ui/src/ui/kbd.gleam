import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A single key cap. Renders a semantic `<kbd>` element. A bare call is the
/// raised default; reach for a variant attribute to change the surface.
pub fn kbd(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.kbd([attribute.data("slot", "kbd"), ..attributes], children)
}

/// Inline-flex wrapper that joins keys into a single shortcut shape, with a
/// `separator` between each pair.
pub fn combo(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "kbd-combo"), ..attributes], children)
}

/// Decorative glyph between keys in a `combo`: typically `+` for chords or
/// `then` for sequences. Marked `aria-hidden` so screen readers skip it.
pub fn separator(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [
      attribute.data("slot", "kbd-separator"),
      attribute.attribute("aria-hidden", "true"),
      ..attributes
    ],
    children,
  )
}

/// Small uppercase mono caption: for arrows or hints alongside keys
/// (e.g. inside an anatomy diagram).
pub fn caption(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "kbd-caption"), ..attributes], children)
}

/// One row in a shortcut list: settings panes, cheat-sheets, the bottom of
/// menus. Adjacent rows collapse their borders into a single column.
pub fn row(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "kbd-row"), ..attributes], children)
}

/// Left-aligned label inside a `row`. Pairs with a trailing `combo`.
pub fn row_label(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "kbd-row-label"), ..attributes], children)
}

// --- Variant Attributes ------------------------------------------------------

/// Flat key cap. Drops the bottom-edge weighting; use inside dense menus,
/// command palettes, or anywhere the raised treatment would compete with
/// surrounding chrome.
pub fn flat() -> Attribute(message) {
  attribute.data("variant", "flat")
}

/// Ghost key cap: no surface, just the glyph in mono. For body copy where
/// even a hairline border would feel heavy.
pub fn ghost() -> Attribute(message) {
  attribute.data("variant", "ghost")
}

/// Accent key cap, tinted in the brand hue. Use for the one shortcut you
/// actually want a user to memorize.
pub fn accent() -> Attribute(message) {
  attribute.data("variant", "accent")
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the key at a small size. Sits inline with body text.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Renders the key at a large size. For hero shortcut callouts.
pub fn lg() -> Attribute(message) {
  attribute.data("size", "lg")
}
