import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group
import ui/icon

pub fn view() -> Element(message) {
  button_group.root([attribute.aria_label("Pagination")], [
    button.button([button.primary()], [
      icon.arrow_left([button.icon_start()]),
      html.text("Previous"),
    ]),
    button_group.separator([]),
    button.button([button.primary()], [
      html.text("Next"),
      icon.arrow_right([button.icon_end()]),
    ]),
  ])
}
