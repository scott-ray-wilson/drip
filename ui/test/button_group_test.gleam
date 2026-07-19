import gleam/string
import lustre/element
import ui/button_group

// The group is a semantic role="group"; callers give it a name in real use.
pub fn root_is_a_group_test() {
  let html =
    element.to_string(button_group.root([button_group.horizontal()], []))
  assert string.contains(html, "data-slot=\"button-group\"")
  assert string.contains(html, "role=\"group\"")
  assert string.contains(html, "data-orientation=\"horizontal\"")
}

// The cluster separator is decorative, skipped by assistive tech.
pub fn separator_is_decorative_test() {
  let html = element.to_string(button_group.separator([]))
  assert string.contains(html, "data-slot=\"button-group-separator\"")
  assert string.contains(html, "role=\"none\"")
}
