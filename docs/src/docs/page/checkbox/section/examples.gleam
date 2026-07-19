import docs/content.{type Block}
import docs/generated/example/checkbox
import docs/page/checkbox/example/card
import docs/page/checkbox/example/description
import docs/page/checkbox/example/disabled
import docs/page/checkbox/example/group
import docs/page/checkbox/example/invalid
import docs/page/checkbox/example/label
import docs/page/checkbox/example/table
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const label_anchor = Anchor(id: "label", label: "Label")

const description_anchor = Anchor(id: "description", label: "Description")

const card_anchor = Anchor(id: "card", label: "Card")

const group_anchor = Anchor(id: "group", label: "Group")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

const table_anchor = Anchor(id: "table", label: "Table")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      label_anchor,
      description_anchor,
      card_anchor,
      group_anchor,
      invalid_anchor,
      disabled_anchor,
      table_anchor,
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
        "Set the state of a checkbox with modifier attributes, or compose it with
        field helpers.",
      ),
    ]),

    // --- Label ---------------------------------------------------------------
    content.SectionExample(
      anchor: label_anchor,
      description: [
        content.Text(
          "Pair the checkbox with a horizontal field and label to extend the
          click target and announce the option.",
        ),
      ],
      code: checkbox.label_html,
      body: [label.view()],
    ),

    // --- Description ---------------------------------------------------------
    content.SectionExample(
      anchor: description_anchor,
      description: [
        content.Text(
          "Pair the checkbox with a field label and description to explain the
          option.",
        ),
      ],
      code: checkbox.description_html,
      body: [description.view()],
    ),

    // --- Card ----------------------------------------------------------------
    content.SectionExample(
      anchor: card_anchor,
      description: [
        content.Text(
          "Wrap the field in a label so the whole card toggles the checkbox.",
        ),
      ],
      code: checkbox.card_html,
      body: [card.view()],
    ),

    // --- Group ---------------------------------------------------------------
    content.SectionExample(
      anchor: group_anchor,
      description: [
        content.Text(
          "Wrap related checkboxes in a set so screen readers announce them as a
          single group.",
        ),
      ],
      code: checkbox.group_html,
      body: [group.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Set aria-invalid with a field error to surface validation errors.",
        ),
      ],
      code: checkbox.invalid_html,
      body: [invalid.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Pass the disabled attribute to prevent interaction and remove the
          checkbox from the focus order.",
        ),
      ],
      code: checkbox.disabled_html,
      body: [disabled.view()],
    ),

    // --- Table ---------------------------------------------------------------
    content.SectionExample(
      anchor: table_anchor,
      description: [
        content.Text(
          "Place a checkbox in each row's leading cell to toggle selection.",
        ),
      ],
      code: checkbox.table_html,
      body: [table.view()],
    ),
  ])
}
