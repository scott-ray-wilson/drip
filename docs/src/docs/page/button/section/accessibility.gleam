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
    content.Callout(title: "Native button semantics", body: [
      content.Text("Renders as a native "),
      content.Code("<button>"),
      content.Text(" (or an "),
      content.Code("<a>"),
      content.Text(" when built with "),
      content.Code("button.link"),
      content.Text(
        "), so activation, focus, and the disabled state come from the browser.
        Setting aria-busy=\"true\" on a pending button means assistive tech
        announces the busy state. Icon-only buttons have no text content, so
        give each one an accessible name with aria-label.",
      ),
    ]),

    // --- Keyboard ------------------------------------------------------------
    content.Subheading(keyboard_anchor),
    content.Table(headers: ["Key", "Action"], rows: [
      [
        content.key_cell(["Tab"]),
        content.text_cell("Move focus to the button."),
      ],
      [
        content.key_cell(["Shift", "Tab"]),
        content.text_cell("Move focus back to the previous focusable element."),
      ],
      [
        content.key_cell(["Enter"]),
        content.text_cell(
          "Activate the button, or follow the link when built with
          button.link.",
        ),
      ],
      [
        content.key_cell(["Space"]),
        content.text_cell(
          "Activate the button. Anchors built with button.link do not respond
          to Space.",
        ),
      ],
    ]),
  ])
}
