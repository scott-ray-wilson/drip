import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const size_anchor = Anchor(id: "size-attributes-api", label: "Size Attributes")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      elements_anchor,
      size_anchor,
      selectors_anchor,
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

    // --- Elements ------------------------------------------------------------
    content.Subheading(elements_anchor),
    content.Paragraph([
      content.Text(
        "The root container and the composable child elements that fill its
        regions.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("card.root(attrs, children)"),
        content.text_cell("The surface container that wraps the card's slots."),
      ],
      [
        content.signature_cell("card.header(attrs, children)"),
        content.text_cell(
          "Top region. Hosts the eyebrow, title, description, and action.",
        ),
      ],
      [
        content.signature_cell("card.eyebrow(attrs, children)"),
        content.text_cell("Small uppercase label rendered above the title."),
      ],
      [
        content.signature_cell("card.title(attrs, children)"),
        content.text_cell("Primary heading inside the header."),
      ],
      [
        content.signature_cell("card.description(attrs, children)"),
        content.text_cell("Secondary supporting text inside the header."),
      ],
      [
        content.signature_cell("card.action(attrs, children)"),
        content.text_cell(
          "Trailing control in the header, aligned opposite the title.",
        ),
      ],
      [
        content.signature_cell("card.content(attrs, children)"),
        content.text_cell("Main body region."),
      ],
      [
        content.signature_cell("card.footer(attrs, children)"),
        content.text_cell(
          "Bottom region. A bordered, tinted bar for actions or summary text.",
        ),
      ],
    ]),

    // --- Size Attributes -----------------------------------------------------
    content.Subheading(size_anchor),
    content.Paragraph([
      content.Text("Adjusts the card's padding and title scale."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("card.sm()"),
        content.text_cell("Small, with tighter padding and a smaller title."),
      ],
      [
        content.signature_cell("card.md()"),
        content.text_cell(
          "Medium, the default; matches a card with no size attribute.",
        ),
      ],
      [
        content.signature_cell("card.lg()"),
        content.text_cell("Large, with roomier padding and a larger title."),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the card's markup, available for overriding or
        layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"card\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell("[data-size=\"sm|md|lg\"]"),
        content.text_cell("The root, tagged with its active size."),
      ],
      [
        content.selector_cell("[data-slot=\"card-header\"]"),
        content.text_cell("Top region of the card."),
      ],
      [
        content.selector_cell("[data-slot=\"card-eyebrow\"]"),
        content.text_cell("Uppercase label above the title."),
      ],
      [
        content.selector_cell("[data-slot=\"card-title\"]"),
        content.text_cell("Primary heading inside the header."),
      ],
      [
        content.selector_cell("[data-slot=\"card-description\"]"),
        content.text_cell("Supporting text inside the header."),
      ],
      [
        content.selector_cell("[data-slot=\"card-action\"]"),
        content.text_cell("Trailing control in the header."),
      ],
      [
        content.selector_cell("[data-slot=\"card-content\"]"),
        content.text_cell("Main body region."),
      ],
      [
        content.selector_cell("[data-slot=\"card-footer\"]"),
        content.text_cell("Bottom bar for actions or summary text."),
      ],
    ]),
  ])
}
