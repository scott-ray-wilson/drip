import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "accessibility", label: "Accessibility")

pub fn table_of_contents() -> List(Entry) {
  [table_of_contents.entry(heading_anchor)]
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
  content.Group([
    content.Heading(heading_anchor),
    content.Callout(title: "Native semantics, screen-reader friendly", body: [
      content.Text("Renders as native "),
      content.Code("<table>"),
      content.Text(", "),
      content.Code("<thead>"),
      content.Text(", "),
      content.Code("<tbody>"),
      content.Text(", and "),
      content.Code("<tfoot>"),
      content.Text(
        " markup so assistive tech announces row and column position out of the
        box. Pair with a ",
      ),
      content.Code("<caption>"),
      content.Text(" to summarize the table's purpose."),
    ]),
  ])
}
