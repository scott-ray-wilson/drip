import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// An inline callout that surfaces an important message.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "alert"), ..attributes], children)
}

/// Leading icon tile. Inherits its color and background from the variant.
pub fn icon(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [
      attribute.data("slot", "alert-icon"),
      attribute.aria_hidden(True),
      ..attributes
    ],
    children,
  )
}

/// Short, bold heading for the alert.
pub fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "alert-title"), ..attributes], children)
}

/// Supporting text under the title.
pub fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "alert-description"), ..attributes],
    children,
  )
}

/// Trailing row under the description for inline action buttons.
pub fn actions(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "alert-actions"), ..attributes], children)
}

/// Trailing close button for dismissible alerts.
pub fn close(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "alert-close"),
      attribute.type_("button"),
      attribute.aria_label("Dismiss"),
      ..attributes
    ],
    children,
  )
}

// --- Variant Attributes ------------------------------------------------------

/// Informational alert for non-urgent messages.
///
/// Pair with `role="status"` if this alert warrants an
/// announcement after the current utterance finishes.
pub fn info() -> Attribute(message) {
  attribute.data("variant", "info")
}

/// Positive confirmation alert for completed actions.
///
/// Pair with `role="status"` if this alert warrants an
/// announcement after the current utterance finishes.
pub fn success() -> Attribute(message) {
  attribute.data("variant", "success")
}

/// Cautionary alert for potential problems.
///
/// Pair with `role="alert"` to interrupt the screen reader's current
/// utterance.
pub fn warning() -> Attribute(message) {
  attribute.data("variant", "warning")
}

/// Critical alert for failures that need attention.
///
/// Pair with `role="alert"` to interrupt the screen reader's current
/// utterance.
pub fn error() -> Attribute(message) {
  attribute.data("variant", "error")
}

/// Brand-aligned promotional alert for feature announcements.
///
/// Pair with `role="status"` if this alert warrants an announcement.
pub fn accent() -> Attribute(message) {
  attribute.data("variant", "accent")
}

/// Quiet alert for callouts, tips or notes. This is the default when no
/// variant attribute is supplied.
///
/// Pair with `role="status"` if this alert warrants an announcement.
pub fn neutral() -> Attribute(message) {
  attribute.data("variant", "neutral")
}

// --- Style Attributes --------------------------------------------------------

/// Full-width banner that squares the corners and keeps only the bottom
/// border so the alert spans its container edge-to-edge.
pub fn banner() -> Attribute(message) {
  attribute.data("style", "banner")
}
