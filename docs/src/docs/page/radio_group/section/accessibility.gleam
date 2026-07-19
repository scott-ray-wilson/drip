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
      content.Text(
        "Each item renders a native radio input inside a role=\"radiogroup\"
        wrapper, so arrow-key navigation and mutual exclusion come from the
        browser and assistive tech announces the items as one group. Pair every
        item with a field label so screen readers announce the option, and name
        the group itself with ",
      ),
      content.Code("attribute.aria_label"),
      content.Text(" or by pointing "),
      content.Code("attribute.aria_labelledby"),
      content.Text(" at a field set legend's id."),
    ]),

    // --- Keyboard ------------------------------------------------------------
    content.Subheading(keyboard_anchor),
    content.Table(headers: ["Key", "Action"], rows: [
      [
        content.key_cell(["Tab"]),
        content.text_cell(
          "Move focus to the selected item, or the first item when none is
          selected.",
        ),
      ],
      [
        content.key_cell(["Shift", "Tab"]),
        content.text_cell("Move focus to the previous focusable element."),
      ],
      [
        content.key_cell(["ArrowDown"]),
        content.text_cell("Move focus to the next item and select it."),
      ],
      [
        content.key_cell(["ArrowUp"]),
        content.text_cell("Move focus to the previous item and select it."),
      ],
      [
        content.key_cell(["ArrowRight"]),
        content.text_cell("Move focus to the next item and select it."),
      ],
      [
        content.key_cell(["ArrowLeft"]),
        content.text_cell("Move focus to the previous item and select it."),
      ],
      [
        content.key_cell(["Space"]),
        content.text_cell("Select the focused item."),
      ],
    ]),
  ])
}
