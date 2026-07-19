import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group
import ui/icon

pub fn view() -> Element(message) {
  button_group.root([attribute.aria_label("Message actions")], [
    button_group.root([], [
      button.button([button.outline()], [html.text("Archive")]),
      button.button([button.outline()], [html.text("Report")]),
      button.button([button.outline()], [html.text("Snooze")]),
    ]),
    button_group.root([], [
      button.button(
        [button.outline(), button.icon_only(), attribute.aria_label("More")],
        [icon.ellipsis([])],
      ),
    ]),
  ])
}
