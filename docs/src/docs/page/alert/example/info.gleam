import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.info(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.info([])]),
    alert.title([], [html.text("Heads up")]),
    alert.description([], [
      html.text("This action is reversible for the next 24 hours."),
    ]),
  ])
}
