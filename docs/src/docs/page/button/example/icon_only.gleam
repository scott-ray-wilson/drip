import lustre/attribute
import lustre/element.{type Element}
import ui/button
import ui/icon

pub fn view() -> Element(message) {
  element.fragment([
    button.button(
      [button.icon_only(), button.xs(), attribute.aria_label("Next")],
      [icon.arrow_right([])],
    ),
    button.button(
      [
        button.secondary(),
        button.icon_only(),
        button.sm(),
        attribute.aria_label("Change layout"),
      ],
      [icon.layout_template([])],
    ),
    button.button(
      [button.outline(), button.icon_only(), attribute.aria_label("Close")],
      [icon.x([])],
    ),
    button.button(
      [
        button.destructive(),
        button.icon_only(),
        button.lg(),
        attribute.aria_label("Delete"),
      ],
      [icon.trash([])],
    ),
  ])
}
