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
    content.Callout(title: "Decorative by default", body: [
      content.Text(
        "Each separator carries a fixed role=\"none\": the rule is a visual
        cue, not a semantic boundary, and assistive tech skips it while still
        reading any centered content. If a division between regions should be
        announced, render your own element with role=\"separator\" and stamp
        data-slot=\"separator\" on it to reuse the rule's styling.",
      ),
    ]),
  ])
}
