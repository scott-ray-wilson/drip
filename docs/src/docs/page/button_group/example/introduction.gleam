import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group
import ui/icon

pub fn view() -> Element(message) {
  button_group.root([attribute.aria_label("Editor actions")], [
    button_group.root([], [
      button.button(
        [
          button.primary(),
          button.icon_only(),
          attribute.aria_label("Back"),
        ],
        [icon.arrow_left([])],
      ),
    ]),
    button_group.root([], [
      button.button([button.primary()], [html.text("Save")]),
      button_group.separator([]),
      button.button([button.primary()], [html.text("Preview")]),
    ]),
    button_group.root([], [
      button.button([button.primary()], [html.text("Publish")]),
    ]),
  ])
}
