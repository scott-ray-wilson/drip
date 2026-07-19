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
        "Renders as an aria-hidden icon, a purely visual cue that screen readers
        skip. Wrapping the spinner and a short text label in a container with
        role=\"status\" announces the wait politely, once, when the region
        appears. The spin honors prefers-reduced-motion, slowing to one rotation
        every six seconds.",
      ),
    ]),
  ])
}
