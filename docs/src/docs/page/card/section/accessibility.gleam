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
    content.Callout(title: "No implicit semantics", body: [
      content.Text(
        "A card renders as a plain container with no implicit landmark or heading
        semantics; it groups content visually, not structurally. When its title
        heads a navigable section, give it real heading semantics (for example, a
        heading element in the title slot) so it joins the document outline.",
      ),
    ]),
  ])
}
