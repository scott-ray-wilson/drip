import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const variants_anchor = Anchor(id: "variants-api", label: "Variants")

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      variants_anchor,
      elements_anchor,
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

    // --- Variants ------------------------------------------------------------
    content.Subheading(variants_anchor),
    content.Paragraph([
      content.Text(
        "Sets how the container is framed. Pass one into the root's attribute
        list.",
      ),
    ]),
    content.Table(headers: ["Variant", "Description"], rows: [
      [
        content.signature_cell("empty.ghost()"),
        content.text_cell(
          "The default borderless surface, for empty states a card or panel
          already frames.",
        ),
      ],
      [
        content.signature_cell("empty.outline()"),
        content.text_cell("Frames the surface with a dashed border."),
      ],
    ]),

    // --- Elements ------------------------------------------------------------
    content.Subheading(elements_anchor),
    content.Paragraph([
      content.Text("The root element and slots that compose its body."),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("empty.root(attrs, children)"),
        content.text_cell("Surface container."),
      ],
      [
        content.signature_cell("empty.header(attrs, children)"),
        content.text_cell(
          "Top region grouping the optional media or icon, title, and
          description.",
        ),
      ],
      [
        content.signature_cell("empty.media(attrs, children)"),
        content.text_cell(
          "Transparent slot for illustrations or larger imagery.",
        ),
      ],
      [
        content.signature_cell("empty.icon(attrs, children)"),
        content.text_cell(
          "Tinted square tile sized for a single decorative icon.",
        ),
      ],
      [
        content.signature_cell("empty.title(attrs, children)"),
        content.text_cell("Primary heading inside the header."),
      ],
      [
        content.signature_cell("empty.description(attrs, children)"),
        content.text_cell("Secondary supporting text inside the header."),
      ],
      [
        content.signature_cell("empty.content(attrs, children)"),
        content.text_cell(
          "Body region below the header for actions, links, or supporting copy.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the empty state's markup, available for
        overriding or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"empty\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"empty\"][data-variant=\"ghost|outline\"]",
        ),
        content.text_cell("The root, tagged with its active framing."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-header\"]"),
        content.text_cell("The header region of the container."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-media\"]"),
        content.text_cell("The transparent media slot."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-icon\"]"),
        content.text_cell("The tinted square media slot."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-title\"]"),
        content.text_cell("The title row inside the header."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-description\"]"),
        content.text_cell("The description row inside the header."),
      ],
      [
        content.selector_cell("[data-slot=\"empty-content\"]"),
        content.text_cell("The content region below the header."),
      ],
    ]),
  ])
}
