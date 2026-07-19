import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import ui/checkbox

// --- Helpers -----------------------------------------------------------------

fn occurrences(haystack: String, needle: String) -> Int {
  list.length(string.split(haystack, needle)) - 1
}

// --- Structure ---------------------------------------------------------------

// input() wraps a native checkbox in a slot span and layers an aria-hidden
// indicator the CSS positions over the box. Pin the structure: the CSS relies
// on exactly this shape.
pub fn input_wraps_native_checkbox_with_indicator_test() {
  let html = element.to_string(checkbox.input([]))
  assert string.starts_with(html, "<span")
  assert occurrences(html, "data-slot=\"checkbox\"") == 1
  assert string.contains(html, "type=\"checkbox\"")
  assert string.contains(html, "data-slot=\"checkbox-indicator\"")
  assert string.contains(html, "aria-hidden=\"true\"")
}

// --- Attribute Pass-Through --------------------------------------------------

// Attributes pass through to the native input, not the wrapper span, so form
// state binds to the real control. The span keeps only its slot: this is the
// wrapped-element contract that regressed before.
pub fn attributes_reach_the_native_input_test() {
  let html =
    element.to_string(
      checkbox.input([attribute.checked(True), attribute.name("terms")]),
    )
  assert string.contains(html, "checked")
  assert string.contains(html, "name=\"terms\"")
  assert string.starts_with(html, "<span data-slot=\"checkbox\">")
}
