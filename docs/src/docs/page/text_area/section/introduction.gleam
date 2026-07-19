import docs/content.{type Block}
import docs/generated/example/text_area
import docs/page/text_area/example/introduction
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// The page header renders at the page level (see text_area/page.gleam) so it can
// carry the whole page's Markdown. This section is just the lead-in preview.

// --- Table of Contents -------------------------------------------------------

pub fn table_of_contents() -> List(Entry) {
  []
}

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  content.to_lustre(content())
}

// --- Markdown ----------------------------------------------------------------

pub fn markdown() -> String {
  content.to_markdown(content())
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  content.Example(code: text_area.introduction_html, body: [
    introduction.view(),
  ])
}
