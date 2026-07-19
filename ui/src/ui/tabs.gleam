import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// Tabbed navigation container: list on top, content below. Add `vertical`
/// for a side-by-side layout. Compose with `list`, `trigger`, and `content`.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "tabs"), ..attributes], children)
}

/// Container for tab triggers. Renders the pill-style tab strip on a muted
/// surface; add `line` for the underline style.
pub fn list(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "tabs-list"),
      attribute.attribute("role", "tablist"),
      ..attributes
    ],
    children,
  )
}

/// Clickable tab. `value` matches the corresponding `content` value; mark
/// `active` when this trigger's panel is shown.
pub fn trigger(
  value value: String,
  active active: Bool,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let state_attrs = case active {
    True -> [
      attribute.data("active", "true"),
      attribute.attribute("aria-selected", "true"),
      attribute.attribute("tabindex", "0"),
    ]
    False -> [
      attribute.attribute("aria-selected", "false"),
      attribute.attribute("tabindex", "-1"),
    ]
  }
  html.button(
    [
      attribute.data("slot", "tabs-trigger"),
      attribute.data("value", value),
      attribute.attribute("role", "tab"),
      attribute.type_("button"),
      ..list.append(state_attrs, attributes)
    ],
    children,
  )
}

/// Panel revealed when its matching `trigger` (same `value`) is active.
/// Inactive panels are hidden and inert, so their content cannot take focus.
pub fn content(
  value value: String,
  active active: Bool,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let state_attrs = case active {
    True -> [attribute.attribute("tabindex", "0")]
    False -> [
      attribute.attribute("hidden", ""),
      attribute.attribute("inert", ""),
      attribute.attribute("tabindex", "-1"),
    ]
  }
  html.div(
    [
      attribute.data("slot", "tabs-content"),
      attribute.data("value", value),
      attribute.attribute("role", "tabpanel"),
      ..list.append(state_attrs, attributes)
    ],
    children,
  )
}

// --- Variant Attributes ------------------------------------------------------

/// Vertical layout: a bordered container with the list on the left and the
/// content on the right. Pass into the root's attribute list.
pub fn vertical() -> Attribute(message) {
  attribute.data("orientation", "vertical")
}

/// Underline-style list: transparent surface with an accent underline on the
/// active trigger. Pass into the list's attribute list.
pub fn line() -> Attribute(message) {
  attribute.data("variant", "line")
}

// --- FFI ---------------------------------------------------------------------

/// Wires up click activation and keyboard navigation across every tabs root
/// on the page. Call once on app start.
@external(javascript, "./tabs.ffi.mjs", "init")
pub fn init() -> Nil
