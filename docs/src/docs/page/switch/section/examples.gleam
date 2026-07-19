import docs/content.{type Block}
import docs/generated/example/switch
import docs/page/switch/example/disabled
import docs/page/switch/example/invalid
import docs/page/switch/example/label
import docs/page/switch/example/sizes
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const sizes_anchor = Anchor(id: "sizes", label: "Sizes")

const label_anchor = Anchor(id: "label", label: "Label")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      sizes_anchor,
      label_anchor,
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
        "Size the switch with an attribute, pair it with field helpers, or set
        its state with standard attributes.",
      ),
    ]),

    // --- Sizes ---------------------------------------------------------------
    content.SectionExample(
      anchor: sizes_anchor,
      description: [
        content.Text(
          "Pass the small size attribute to fit dense toolbars and inline
          controls.",
        ),
      ],
      code: switch.sizes_html,
      body: [sizes.view()],
    ),

    // --- Label ---------------------------------------------------------------
    content.SectionExample(
      anchor: label_anchor,
      description: [
        content.Text(
          "Pair the switch with a horizontal field and label to extend the click
          target and announce the option.",
        ),
      ],
      code: switch.label_html,
      body: [label.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Set aria-invalid with a field error to surface validation errors.",
        ),
      ],
      code: switch.invalid_html,
      body: [invalid.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Pass the disabled attribute to prevent interaction and remove the
          switch from the focus order.",
        ),
      ],
      code: switch.disabled_html,
      body: [disabled.view()],
    ),
  ])
}
