import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  button.button([button.accent()], [html.text("Accent Button")])
}
