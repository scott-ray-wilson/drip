import gleam/string
import lustre/element
import ui/spinner

// The spinner is an icon glyph carrying the spinner slot; a wrapping status
// region is what announces the wait, so the glyph itself is style-only.
pub fn icon_stamps_slot_test() {
  let html = element.to_string(spinner.icon([]))
  assert string.starts_with(html, "<svg")
  assert string.contains(html, "data-slot=\"spinner\"")
}
