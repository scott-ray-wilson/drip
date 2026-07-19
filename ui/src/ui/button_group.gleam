import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A row or column of related buttons. Give the group an accessible name
/// with `attribute.aria_label` so assistive tech can announce its purpose.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.attribute("role", "group"),
      attribute.data("slot", "button-group"),
      ..attributes
    ],
    children,
  )
}

/// Divider that breaks a group into clusters of buttons.
pub fn separator(attributes: List(Attribute(message))) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "button-group-separator"),
      attribute.attribute("role", "none"),
      ..attributes
    ],
    [],
  )
}

// --- Orientation Attributes --------------------------------------------------

/// Lays the group out as a row of buttons sharing vertical borders. This is the
/// default when no orientation attribute is supplied.
pub fn horizontal() -> Attribute(message) {
  attribute.data("orientation", "horizontal")
}

/// Stacks the group as a column of buttons sharing horizontal borders.
pub fn vertical() -> Attribute(message) {
  attribute.data("orientation", "vertical")
}
