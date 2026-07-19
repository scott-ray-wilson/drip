import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const elements_anchor = Anchor(id: "elements-api", label: "Elements")

const size_anchor = Anchor(id: "size-attributes-api", label: "Size Attributes")

const attributes_anchor = Anchor(id: "attributes-api", label: "Attributes")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      elements_anchor,
      size_anchor,
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
        "A single element wrapping a native input so the thumb can layer on
        top.",
      ),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("switch.input(attrs)"),
        content.text_cell(
          "Renders the track, the native input, and the sliding thumb.",
        ),
      ],
    ]),

    // --- Size Attributes -----------------------------------------------------
    content.Subheading(size_anchor),
    content.Paragraph([
      content.Text("Adjusts the track and thumb dimensions."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("switch.sm()"),
        content.text_cell(
          "Small, for dense toolbars, table rows, and inline controls.",
        ),
      ],
      [
        content.signature_cell("switch.md()"),
        content.text_cell(
          "Medium, the default; matches a switch with no size attribute.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes the switch responds to. Pass them through
        the input's attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.checked(True)"),
        content.text_cell(
          "Fills the track with the primary surface and slides the thumb to the
          on edge.",
        ),
      ],
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell(
          "Locks the switch, dims it, and removes it from the focus order.",
        ),
      ],
      [
        content.signature_cell("attribute.required(True)"),
        content.text_cell(
          "Marks the switch as required and reveals the field label's
          indicator.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "Surfaces the destructive border and ring on validation failure.",
        ),
      ],
      [
        content.signature_cell("attribute.name(\"notifications\")"),
        content.text_cell("Form field name submitted with the parent form."),
      ],
      [
        content.signature_cell("attribute.value(\"enabled\")"),
        content.text_cell("Submitted value when checked. Defaults to \"on\"."),
      ],
      [
        content.signature_cell("attribute.id(\"notifications\")"),
        content.text_cell(
          "Pair with field.label's for attribute to extend the click target.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the switch's markup, available for overriding
        or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"switch\"]"),
        content.text_cell("The root container wrapping the input and thumb."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"switch\"]:has(> input[data-size=\"sm|md\"])",
        ),
        content.text_cell("The root, tagged with its active size."),
      ],
      [
        content.selector_cell("[data-slot=\"switch\"] > input"),
        content.text_cell("The native input control."),
      ],
      [
        content.selector_cell("[data-slot=\"switch\"]:has(> input:checked)"),
        content.text_cell("The root, when its input is checked."),
      ],
      [
        content.selector_cell("[data-slot=\"switch\"]:has(> input:disabled)"),
        content.text_cell("The root, when locked."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"switch\"]:has(> input[aria-invalid=\"true\"])",
        ),
        content.text_cell("The root, flagged with a validation failure."),
      ],
      [
        content.selector_cell("[data-slot=\"switch-thumb\"]"),
        content.text_cell("The thumb that slides across the track."),
      ],
    ]),
  ])
}
