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
        "A single input control, no children. Type, value, and validation state
        all come from the attributes you pass in.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("text_field.input(attrs)"),
        content.text_cell(
          "Standalone text input. Renders a native input element.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes and events the text field responds to. Pass
        them through the attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.type_(...)"),
        content.text_cell(
          "Native input type: \"text\", \"email\", \"password\", etc.",
        ),
      ],
      [
        content.signature_cell("attribute.value(...)"),
        content.text_cell(
          "Controlled value. Pair with event.on_input to handle keystrokes.",
        ),
      ],
      [
        content.signature_cell("event.on_input(...)"),
        content.text_cell(
          "Message dispatched on every keystroke with the current value.",
        ),
      ],
      [
        content.signature_cell("attribute.placeholder(...)"),
        content.text_cell("Placeholder text shown when the value is empty."),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "Surfaces the validation state: destructive border and error ring.",
        ),
      ],
      [
        content.signature_cell("attribute.required(True)"),
        content.text_cell(
          "Marks the input as required; field.label surfaces an indicator.",
        ),
      ],
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell(
          "Locks the input, blocks pointer events, and reduces opacity.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the input's markup, available for overriding or
        layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"text-field\"]"),
        content.text_cell("The standalone text field."),
      ],
      [
        content.selector_cell("[data-slot=\"text-field\"]:focus-visible"),
        content.text_cell("A focused text field, showing its focus outline."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"text-field\"][aria-invalid=\"true\"]",
        ),
        content.text_cell("A text field in its validation-failure state."),
      ],
      [
        content.selector_cell("[data-slot=\"text-field\"]:disabled"),
        content.text_cell("A locked, non-interactive text field."),
      ],
    ]),
  ])
}
