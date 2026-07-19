import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A small label that annotates an item with status, category, or count.
/// Renders the neutral style when no variant attribute is supplied.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "badge"), ..attributes], children)
}

// --- Variant Attributes ------------------------------------------------------

/// Subtle, neutral style for low-emphasis tags and metadata. This is the
/// default when no variant attribute is supplied.
pub fn neutral() -> Attribute(message) {
  attribute.data("variant", "neutral")
}

/// Brand-aligned style for accent labels and feature tags.
pub fn accent() -> Attribute(message) {
  attribute.data("variant", "accent")
}

/// Style for informational status, like in-progress or new items.
pub fn info() -> Attribute(message) {
  attribute.data("variant", "info")
}

/// Style for positive status, like success or completed items.
pub fn success() -> Attribute(message) {
  attribute.data("variant", "success")
}

/// Style for cautionary status, like warnings or items needing attention.
pub fn warning() -> Attribute(message) {
  attribute.data("variant", "warning")
}

/// Style for irreversible or dangerous status, like errors and revoked items.
pub fn error() -> Attribute(message) {
  attribute.data("variant", "error")
}

/// Bordered, transparent style for low-emphasis tags.
pub fn outline() -> Attribute(message) {
  attribute.data("variant", "outline")
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the badge at a small size, suitable for dense lists and inline
/// metadata.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}
