import gleam/string
import lustre/attribute
import lustre/element
import ui/text_area

// input() renders a native <textarea> with the content as its body (set via
// content, not attribute.value) and passes attributes through.
pub fn renders_textarea_with_content_test() {
  let html =
    element.to_string(text_area.input([attribute.name("bio")], "Hello"))
  assert string.starts_with(html, "<textarea")
  assert string.contains(html, "data-slot=\"text-area\"")
  assert string.contains(html, "name=\"bio\"")
  assert string.contains(html, ">Hello</textarea>")
}
