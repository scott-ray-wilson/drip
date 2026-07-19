import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.warning(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.triangle_alert([])]),
    alert.title([], [html.text("Approaching rate limit")]),
    alert.description([], [
      html.text("You've used 87% of this hour's request budget."),
    ]),
  ])
}
