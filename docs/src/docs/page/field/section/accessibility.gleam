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
    content.Callout(title: "Native semantics, screen reader ready", body: [
      content.Text(
        "Field roots carry role=\"group\" so the label, control, and helper text
        announce as one unit, and field error carries role=\"alert\" so
        validation is announced the moment it appears. Bind each control to its
        field label with a matching for attribute, and group related controls in
        a field set with a field legend.",
      ),
    ]),
  ])
}
