import gleam/string
import lustre/attribute
import lustre/element
import ui/radio_group

// The group announces as one unit via role="radiogroup".
pub fn root_is_a_radiogroup_test() {
  let html = element.to_string(radio_group.root([], []))
  assert string.contains(html, "data-slot=\"radio-group\"")
  assert string.contains(html, "role=\"radiogroup\"")
}

// item() wraps a native radio and layers an indicator; attributes pass through
// to the input, not the wrapper span, so name and value bind to the real
// control.
pub fn attributes_reach_the_native_input_test() {
  let html =
    element.to_string(
      radio_group.item([attribute.name("plan"), attribute.value("pro")]),
    )
  assert string.starts_with(html, "<span data-slot=\"radio-group-item\">")
  assert string.contains(html, "type=\"radio\"")
  assert string.contains(html, "name=\"plan\"")
  assert string.contains(html, "value=\"pro\"")
  assert string.contains(html, "data-slot=\"radio-group-indicator\"")
}
