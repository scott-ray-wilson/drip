import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon

pub fn view() -> Element(message) {
  element.fragment([
    button.button([], [html.text("Primary")]),
    button.button([button.icon_only(), attribute.aria_label("Next")], [
      icon.arrow_right([]),
    ]),
  ])
}
