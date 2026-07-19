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
      content.Text("The group wrapper and the radio items it contains."),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("radio_group.root(attrs, children)"),
        content.text_cell(
          "Wraps the radio items and applies role=\"radiogroup\".",
        ),
      ],
      [
        content.signature_cell("radio_group.item(attrs)"),
        content.text_cell(
          "Renders a native radio input with a layered dot indicator.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes the radio group responds to. Pass them
        through the attribute list of each item unless noted otherwise.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.name(\"plan\")"),
        content.text_cell(
          "Form field name shared by every item in the group; the browser
          enforces mutual exclusion.",
        ),
      ],
      [
        content.signature_cell("attribute.value(\"monthly\")"),
        content.text_cell("Value submitted when this item is the selected one."),
      ],
      [
        content.signature_cell("attribute.checked(True)"),
        content.text_cell(
          "Marks the item as the selected option; fills the primary surface and
          shows the inner dot.",
        ),
      ],
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell(
          "Locks the item, dims it, and removes it from the focus order.",
        ),
      ],
      [
        content.signature_cell("attribute.required(True)"),
        content.text_cell(
          "Marks the item as required; field.label surfaces an accent asterisk.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "Surfaces the destructive border and ring on validation failure.",
        ),
      ],
      [
        content.signature_cell("attribute.id(\"plan-monthly\")"),
        content.text_cell(
          "Pair with field.label's for attribute to extend the click target and
          announce the label.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_label(\"...\")"),
        content.text_cell(
          "Gives the group its accessible name; passes into the root's
          attribute list. The radiogroup role is only reliably announced when
          the group is named.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_labelledby(\"...\")"),
        content.text_cell(
          "Names the group from a visible element instead, such as a field set
          legend's id.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the radio group's markup, available for
        overriding or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"radio-group\"]"),
        content.text_cell("The root container."),
      ],
      [
        content.selector_cell("[data-slot=\"radio-group-item\"]"),
        content.text_cell("The wrapping span around each input."),
      ],
      [
        content.selector_cell("[data-slot=\"radio-group-item\"] > input"),
        content.text_cell("The native <input type=\"radio\">."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"radio-group-item\"] > input:checked",
        ),
        content.text_cell("A selected item."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"radio-group-item\"] > input:disabled",
        ),
        content.text_cell("A locked item."),
      ],
      [
        content.selector_cell(
          "[data-slot=\"radio-group-item\"] > input[aria-invalid=\"true\"]",
        ),
        content.text_cell("An item in a validation-failure state."),
      ],
      [
        content.selector_cell("[data-slot=\"radio-group-indicator\"]"),
        content.text_cell("The dot layered over the selected item."),
      ],
    ]),
  ])
}
