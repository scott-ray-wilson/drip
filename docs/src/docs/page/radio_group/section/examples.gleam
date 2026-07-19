import docs/content.{type Block}
import docs/generated/example/radio_group
import docs/page/radio_group/example/description
import docs/page/radio_group/example/disabled
import docs/page/radio_group/example/field_set
import docs/page/radio_group/example/invalid
import docs/page/radio_group/example/radio_card
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const description_anchor = Anchor(id: "description", label: "Description")

const radio_card_anchor = Anchor(id: "radio-card", label: "Radio Card")

const field_set_anchor = Anchor(id: "field-set", label: "Field Set")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      description_anchor,
      radio_card_anchor,
      field_set_anchor,
      disabled_anchor,
      invalid_anchor,
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
        "Compose radio items with field helpers to label and group the options,
        or set their state with standard attributes.",
      ),
    ]),

    // --- Description ---------------------------------------------------------
    content.SectionExample(
      anchor: description_anchor,
      description: [
        content.Text(
          "Pair each item with a field label and description to explain the
          options.",
        ),
      ],
      code: radio_group.description_html,
      body: [description.view()],
    ),

    // --- Radio Card ----------------------------------------------------------
    content.SectionExample(
      anchor: radio_card_anchor,
      description: [
        content.Text(
          "Wrap each field in a label so the whole card selects its option.",
        ),
      ],
      code: radio_group.radio_card_html,
      body: [radio_card.view()],
    ),

    // --- Field Set -----------------------------------------------------------
    content.SectionExample(
      anchor: field_set_anchor,
      description: [
        content.Text(
          "Group related options in a field set with a legend and description.",
        ),
      ],
      code: radio_group.field_set_html,
      body: [field_set.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Pass the disabled attribute to prevent interaction and remove items
          from the focus order.",
        ),
      ],
      code: radio_group.disabled_html,
      body: [disabled.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Set aria-invalid on each item to surface validation errors, along with
          a field error for the message.",
        ),
      ],
      code: radio_group.invalid_html,
      body: [invalid.view()],
    ),
  ])
}
