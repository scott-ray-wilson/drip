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

const attributes_anchor = Anchor(id: "attributes-api", label: "Attributes")

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      orientation_anchor,
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

    // --- Orientation Attributes ----------------------------------------------
    content.Subheading(orientation_anchor),
    content.Paragraph([
      content.Text(
        "Three orientation attributes for the field root, one per layout. Pass
        one into the root's attribute list.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("field.vertical()"),
        content.text_cell(
          "Label stacked above the control; the default when no orientation
          attribute is set.",
        ),
      ],
      [
        content.signature_cell("field.horizontal()"),
        content.text_cell("Label inline beside the control."),
      ],
      [
        content.signature_cell("field.responsive()"),
        content.text_cell(
          "Vertical until the parent field group reaches a minimum width, then
          horizontal.",
        ),
      ],
    ]),

    // --- Elements ------------------------------------------------------------
    content.Subheading(elements_anchor),
    content.Paragraph([
      content.Text("Composition slots used inside a field root."),
    ]),
    content.Table(headers: ["Element", "Description"], rows: [
      [
        content.signature_cell("field.root(attrs, children)"),
        content.text_cell("The field root."),
      ],
      [
        content.signature_cell("field.label(attrs, children)"),
        content.text_cell(
          "Renders a label bound to a control via the for attribute.",
        ),
      ],
      [
        content.signature_cell("field.title(attrs, children)"),
        content.text_cell(
          "Heading for a field whose wrapping label already binds the control,
          as in a checkbox or radio card.",
        ),
      ],
      [
        content.signature_cell("field.description(attrs, children)"),
        content.text_cell("Helper text rendered below the control."),
      ],
      [
        content.signature_cell("field.error(attrs, children)"),
        content.text_cell("Validation message with role=\"alert\"."),
      ],
      [
        content.signature_cell("field.content(attrs, children)"),
        content.text_cell(
          "Wraps a label and description in a horizontal field.",
        ),
      ],
      [
        content.signature_cell("field.group(attrs, children)"),
        content.text_cell("Stacks fields with consistent spacing."),
      ],
      [
        content.signature_cell("field.set(attrs, children)"),
        content.text_cell(
          "Wrapper that binds related fields together for screen readers.",
        ),
      ],
      [
        content.signature_cell("field.legend(attrs, children)"),
        content.text_cell("Native legend, sized for section headings."),
      ],
      [
        content.signature_cell("field.legend_label(attrs, children)"),
        content.text_cell("Native legend, sized to match a field label."),
      ],
      [
        content.signature_cell("field.separator(attrs, children)"),
        content.text_cell(
          "Horizontal divider between fields. Children render as a centered
          label over the line.",
        ),
      ],
    ]),

    // --- Attributes ----------------------------------------------------------
    content.Subheading(attributes_anchor),
    content.Paragraph([
      content.Text(
        "Standard Lustre attributes the field responds to. Pass them on the
        inner control or label.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.for(\"id\")"),
        content.text_cell(
          "On field label, binds the label to the control's id.",
        ),
      ],
      [
        content.signature_cell("attribute.required(True)"),
        content.text_cell(
          "On the inner control, surfaces an accent asterisk on the surrounding
          label.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "On the inner control, surfaces its error ring; pair with a field
          error to announce the validation message.",
        ),
      ],
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell("On the inner control, dims the surrounding label."),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the field's markup, available for overriding or
        layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"field\"]"),
        content.text_cell("A field root."),
      ],
      [
        content.selector_cell("[data-orientation=\"vertical|horizontal|...\"]"),
        content.text_cell("The field root, tagged with its active orientation."),
      ],
      [
        content.selector_cell("[data-slot=\"field-label\"]"),
        content.text_cell("A field label or title."),
      ],
      [
        content.selector_cell("[data-slot=\"field-required\"]"),
        content.text_cell(
          "The accent asterisk surfaced when a control is required.",
        ),
      ],
      [
        content.selector_cell("[data-slot=\"field-description\"]"),
        content.text_cell("The helper text below the control."),
      ],
      [
        content.selector_cell("[data-slot=\"field-error\"]"),
        content.text_cell("The validation message."),
      ],
      [
        content.selector_cell("[data-slot=\"field-content\"]"),
        content.text_cell("The label/description block in a horizontal field."),
      ],
      [
        content.selector_cell("[data-slot=\"field-group\"]"),
        content.text_cell("A group wrapper, also the container-query root."),
      ],
      [
        content.selector_cell("[data-slot=\"field-set\"]"),
        content.text_cell("The native fieldset wrapper."),
      ],
      [
        content.selector_cell("[data-slot=\"field-legend\"]"),
        content.text_cell("The native legend."),
      ],
      [
        content.selector_cell("[data-variant=\"legend|label\"]"),
        content.text_cell(
          "The legend, tagged for section heading vs label sizing.",
        ),
      ],
      [
        content.selector_cell(
          "[data-slot=\"separator\"][data-variant=\"field\"]",
        ),
        content.text_cell("A separator between groups of fields."),
      ],
    ]),
  ])
}
