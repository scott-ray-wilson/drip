import gleam/string
import lustre/attribute
import lustre/element
import ui/text_field

// input() renders a native <input> carrying the slot, with everything else
// passed through.
pub fn renders_input_with_slot_test() {
  let html =
    element.to_string(
      text_field.input([
        attribute.type_("email"),
        attribute.placeholder("you@example.com"),
      ]),
    )
  assert string.starts_with(html, "<input")
  assert string.contains(html, "data-slot=\"text-field\"")
  assert string.contains(html, "type=\"email\"")
  assert string.contains(html, "placeholder=\"you@example.com\"")
}
