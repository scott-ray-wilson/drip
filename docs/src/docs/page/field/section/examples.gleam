import docs/content.{type Block}
import docs/generated/example/field
import docs/page/field/example/checkbox
import docs/page/field/example/disabled
import docs/page/field/example/group_stacked
import docs/page/field/example/input
import docs/page/field/example/invalid
import docs/page/field/example/radio_card
import docs/page/field/example/radio_group
import docs/page/field/example/required
import docs/page/field/example/separator
import docs/page/field/example/set_legend
import docs/page/field/example/switch
import docs/page/field/example/text_area
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const text_field_anchor = Anchor(id: "input", label: "Text Field")

const text_area_anchor = Anchor(id: "textarea", label: "Text Area")

const checkbox_anchor = Anchor(id: "checkbox", label: "Checkbox")

const switch_anchor = Anchor(id: "switch", label: "Switch")

const radio_group_anchor = Anchor(id: "radio-group", label: "Radio Group")

const radio_card_anchor = Anchor(id: "radio-card", label: "Radio Card")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

const required_anchor = Anchor(id: "required", label: "Required")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

const group_anchor = Anchor(id: "group", label: "Group")

const set_anchor = Anchor(id: "set", label: "Set & Legend")

const separator_anchor = Anchor(id: "separator", label: "Separator")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      text_field_anchor,
      text_area_anchor,
      checkbox_anchor,
      switch_anchor,
      radio_group_anchor,
      radio_card_anchor,
      invalid_anchor,
      required_anchor,
      disabled_anchor,
      group_anchor,
      set_anchor,
      separator_anchor,
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
        "Pair any control with a label and description, group related fields, and
        surface validation errors.",
      ),
    ]),

    // --- Text Field ----------------------------------------------------------
    content.SectionExample(
      anchor: text_field_anchor,
      description: [
        content.Text(
          "Stack a label, text field, and description inside a field with the
          vertical attribute.",
        ),
      ],
      code: field.input_html,
      body: [input.view()],
    ),

    // --- Text Area -----------------------------------------------------------
    content.SectionExample(
      anchor: text_area_anchor,
      description: [
        content.Text(
          "Capture multi-line input in a text area with the vertical attribute.",
        ),
      ],
      code: field.text_area_html,
      body: [text_area.view()],
    ),

    // --- Checkbox ------------------------------------------------------------
    content.SectionExample(
      anchor: checkbox_anchor,
      description: [
        content.Text(
          "Set a checkbox inline with its label using the horizontal attribute.",
        ),
      ],
      code: field.checkbox_html,
      body: [checkbox.view()],
    ),

    // --- Switch --------------------------------------------------------------
    content.SectionExample(
      anchor: switch_anchor,
      description: [
        content.Text(
          "Pair a switch with an inline label using the horizontal attribute.",
        ),
      ],
      code: field.switch_html,
      body: [switch.view()],
    ),

    // --- Radio Group ---------------------------------------------------------
    content.SectionExample(
      anchor: radio_group_anchor,
      description: [
        content.Text(
          "Nest horizontal fields inside a radio group so each option pairs with
          a field label.",
        ),
      ],
      code: field.radio_group_html,
      body: [radio_group.view()],
    ),

    // --- Radio Card ----------------------------------------------------------
    content.SectionExample(
      anchor: radio_card_anchor,
      description: [
        content.Text(
          "Wrap a field root in a label to turn each option into a selection
          card.",
        ),
      ],
      code: field.radio_card_html,
      body: [radio_card.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Set aria-invalid on the control and add a field error element to
          surface validation errors.",
        ),
      ],
      code: field.invalid_html,
      body: [invalid.view()],
    ),

    // --- Required ------------------------------------------------------------
    content.SectionExample(
      anchor: required_anchor,
      description: [
        content.Text(
          "Mark the control required and the surrounding label will surface an
          accent asterisk.",
        ),
      ],
      code: field.required_html,
      body: [required.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Disable the control with the disabled attribute to block input and dim
          the surrounding label.",
        ),
      ],
      code: field.disabled_html,
      body: [disabled.view()],
    ),

    // --- Group ---------------------------------------------------------------
    content.SectionExample(
      anchor: group_anchor,
      description: [
        content.Text(
          "Wrap several fields in a field group for consistent spacing and a
          shared container query.",
        ),
      ],
      code: field.group_stacked_html,
      body: [group_stacked.view()],
    ),

    // --- Set & Legend --------------------------------------------------------
    content.SectionExample(
      anchor: set_anchor,
      description: [
        content.Text("Bind related fields under a field set with a legend."),
      ],
      code: field.set_legend_html,
      body: [set_legend.view()],
    ),

    // --- Separator -----------------------------------------------------------
    content.SectionExample(
      anchor: separator_anchor,
      description: [
        content.Text(
          "Drop a field separator between fields to break a form into sections.
          Pass children to render a centered label.",
        ),
      ],
      code: field.separator_html,
      body: [separator.view()],
    ),
  ])
}
