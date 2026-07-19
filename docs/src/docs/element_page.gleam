import docs/route
import docs/ui/page_header
import docs/ui/table_of_contents.{type Entry}
import drip/registry.{type Category, type Element as RegistryElement}
import gleam/list
import gleam/string
import lustre/element.{type Element as LustreElement}

// --- Element Page ------------------------------------------------------------

/// A documentation page for a registry element: the element's metadata plus the
/// ordered sections that make up its body.
pub type ElementPage(message) {
  ElementPage(element: RegistryElement, sections: List(Section(message)))
}

/// One section of an element page, as three deferred builders. Holding them as
/// thunks keeps `page()` construction cheap and lets each aggregate force only
/// what it needs: `table_of_contents` never builds the views or Markdown.
pub type Section(message) {
  Section(
    table_of_contents: fn() -> List(Entry),
    view: fn() -> LustreElement(message),
    markdown: fn() -> String,
  )
}

// --- View --------------------------------------------------------------------

/// Render the full page: a header (eyebrow, title, lede, copy-page Markdown)
/// followed by every section's view.
pub fn view(page: ElementPage(message)) -> LustreElement(message) {
  element.fragment([
    page_header.view(
      route: route.Element(page.element.name),
      eyebrow: eyebrow(page.element.category),
      title: registry.title(page.element.name),
      lede: page.element.description,
      markdown: markdown(page),
      prompt: "help me use the "
        <> registry.title(page.element.name)
        <> " element from drip",
    ),
    ..list.map(page.sections, fn(section) { section.view() })
  ])
}

// --- Table of Contents -------------------------------------------------------

/// Render the on-this-page navigation by concatenating every section's entries.
pub fn table_of_contents(page: ElementPage(message)) -> LustreElement(message) {
  page.sections
  |> list.flat_map(fn(section) { section.table_of_contents() })
  |> table_of_contents.view
}

// --- Markdown ----------------------------------------------------------------

/// The whole page as Markdown: a title and lede, then every section's Markdown.
/// Feeds the copy-page button (`data-markdown`) and the `/elements/<slug>.md`
/// file written by `scripts/generate_md.mjs`.
pub fn markdown(page: ElementPage(message)) -> String {
  let heading = "# " <> registry.title(page.element.name)
  let lede = page.element.description
  let body =
    page.sections
    |> list.map(fn(section) { section.markdown() })
    |> list.filter(fn(section_markdown) { section_markdown != "" })
    |> string.join("\n\n")

  case body {
    "" -> heading <> "\n\n" <> lede <> "\n"
    _ -> heading <> "\n\n" <> lede <> "\n\n" <> body <> "\n"
  }
}

// --- Helpers -----------------------------------------------------------------

// The page eyebrow is derived from the element's category, so every member of a
// family reads consistently (all Layout elements are "Layout Element", etc.).
fn eyebrow(category: Category) -> String {
  case category {
    registry.Forms -> "Form Element"
    registry.Actions -> "Action Element"
    registry.Navigation -> "Navigation Element"
    registry.Overlay -> "Overlay Element"
    registry.Disclosure -> "Disclosure Element"
    registry.Layout -> "Layout Element"
    registry.DataDisplay -> "Data Element"
    registry.Feedback -> "Feedback Element"
  }
}
