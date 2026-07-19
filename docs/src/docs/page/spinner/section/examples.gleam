import docs/content.{type Block}
import docs/generated/example/spinner
import docs/page/spinner/example/button
import docs/page/spinner/example/empty
import docs/page/spinner/example/label
import docs/page/spinner/example/sizes
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const sizes_anchor = Anchor(id: "sizes", label: "Sizes")

const label_anchor = Anchor(id: "label", label: "Label")

const button_anchor = Anchor(id: "button", label: "Button")

const empty_anchor = Anchor(id: "empty", label: "Empty")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      sizes_anchor,
      label_anchor,
      button_anchor,
      empty_anchor,
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
        "Size the spinner with utility classes or compose it into other
        components to signal pending work.",
      ),
    ]),

    // --- Sizes ---------------------------------------------------------------
    content.SectionExample(
      anchor: sizes_anchor,
      description: [
        content.Text("Override the default size with any size utility."),
      ],
      code: spinner.sizes_html,
      body: [sizes.view()],
    ),

    // --- Label ---------------------------------------------------------------
    content.SectionExample(
      anchor: label_anchor,
      description: [
        content.Text(
          "Pair the spinner with a short text label when the wait needs
          context.",
        ),
      ],
      code: spinner.label_html,
      body: [label.view()],
    ),

    // --- Button --------------------------------------------------------------
    content.SectionExample(
      anchor: button_anchor,
      description: [
        content.Text(
          "Add a spinner as a button child and set aria-busy to reveal it. Pair
          with disabled to block interaction.",
        ),
      ],
      code: spinner.button_html,
      body: [button.view()],
    ),

    // --- Empty ---------------------------------------------------------------
    content.SectionExample(
      anchor: empty_anchor,
      description: [
        content.Text(
          "Fill an empty state's icon slot with the spinner to mark a whole
          surface as loading.",
        ),
      ],
      code: spinner.empty_html,
      body: [empty.view()],
    ),
  ])
}
