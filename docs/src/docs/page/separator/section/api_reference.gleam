import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const orientation_anchor = Anchor(
  id: "orientation-attributes-api",
  label: "Orientation Attributes",
)

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      orientation_anchor,
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

    // --- Orientation Attributes ----------------------------------------------
    content.Subheading(orientation_anchor),
    content.Paragraph([
      content.Text(
        "Two orientation attributes, one per axis. Pass one into the root's
        attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("separator.horizontal()"),
        content.text_cell(
          "Lays the rule along the inline axis, filling the parent's width; the
          default when no orientation attribute is set.",
        ),
      ],
      [
        content.signature_cell("separator.vertical()"),
        content.text_cell(
          "Lays the rule along the block axis, stretching to fill the parent's
          height; requires a flex parent so the stretch can resolve.",
        ),
      ],
    ]),

    // --- Elements ------------------------------------------------------------
    content.Subheading(elements_anchor),
    content.Paragraph([
      content.Text(
        "A single root element. Children are optional; most separators are plain
        rules.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("separator.root(attrs, children)"),
        content.text_cell(
          "The separator rule. Pass children to render centered content over the
          line.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the separator's markup, available for
        overriding or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"separator\"]"),
        content.text_cell("The separator root."),
      ],
      [
        content.selector_cell("[data-orientation=\"horizontal|vertical\"]"),
        content.text_cell(
          "The root, tagged when an orientation attribute is applied.",
        ),
      ],
      [
        content.selector_cell("[data-content=\"true\"]"),
        content.text_cell("The root, tagged when centered content is present."),
      ],
      [
        content.selector_cell("[data-slot=\"separator-content\"]"),
        content.text_cell("The wrapper around centered content."),
      ],
    ]),
  ])
}
