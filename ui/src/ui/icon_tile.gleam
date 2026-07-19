import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A tile that frames a feature or status icon. Set the color with a variant
/// attribute.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [
      attribute.data("slot", "icon-tile"),
      attribute.attribute("aria-hidden", "true"),
      ..attributes
    ],
    children,
  )
}

// --- Variant Attributes ------------------------------------------------------

/// Brand-aligned tile for feature icons and high-visibility marks. This is the
/// default when no variant attribute is supplied.
pub fn accent() -> Attribute(message) {
  attribute.data("variant", "accent")
}

/// Informational tile for help and status icons.
pub fn info() -> Attribute(message) {
  attribute.data("variant", "info")
}

/// Positive tile for success state icons.
pub fn success() -> Attribute(message) {
  attribute.data("variant", "success")
}

/// Cautionary tile for warning state icons.
pub fn warning() -> Attribute(message) {
  attribute.data("variant", "warning")
}

/// Critical tile for failure state icons.
pub fn error() -> Attribute(message) {
  attribute.data("variant", "error")
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the tile at a small size.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Renders the tile at a large size.
pub fn lg() -> Attribute(message) {
  attribute.data("size", "lg")
}
