import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group

pub fn view() -> Element(message) {
  button_group.root([button_group.horizontal()], [
    button.button([button.outline()], [html.text("Action")]),
    button.button([button.outline()], [html.text("Action")]),
  ])
}
