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
        "The root container and the separator slot that compose the inside of a
        group.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("button_group.root(attrs, children)"),
        content.text_cell(
          "The root container. Carries the group role and the orientation
          attribute.",
        ),
      ],
      [
        content.signature_cell("button_group.separator(attrs)"),
        content.text_cell(
          "Divider that breaks a group into clusters of buttons.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Pass these into the root's attribute list. The orientation defaults to
        horizontal.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("button_group.horizontal()"),
        content.text_cell(
          "A row of related buttons that share vertical borders.",
        ),
      ],
      [
        content.signature_cell("button_group.vertical()"),
        content.text_cell(
          "A stack of related buttons that share horizontal borders.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_label(\"...\")"),
        content.text_cell(
          "Gives the group its accessible name. The group role is only reliably
          announced when the group is named.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the button group's markup, available for
        overriding or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"button-group\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"button-group\"][data-orientation=\"...\"]",
        ),
        content.text_cell("The root, tagged with its active orientation."),
      ],
      [
        content.selector_cell("[data-slot=\"button-group-separator\"]"),
        content.text_cell("The divider between two children."),
      ],
    ]),
  ])
}
