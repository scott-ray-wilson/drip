import gleam/string
import lustre/attribute
import lustre/element
import ui/switch

// The switch wraps a native checkbox exposed as role="switch", with a thumb
// layered on top. Attributes pass through to the input, not the wrapper span.
pub fn wraps_native_checkbox_as_switch_test() {
  let html =
    element.to_string(
      switch.input([attribute.checked(True), attribute.name("wifi")]),
    )
  assert string.starts_with(html, "<span data-slot=\"switch\">")
  assert string.contains(html, "type=\"checkbox\"")
  assert string.contains(html, "role=\"switch\"")
  assert string.contains(html, "checked")
  assert string.contains(html, "name=\"wifi\"")
  assert string.contains(html, "data-slot=\"switch-thumb\"")
}

pub fn size_sets_data_size_test() {
  let html = element.to_string(switch.input([switch.sm()]))
  assert string.contains(html, "data-size=\"sm\"")
}
