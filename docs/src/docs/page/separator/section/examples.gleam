import docs/content.{type Block}
import docs/generated/example/separator
import docs/page/separator/example/content as content_example
import docs/page/separator/example/horizontal
import docs/page/separator/example/vertical
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const horizontal_anchor = Anchor(id: "horizontal", label: "Horizontal")

const vertical_anchor = Anchor(id: "vertical", label: "Vertical")

const content_anchor = Anchor(id: "content", label: "Content")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      horizontal_anchor,
      vertical_anchor,
      content_anchor,
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
        "Set the rule's axis with the orientation attributes, or break the line
        with centered content.",
      ),
    ]),

    // --- Horizontal ----------------------------------------------------------
    content.SectionExample(
      anchor: horizontal_anchor,
      description: [
        content.Text(
          "Pass the horizontal attribute to lay the rule across the parent's
          inline width. This is the default orientation.",
        ),
      ],
      code: separator.horizontal_html,
      body: [horizontal.view()],
    ),

    // --- Vertical ------------------------------------------------------------
    content.SectionExample(
      anchor: vertical_anchor,
      description: [
        content.Text(
          "Pass the vertical attribute to stretch the rule to the parent's block
          height.",
        ),
      ],
      code: separator.vertical_html,
      body: [vertical.view()],
    ),

    // --- Content -------------------------------------------------------------
    content.SectionExample(
      anchor: content_anchor,
      description: [
        content.Text(
          "Pass children to the separator to render centered content over the
          line.",
        ),
      ],
      code: separator.content_html,
      body: [content_example.view()],
    ),
  ])
}
