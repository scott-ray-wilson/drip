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
    content.Callout(title: "Opt-in live-region roles", body: [
      content.Text(
        "Alerts ship without a live-region role, so announcements are up to you.
        Add role=\"alert\" to errors and warnings to interrupt the screen reader
        as soon as the alert appears, or role=\"status\" to info and success to
        announce politely after the current utterance. Leave neutral and accent
        role-free unless they carry something worth announcing.",
      ),
    ]),
  ])
}
