import gleam/string
import lustre/element
import ui/alert

pub fn root_stamps_slot_and_variant_test() {
  let html =
    element.to_string(alert.root([alert.warning()], [element.text("Heads up")]))
  assert string.starts_with(html, "<div")
  assert string.contains(html, "data-slot=\"alert\"")
  assert string.contains(html, "data-variant=\"warning\"")
  assert string.contains(html, "Heads up")
}

// The icon tile is decorative, hidden from assistive tech.
pub fn icon_is_aria_hidden_test() {
  let html = element.to_string(alert.icon([], []))
  assert string.contains(html, "data-slot=\"alert-icon\"")
  assert string.contains(html, "aria-hidden=\"true\"")
}

// close() bakes a real button with a hardcoded accessible name so a
// dismissible alert is always operable by name.
pub fn close_is_a_labelled_button_test() {
  let html = element.to_string(alert.close([], []))
  assert string.starts_with(html, "<button")
  assert string.contains(html, "type=\"button\"")
  assert string.contains(html, "aria-label=\"Dismiss\"")
  assert string.contains(html, "data-slot=\"alert-close\"")
}

pub fn banner_sets_style_attribute_test() {
  let html = element.to_string(alert.root([alert.banner()], []))
  assert string.contains(html, "data-style=\"banner\"")
}
