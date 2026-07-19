import gleam/string
import lustre/element
import ui/accordion

// Accordion is script-free: items are native <details> and triggers native
// <summary>, so open and close work with no JS. Pin the native elements.
pub fn item_is_native_details_test() {
  let html = element.to_string(accordion.item([], []))
  assert string.starts_with(html, "<details")
  assert string.contains(html, "data-slot=\"accordion-item\"")
}

pub fn trigger_is_native_summary_test() {
  let html = element.to_string(accordion.trigger([], [element.text("Section")]))
  assert string.starts_with(html, "<summary")
  assert string.contains(html, "data-slot=\"accordion-trigger\"")
  assert string.contains(html, "Section")
}

// trigger() appends its own chevron, marked aria-hidden so the summary reads
// as just its label.
pub fn trigger_appends_hidden_icon_test() {
  let html = element.to_string(accordion.trigger([], []))
  assert string.contains(html, "data-slot=\"accordion-trigger-icon\"")
  assert string.contains(html, "aria-hidden=\"true\"")
}

pub fn root_variant_sets_data_attribute_test() {
  let html = element.to_string(accordion.root([accordion.outline()], []))
  assert string.contains(html, "data-slot=\"accordion\"")
  assert string.contains(html, "data-variant=\"outline\"")
}
