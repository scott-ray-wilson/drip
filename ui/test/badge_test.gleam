import gleam/string
import lustre/attribute
import lustre/element
import ui/badge

pub fn root_stamps_slot_and_passes_through_test() {
  let html =
    element.to_string(badge.root([attribute.id("count")], [element.text("9")]))
  assert string.starts_with(html, "<span")
  assert string.contains(html, "data-slot=\"badge\"")
  assert string.contains(html, "id=\"count\"")
  assert string.contains(html, "9")
}

pub fn variant_and_size_set_data_attributes_test() {
  let html = element.to_string(badge.root([badge.success(), badge.sm()], []))
  assert string.contains(html, "data-variant=\"success\"")
  assert string.contains(html, "data-size=\"sm\"")
}
