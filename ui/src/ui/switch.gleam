import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A switch wrapping a native input with a sliding thumb layered on top.
/// Attributes pass through to the native input.
pub fn input(attributes: List(Attribute(message))) -> Element(message) {
  html.span([attribute.data("slot", "switch")], [
    html.input([
      attribute.type_("checkbox"),
      attribute.attribute("role", "switch"),
      ..attributes
    ]),
    html.span([attribute.data("slot", "switch-thumb")], []),
  ])
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the switch at a small size.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Renders the switch at a medium size. This is the default when no size
/// attribute is supplied.
pub fn md() -> Attribute(message) {
  attribute.data("size", "md")
}
