import docs/content.{type Block}
import docs/generated/example/empty
import docs/page/empty/example/ghost
import docs/page/empty/example/outline
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "variants", label: "Variants")

const ghost_anchor = Anchor(id: "ghost", label: "Ghost")

const outline_anchor = Anchor(id: "outline", label: "Outline")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      ghost_anchor,
      outline_anchor,
    ]),
  ]
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
        "Two ways to frame the container, from a borderless ghost to a dashed
        outline.",
      ),
    ]),
    // --- Ghost ---------------------------------------------------------------
    content.SectionExample(
      anchor: ghost_anchor,
      description: [
        content.Text(
          "Suited to empty states nested inside a card or panel that already
          supplies a frame.",
        ),
      ],
      code: empty.ghost_html,
      body: [ghost.view()],
    ),
    // --- Outline -------------------------------------------------------------
    content.SectionExample(
      anchor: outline_anchor,
      description: [
        content.Text(
          "Sets the region apart when the empty state stands on its own.",
        ),
      ],
      code: empty.outline_html,
      body: [outline.view()],
    ),
  ])
}
