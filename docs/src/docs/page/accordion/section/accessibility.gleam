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
    content.Callout(title: "Keyboard & screen reader ready", body: [
      content.Text("Each item renders as a native "),
      content.Code("<details>"),
      content.Text("/"),
      content.Code("<summary>"),
      content.Text(
        " pair, so expanding, collapsing, and exclusive name grouping come
        from the browser rather than from script, and each trigger's expanded
        state is announced through the same built-in semantics. Inert items
        drop out of both the tab order and the accessibility tree.",
      ),
    ]),

    // --- Keyboard ------------------------------------------------------------
    content.Subheading(keyboard_anchor),
    content.Table(headers: ["Key", "Action"], rows: [
      [
        content.key_cell(["Tab"]),
        content.text_cell(
          "Move focus to the next trigger (and any focusable content inside an
          open panel).",
        ),
      ],
      [
        content.key_cell(["Shift", "Tab"]),
        content.text_cell(
          "Move focus to the previous trigger (and any focusable content inside
          an open panel).",
        ),
      ],
      [
        content.key_cell(["Enter"]),
        content.text_cell("Toggle the focused item open or closed."),
      ],
      [
        content.key_cell(["Space"]),
        content.text_cell("Toggle the focused item open or closed."),
      ],
    ]),
  ])
}
