import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import ui/icon.{loader_circle}

// --- Elements ----------------------------------------------------------------

/// An indeterminate loading indicator. Rendered `aria-hidden`: wrap it and a
/// short text label in a `role="status"` container when the wait should be
/// announced.
pub fn icon(attributes: List(Attribute(message))) -> Element(message) {
  loader_circle([attribute.data("slot", "spinner"), ..attributes])
}
