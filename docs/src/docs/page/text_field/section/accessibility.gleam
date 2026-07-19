import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "accessibility", label: "Accessibility")

const keyboard_anchor = Anchor(id: "keyboard-interactions", label: "Keyboard")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      keyboard_anchor,
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
    content.Callout(title: "Labeled, validated, keyboard-friendly", body: [
      content.Text("Renders as a native "),
      content.Code("<input>"),
      content.Text(
        " with full keyboard support, surfaces validation via aria-invalid, and
        keeps the focus outline visible in both themes. Pair each control with
        a label element for screen readers.",
      ),
    ]),

    // --- Keyboard ------------------------------------------------------------
    content.Subheading(keyboard_anchor),
    content.Table(headers: ["Key", "Action"], rows: [
      [
        content.key_cell(["Tab"]),
        content.text_cell("Move focus to the next focusable control."),
      ],
      [
        content.key_cell(["Shift", "Tab"]),
        content.text_cell("Move focus to the previous focusable control."),
      ],
      [
        content.key_cell(["Enter"]),
        content.text_cell("Submit the surrounding form, if any."),
      ],
    ]),
  ])
}
