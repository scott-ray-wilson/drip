import docs/content.{type Block}
import docs/generated/example/text_area
import docs/page/text_area/example/default as default_example
import docs/page/text_area/example/disabled
import docs/page/text_area/example/invalid
import docs/page/text_area/example/required
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const default_anchor = Anchor(id: "default", label: "Default")

const required_anchor = Anchor(id: "required", label: "Required")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      default_anchor,
      required_anchor,
      invalid_anchor,
      disabled_anchor,
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
        "Set the state of a text area with standard attributes, or compose it
        with field helpers.",
      ),
    ]),

    // --- Default -------------------------------------------------------------
    content.SectionExample(
      anchor: default_anchor,
      description: [
        content.Text(
          "A bare text area inside a field, with placeholder copy. Auto-sizes to
          its content via field-sizing.",
        ),
      ],
      code: text_area.default_html,
      body: [default_example.view()],
    ),

    // --- Required ------------------------------------------------------------
    content.SectionExample(
      anchor: required_anchor,
      description: [
        content.Text(
          "Pass the required attribute and the field's label surfaces an accent
          asterisk.",
        ),
      ],
      code: text_area.required_html,
      body: [required.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Set aria-invalid to surface the destructive border. Pair with
          field.error for the message.",
        ),
      ],
      code: text_area.invalid_html,
      body: [invalid.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Add the disabled attribute to lock a text area and dim its surface.",
        ),
      ],
      code: text_area.disabled_html,
      body: [disabled.view()],
    ),
  ])
}
