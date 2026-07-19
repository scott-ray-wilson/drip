import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  button.button([button.outline()], [html.text("Outline Button")])
}
