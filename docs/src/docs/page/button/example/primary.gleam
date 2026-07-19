import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  button.button([], [html.text("Primary Button")])
}
