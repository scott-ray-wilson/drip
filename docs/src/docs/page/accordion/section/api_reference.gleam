import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const variants_anchor = Anchor(id: "variants-api", label: "Variants")

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const attributes_anchor = Anchor(id: "attributes-api", label: "Attributes")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      variants_anchor,
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

    // --- Variants ------------------------------------------------------------
    content.Subheading(variants_anchor),
    content.Paragraph([
      content.Text(
        "Sets the accordion's visual style. Pass one into the root's attribute
        list.",
      ),
    ]),
    content.Table(headers: ["Variant", "Description"], rows: [
      [
        content.signature_cell("accordion.ghost()"),
        content.text_cell(
          "The default borderless stack with hairline separators between rows.",
        ),
      ],
      [
        content.signature_cell("accordion.outline()"),
        content.text_cell(
          "Bordered rows collapsed into a single outlined group, no fill.",
        ),
      ],
      [
        content.signature_cell("accordion.filled()"),
        content.text_cell(
          "Bordered, filled rows collapsed into a single group.",
        ),
      ],
    ]),

    // --- Elements ------------------------------------------------------------
    content.Subheading(elements_anchor),
    content.Paragraph([
      content.Text(
        "The root container and the composition elements that nest inside it.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("accordion.root(attrs, children)"),
        content.text_cell(
          "The root container. Holds the items and carries the variant
          attribute.",
        ),
      ],
      [
        content.signature_cell("accordion.item(attrs, children)"),
        content.text_cell("A single collapsible row."),
      ],
      [
        content.signature_cell("accordion.trigger(attrs, children)"),
        content.text_cell(
          "Clickable row header. Toggles its parent item open or closed.",
        ),
      ],
      [
        content.signature_cell("accordion.content(attrs, children)"),
        content.text_cell(
          "Body of a row, revealed when its parent item is open.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes an accordion item responds to. Pass them
        through the attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.open(True)"),
        content.text_cell("Defaults the item to its expanded state."),
      ],
      [
        content.signature_cell("attribute.name(\"faq\")"),
        content.text_cell(
          "Groups items into an exclusive set; opening one closes the others.",
        ),
      ],
      [
        content.signature_cell("attribute.inert(True)"),
        content.text_cell(
          "Disables all interaction with the row and mutes it visually.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the accordion's markup, available for
        overriding or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"accordion\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell("[data-variant=\"ghost|outline|filled\"]"),
        content.text_cell("The root, tagged with its active variant."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-item\"]"),
        content.text_cell("Each row (the details element)."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-item\"][open]"),
        content.text_cell("An expanded row."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-item\"][inert]"),
        content.text_cell("A muted, non-interactive row."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-trigger\"]"),
        content.text_cell("The clickable row header (the summary element)."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-trigger-icon\"]"),
        content.text_cell("The chevron appended to the end of every trigger."),
      ],
      [
        content.selector_cell("[data-slot=\"accordion-content\"]"),
        content.text_cell("The body revealed when its row is open."),
      ],
    ]),
  ])
}
