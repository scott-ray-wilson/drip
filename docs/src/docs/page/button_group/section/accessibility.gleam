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
    content.Callout(title: "Announced as a related group", body: [
      content.Text(
        "The wrapper carries the ARIA group role, so assistive tech announces the
        surrounding buttons as one related set. Each child keeps its own native
        semantics; a button is still a button, an anchor is still an anchor. The
        role is only reliably announced when the group has a name, so give each
        group an accessible name with aria-label.",
      ),
    ]),
  ])
}
