import docs/content.{type Block}
import docs/generated/example/button
import docs/page/button/example/link
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "as-a-link", label: "As a Link")

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
    content.Paragraph([
      content.Text(
        "Render an anchor styled as a button for navigation rather than
        actions.",
      ),
    ]),
    content.Example(code: button.link_html, body: [link.view()]),
  ])
}
