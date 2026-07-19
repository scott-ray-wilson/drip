import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/icon

// --- Elements ----------------------------------------------------------------

/// A checkbox wrapping a native input with a layered check indicator.
/// Attributes pass through to the native input.
pub fn input(attributes: List(Attribute(message))) -> Element(message) {
  html.span([attribute.data("slot", "checkbox")], [
    html.input([attribute.type_("checkbox"), ..attributes]),
    icon.check([
      attribute.data("slot", "checkbox-indicator"),
      attribute.aria_hidden(True),
    ]),
  ])
}
