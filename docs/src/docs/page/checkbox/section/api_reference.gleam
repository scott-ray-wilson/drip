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
      content.Text("A single element wrapping a native input."),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("checkbox.input(attrs)"),
        content.text_cell(
          "Renders the native input with a layered check indicator.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes the checkbox responds to. Pass them through
        the input's attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.checked(True)"),
        content.text_cell("Renders the filled surface and check glyph."),
      ],
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell(
          "Locks the checkbox, dims it, and removes it from the focus order.",
        ),
      ],
      [
        content.signature_cell("attribute.required(True)"),
        content.text_cell(
          "Marks the checkbox as required and reveals the field label's
          indicator.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "Surfaces the destructive border and ring on validation failure.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the checkbox's markup, available for overriding
        or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"checkbox\"]"),
        content.text_cell("The root container wrapping the input."),
      ],
      [
        content.selector_cell("[data-slot=\"checkbox\"] > input"),
        content.text_cell("The native input control."),
      ],
      [
        content.selector_cell("[data-slot=\"checkbox\"] > input:checked"),
        content.text_cell("The input in its checked state."),
      ],
      [
        content.selector_cell("[data-slot=\"checkbox\"] > input:disabled"),
        content.text_cell("The input when locked."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"checkbox\"] > input[aria-invalid=\"true\"]",
        ),
        content.text_cell("The input flagged with a validation failure."),
      ],
      [
        content.selector_cell("[data-slot=\"checkbox-indicator\"]"),
        content.text_cell("The check icon layered over the input."),
      ],
    ]),
  ])
}
