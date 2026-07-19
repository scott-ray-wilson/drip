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
    content.Callout(title: "Native semantics, keyboard ready", body: [
      content.Text("Renders a native "),
      content.Code("<input type=\"checkbox\">"),
      content.Text(
        " with role=\"switch\", so the browser handles toggling, focus, and
        form submission while assistive tech announces it as an on/off switch.
        Pair every switch with a field label so screen readers announce what
        the toggle controls.",
      ),
    ]),

    // --- Keyboard ------------------------------------------------------------
    content.Subheading(keyboard_anchor),
    content.Table(headers: ["Key", "Action"], rows: [
      [
        content.key_cell(["Tab"]),
        content.text_cell("Move focus to the switch."),
      ],
      [
        content.key_cell(["Shift", "Tab"]),
        content.text_cell("Move focus to the previous focusable element."),
      ],
      [
        content.key_cell(["Space"]),
        content.text_cell("Toggle the on/off state."),
      ],
    ]),
  ])
}
