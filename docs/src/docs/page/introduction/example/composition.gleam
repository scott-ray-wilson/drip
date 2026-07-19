import lustre/element.{type Element}
import lustre/element/html
import ui/accordion
import ui/button

pub fn view() -> Element(message) {
  html.div([], [
    button.button([button.outline(), button.sm()], [html.text("Cancel")]),
    accordion.root([accordion.outline()], [
      accordion.item([], [
        accordion.trigger([], [html.text("Details")]),
        accordion.content([], [html.text("Plain HTML underneath.")]),
      ]),
    ]),
  ])
}
