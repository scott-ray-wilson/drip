import docs/content.{type Block}
import docs/generated/example/button_group
import docs/page/button_group/example/horizontal
import docs/page/button_group/example/nested
import docs/page/button_group/example/separator
import docs/page/button_group/example/text_field
import docs/page/button_group/example/vertical
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const horizontal_anchor = Anchor(id: "horizontal", label: "Horizontal")

const vertical_anchor = Anchor(id: "vertical", label: "Vertical")

const separator_anchor = Anchor(id: "separator", label: "Separator")

const nested_anchor = Anchor(id: "nested", label: "Nested")

const text_field_anchor = Anchor(id: "text-field", label: "Text Field")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      horizontal_anchor,
      vertical_anchor,
      separator_anchor,
      nested_anchor,
      text_field_anchor,
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
        "Lay a group out horizontally or vertically, then extend it with
        separators, nested groups, and inputs.",
      ),
    ]),

    // --- Horizontal ----------------------------------------------------------
    content.SectionExample(
      anchor: horizontal_anchor,
      description: [
        content.Text(
          "Arrange buttons in a row sharing vertical borders using the horizontal
          attribute.",
        ),
      ],
      code: button_group.horizontal_html,
      body: [horizontal.view()],
    ),

    // --- Vertical ------------------------------------------------------------
    content.SectionExample(
      anchor: vertical_anchor,
      description: [
        content.Text(
          "Stack buttons into a column sharing horizontal borders using the
          vertical attribute.",
        ),
      ],
      code: button_group.vertical_html,
      body: [vertical.view()],
    ),

    // --- Separator -----------------------------------------------------------
    content.SectionExample(
      anchor: separator_anchor,
      description: [
        content.Text(
          "Add a divider between buttons to separate related controls.",
        ),
      ],
      code: button_group.separator_html,
      body: [separator.view()],
    ),

    // --- Nested --------------------------------------------------------------
    content.SectionExample(
      anchor: nested_anchor,
      description: [
        content.Text(
          "Nest button groups inside a parent group to split actions into
          clusters.",
        ),
      ],
      code: button_group.nested_html,
      body: [nested.view()],
    ),

    // --- Text Field ----------------------------------------------------------
    content.SectionExample(
      anchor: text_field_anchor,
      description: [
        content.Text(
          "Combine a text field with a button to build a search field or inline
          action.",
        ),
      ],
      code: button_group.text_field_html,
      body: [text_field.view()],
    ),
  ])
}
