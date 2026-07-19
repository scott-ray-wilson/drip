import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A `type="button"` action button.
pub fn button(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  base("button", attributes, children)
}

/// A `type="submit"` button that submits its enclosing form.
pub fn submit(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  base("submit", attributes, children)
}

/// A `type="reset"` button that resets its enclosing form.
pub fn reset(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  base("reset", attributes, children)
}

/// An anchor styled as a button for navigation rather than actions.
pub fn link(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.a([attribute.data("slot", "button"), ..attributes], children)
}

// --- Variant Attributes ------------------------------------------------------

/// High-contrast filled style for primary actions. This is the default when
/// no variant attribute is supplied.
pub fn primary() -> Attribute(message) {
  attribute.data("variant", "primary")
}

/// Lower-emphasis filled style for supporting actions.
pub fn secondary() -> Attribute(message) {
  attribute.data("variant", "secondary")
}

/// Brand-aligned style for feature actions and high-visibility CTAs.
pub fn accent() -> Attribute(message) {
  attribute.data("variant", "accent")
}

/// Bordered, transparent style for low-emphasis actions.
pub fn outline() -> Attribute(message) {
  attribute.data("variant", "outline")
}

/// Borderless, transparent style for the lowest-emphasis actions.
pub fn ghost() -> Attribute(message) {
  attribute.data("variant", "ghost")
}

/// Filled style for irreversible or dangerous actions.
pub fn destructive() -> Attribute(message) {
  attribute.data("variant", "destructive")
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the button at an extra-small size.
pub fn xs() -> Attribute(message) {
  attribute.data("size", "xs")
}

/// Renders the button at a small size.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Renders the button at a medium size. This is the default when no size
/// attribute is supplied.
pub fn md() -> Attribute(message) {
  attribute.data("size", "md")
}

/// Renders the button at a large size.
pub fn lg() -> Attribute(message) {
  attribute.data("size", "lg")
}

// --- Layout Attributes -------------------------------------------------------

/// Stretches the button to fill its parent's width.
pub fn full_width() -> Attribute(message) {
  attribute.data("full-width", "true")
}

/// Renders a square button sized for a single icon child. Give the button an
/// accessible name with `attribute.aria_label`.
pub fn icon_only() -> Attribute(message) {
  attribute.data("icon-only", "true")
}

// --- Icon Slot Attributes ----------------------------------------------------

/// Marks an icon as the leading child of a button.
/// Apply to the icon element, not the button.
pub fn icon_start() -> Attribute(message) {
  attribute.data("icon", "inline-start")
}

/// Marks an icon as the trailing child of a button.
/// Apply to the icon element, not the button.
pub fn icon_end() -> Attribute(message) {
  attribute.data("icon", "inline-end")
}

// --- Button Base -------------------------------------------------------------

fn base(
  type_: String,
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [attribute.data("slot", "button"), attribute.type_(type_), ..attributes],
    children,
  )
}
