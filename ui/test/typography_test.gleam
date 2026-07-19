import gleam/string
import lustre/element
import ui/typography

// The helpers render the right native heading, paragraph, and code elements so
// document semantics match the visual scale.
pub fn elements_match_their_semantics_test() {
  assert string.starts_with(
    element.to_string(typography.page_title([], [])),
    "<h1",
  )
  assert string.starts_with(element.to_string(typography.h2([], [])), "<h2")
  assert string.starts_with(element.to_string(typography.h3([], [])), "<h3")
  assert string.starts_with(element.to_string(typography.body([], [])), "<p")
  assert string.starts_with(element.to_string(typography.code([], [])), "<code")
}

// page_title and h1 both render an <h1> but carry different slots, so the
// display scale is independent of heading level.
pub fn page_title_and_h1_share_a_tag_differ_by_slot_test() {
  let page_title = element.to_string(typography.page_title([], []))
  let h1 = element.to_string(typography.h1([], []))
  assert string.starts_with(page_title, "<h1")
  assert string.starts_with(h1, "<h1")
  assert string.contains(page_title, "data-slot=\"page-title\"")
  assert string.contains(h1, "data-slot=\"h1\"")
}

// The star decoration is hidden from assistive tech.
pub fn star_is_decorative_test() {
  let html = element.to_string(typography.star([], []))
  assert string.contains(html, "data-slot=\"star\"")
  assert string.contains(html, "aria-hidden=\"true\"")
}
