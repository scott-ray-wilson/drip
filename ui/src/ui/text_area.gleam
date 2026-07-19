import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// Multi-line text input that auto-grows with its content (browsers without
/// `field-sizing` support keep a fixed height and the manual resize handle).
/// Set the text with `content` rather than `attribute.value`, and pair it
/// with `event.on_input` to control the value.
pub fn input(
  attributes: List(Attribute(message)),
  content: String,
) -> Element(message) {
  html.textarea([attribute.data("slot", "text-area"), ..attributes], content)
}
