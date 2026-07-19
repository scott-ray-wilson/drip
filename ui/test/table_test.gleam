import gleam/string
import lustre/attribute
import lustre/element
import ui/table

// root() wraps the <table> in a scroll container. Attributes pass through to
// the inner <table>, not the container div.
pub fn root_wraps_table_in_scroll_container_test() {
  let html = element.to_string(table.root([attribute.id("data")], []))
  assert string.starts_with(html, "<div data-slot=\"table-container\">")
  assert string.contains(html, "<table")
  assert string.contains(html, "data-slot=\"table\"")
  assert string.contains(html, "id=\"data\"")
}

// The regions and cells render native table elements, so semantics are free.
pub fn regions_are_native_table_elements_test() {
  assert string.starts_with(element.to_string(table.header([], [])), "<thead")
  assert string.starts_with(element.to_string(table.body([], [])), "<tbody")
  assert string.starts_with(element.to_string(table.footer([], [])), "<tfoot")
  assert string.starts_with(element.to_string(table.row([], [])), "<tr")
  assert string.starts_with(element.to_string(table.head([], [])), "<th")
  assert string.starts_with(element.to_string(table.cell([], [])), "<td")
  assert string.starts_with(
    element.to_string(table.caption([], [])),
    "<caption",
  )
}
