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
        "Six variant attributes, one per semantic intent.
        Pass one into the root's attribute list.",
      ),
    ]),
    content.Table(headers: ["Variant", "Description"], rows: [
      [
        content.signature_cell("alert.info()"),
        content.text_cell("Informational note for non-urgent messages."),
      ],
      [
        content.signature_cell("alert.success()"),
        content.text_cell("Positive confirmation for a completed action."),
      ],
      [
        content.signature_cell("alert.warning()"),
        content.text_cell("Caution required, not yet failing."),
      ],
      [
        content.signature_cell("alert.error()"),
        content.text_cell("A failure that requires user attention."),
      ],
      [
        content.signature_cell("alert.accent()"),
        content.text_cell(
          "Brand-aligned promotional alert for feature announcements.",
        ),
      ],
      [
        content.signature_cell("alert.neutral()"),
        content.text_cell(
          "The default quiet surface for in-doc callouts and tips.",
        ),
      ],
    ]),

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
        content.signature_cell("alert.root(attrs, children)"),
        content.text_cell(
          "The root container. Holds the slots and carries the variant
          attribute.",
        ),
      ],
      [
        content.signature_cell("alert.icon(attrs, children)"),
        content.text_cell(
          "Leading icon tile. Inherits color and background from variant.",
        ),
      ],
      [
        content.signature_cell("alert.title(attrs, children)"),
        content.text_cell("Short, bold heading for the alert."),
      ],
      [
        content.signature_cell("alert.description(attrs, children)"),
        content.text_cell("Supporting text under the title."),
      ],
      [
        content.signature_cell("alert.actions(attrs, children)"),
        content.text_cell(
          "Trailing element under the description for inline action buttons.",
        ),
      ],
      [
        content.signature_cell("alert.close(attrs, children)"),
        content.text_cell("Trailing close button for dismissible alerts."),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text("Pass these into the root's attribute list."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("alert.banner()"),
        content.text_cell(
          "Squares the corners and keeps only the bottom border so the alert
          spans its container edge-to-edge.",
        ),
      ],
      [
        content.signature_cell("attribute.role(\"status\")"),
        content.text_cell(
          "Announces info and success alerts politely when they're inserted
          dynamically.",
        ),
      ],
      [
        content.signature_cell("attribute.role(\"alert\")"),
        content.text_cell(
          "Announces warning and error alerts assertively, interrupting the
          current utterance.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the alert's markup, available for overriding or
        layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"alert\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell("[data-variant=\"info|success|...\"]"),
        content.text_cell("The root, tagged with its active semantic variant."),
      ],
      [
        content.selector_cell("[data-style=\"banner\"]"),
        content.text_cell(
          "The root, tagged when the banner attribute is applied.",
        ),
      ],
      [
        content.selector_cell("[data-slot=\"alert-icon\"]"),
        content.text_cell("Leading icon tile."),
      ],
      [
        content.selector_cell("[data-slot=\"alert-title\"]"),
        content.text_cell("Heading inside the alert."),
      ],
      [
        content.selector_cell("[data-slot=\"alert-description\"]"),
        content.text_cell("Supporting text inside the alert."),
      ],
      [
        content.selector_cell("[data-slot=\"alert-actions\"]"),
        content.text_cell("Trailing row of inline action buttons."),
      ],
      [
        content.selector_cell("[data-slot=\"alert-close\"]"),
        content.text_cell("Trailing close button."),
      ],
    ]),
  ])
}
