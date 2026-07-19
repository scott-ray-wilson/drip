import gleam/string
import lustre/element
import ui/kbd

// A bare key renders as the native <kbd>: the raised default, carrying no
// variant attribute.
pub fn kbd_is_native_raised_default_test() {
  let html = element.to_string(kbd.kbd([], [element.text("K")]))
  assert string.starts_with(html, "<kbd")
  assert string.contains(html, "data-slot=\"kbd\"")
  assert !string.contains(html, "data-variant")
  assert string.contains(html, "K")
}

// A variant attribute tags the key cap for the stylesheet.
pub fn variant_sets_data_variant_test() {
  let html = element.to_string(kbd.kbd([kbd.flat()], []))
  assert string.contains(html, "data-variant=\"flat\"")
}

pub fn size_sets_data_size_test() {
  let html = element.to_string(kbd.kbd([kbd.sm()], []))
  assert string.contains(html, "data-size=\"sm\"")
}

// The combo separator is a decorative glyph, hidden from assistive tech.
pub fn separator_is_aria_hidden_test() {
  let html = element.to_string(kbd.separator([], [element.text("+")]))
  assert string.contains(html, "data-slot=\"kbd-separator\"")
  assert string.contains(html, "aria-hidden=\"true\"")
}
