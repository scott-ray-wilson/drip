import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const attributes_anchor = Anchor(id: "attributes-api", label: "Attributes")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      elements_anchor,
      attributes_anchor,
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
        "The root constructor plus the elements that compose its body.
        Each takes a list of attributes and a list of children.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("table.root(attrs, children)"),
        content.text_cell(
          "Root table wrapped in a horizontally scrollable container.",
        ),
      ],
      [
        content.signature_cell("table.header(attrs, children)"),
        content.text_cell("Header section. Carries the muted surface tint."),
      ],
      [
        content.signature_cell("table.body(attrs, children)"),
        content.text_cell("Body section. Holds the data rows."),
      ],
      [
        content.signature_cell("table.footer(attrs, children)"),
        content.text_cell("Footer section. Used for totals or summary rows."),
      ],
      [
        content.signature_cell("table.row(attrs, children)"),
        content.text_cell(
          "Row. Body rows highlight on hover and support a selected data
          state.",
        ),
      ],
      [
        content.signature_cell("table.head(attrs, children)"),
        content.text_cell("Header cell. Uppercase, tracked, muted."),
      ],
      [
        content.signature_cell("table.cell(attrs, children)"),
        content.text_cell("Data cell for body and footer rows."),
      ],
      [
        content.signature_cell("table.caption(attrs, children)"),
        content.text_cell(
          "Optional summary. First child of the table, rendered beneath it.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes a table row responds to. Pass them through
        the attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.data(\"state\", \"selected\")"),
        content.text_cell(
          "Marks the row as selected with a persistent muted fill.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the table's markup, available for overriding or
        layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"table-container\"]"),
        content.text_cell(
          "The horizontally scrollable wrapper around the table.",
        ),
      ],
      [
        content.selector_cell("[data-slot=\"table\"]"),
        content.text_cell("The root table element."),
      ],
      [
        content.selector_cell("[data-slot=\"table-header\"]"),
        content.text_cell("The thead section."),
      ],
      [
        content.selector_cell("[data-slot=\"table-body\"]"),
        content.text_cell("The tbody section."),
      ],
      [
        content.selector_cell("[data-slot=\"table-footer\"]"),
        content.text_cell("The tfoot section."),
      ],
      [
        content.selector_cell("[data-slot=\"table-row\"]"),
        content.text_cell("Each row (the tr element)."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"table-row\"][data-state=\"selected\"]",
        ),
        content.text_cell("A row marked as selected."),
      ],
      [
        content.selector_cell("[data-slot=\"table-head\"]"),
        content.text_cell("Each header cell (the th element)."),
      ],
      [
        content.selector_cell("[data-slot=\"table-cell\"]"),
        content.text_cell("Each data cell (the td element)."),
      ],
      [
        content.selector_cell("[data-slot=\"table-caption\"]"),
        content.text_cell("The caption rendered beneath the table."),
      ],
    ]),
  ])
}
