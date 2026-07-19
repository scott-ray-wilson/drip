import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  button.button([attribute.class("max-w-sm"), button.full_width()], [
    html.text("Full Width"),
  ])
}
