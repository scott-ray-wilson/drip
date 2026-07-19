import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// Single-line text input. Pair `attribute.value` with `event.on_input` to
/// control the value; set `placeholder`, `type_`, etc. with `lustre/attribute`.
pub fn input(attributes: List(Attribute(message))) -> Element(message) {
  html.input([attribute.data("slot", "text-field"), ..attributes])
}
