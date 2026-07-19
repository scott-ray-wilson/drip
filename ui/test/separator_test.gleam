import gleam/string
import lustre/element
import ui/separator

// A plain rule is decorative and empty: role="none", no content marker.
pub fn plain_rule_is_decorative_and_empty_test() {
  let html = element.to_string(separator.root([], []))
  assert string.contains(html, "data-slot=\"separator\"")
  assert string.contains(html, "role=\"none\"")
  assert !string.contains(html, "data-content")
  assert !string.contains(html, "separator-content")
}

// Passing children flips it to a labeled divider: a content marker plus a
// wrapper span holding the children over the line.
pub fn children_render_a_content_wrapper_test() {
  let html = element.to_string(separator.root([], [element.text("OR")]))
  assert string.contains(html, "data-content=\"true\"")
  assert string.contains(html, "data-slot=\"separator-content\"")
  assert string.contains(html, "OR")
}

pub fn orientation_sets_data_attribute_test() {
  let html = element.to_string(separator.root([separator.vertical()], []))
  assert string.contains(html, "data-orientation=\"vertical\"")
}
