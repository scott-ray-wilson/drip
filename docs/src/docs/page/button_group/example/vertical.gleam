import lustre/attribute
import lustre/element.{type Element}
import ui/button
import ui/button_group
import ui/icon

pub fn view() -> Element(message) {
  button_group.root(
    [button_group.vertical(), attribute.aria_label("Zoom controls")],
    [
      button.button(
        [button.primary(), button.icon_only(), attribute.aria_label("Zoom in")],
        [icon.plus([])],
      ),
      button_group.separator([]),
      button.button(
        [
          button.primary(),
          button.icon_only(),
          attribute.aria_label("Zoom out"),
        ],
        [icon.minus([])],
      ),
    ],
  )
}
