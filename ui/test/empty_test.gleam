import gleam/string
import lustre/element
import ui/empty

pub fn root_variant_sets_data_attribute_test() {
  let html = element.to_string(empty.root([empty.outline()], []))
  assert string.contains(html, "data-slot=\"empty\"")
  assert string.contains(html, "data-variant=\"outline\"")
}

// media() and icon() use distinct slots (empty-media / empty-icon) with no
// variant attribute, and only the decorative icon() is hidden from assistive
// tech.
pub fn media_is_visible_icon_is_hidden_test() {
  let media = element.to_string(empty.media([], []))
  assert string.contains(media, "data-slot=\"empty-media\"")
  assert !string.contains(media, "data-variant")
  assert !string.contains(media, "aria-hidden")

  let icon = element.to_string(empty.icon([], []))
  assert string.contains(icon, "data-slot=\"empty-icon\"")
  assert !string.contains(icon, "data-variant")
  assert string.contains(icon, "aria-hidden=\"true\"")
}
