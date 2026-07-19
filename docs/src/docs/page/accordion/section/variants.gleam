import docs/content.{type Block}
import docs/generated/example/accordion
import docs/page/accordion/example/filled
import docs/page/accordion/example/ghost
import docs/page/accordion/example/outline
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "variants", label: "Variants")

const ghost_anchor = Anchor(id: "ghost", label: "Ghost")

const outline_anchor = Anchor(id: "outline", label: "Outline")

const filled_anchor = Anchor(id: "filled", label: "Filled")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      ghost_anchor,
      outline_anchor,
      filled_anchor,
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
        "Three visual styles to cover anything from a quiet borderless list to
        a high-emphasis filled group.",
      ),
    ]),

    // --- Ghost ---------------------------------------------------------------
    content.SectionExample(
      anchor: ghost_anchor,
      description: [
        content.Text(
          "Borderless rows separated by a hairline, quiet enough to drop into
          running prose.",
        ),
      ],
      code: accordion.ghost_html,
      body: [ghost.view()],
    ),

    // --- Outline -------------------------------------------------------------
    content.SectionExample(
      anchor: outline_anchor,
      description: [
        content.Text(
          "Bordered rows collapsed into a single outlined group, no fill.
          Visible without competing with the page.",
        ),
      ],
      code: accordion.outline_html,
      body: [outline.view()],
    ),

    // --- Filled --------------------------------------------------------------
    content.SectionExample(
      anchor: filled_anchor,
      description: [
        content.Text(
          "Bordered, filled rows collapsed into a single group. Solid enough
          to stand as a section of its own.",
        ),
      ],
      code: accordion.filled_html,
      body: [filled.view()],
    ),
  ])
}
