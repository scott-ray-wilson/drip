import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  element.fragment([
    button.button([button.xs()], [html.text("Extra Small")]),
    button.button([button.sm()], [html.text("Small")]),
    button.button([], [html.text("Medium")]),
    button.button([button.lg()], [html.text("Large")]),
  ])
}
