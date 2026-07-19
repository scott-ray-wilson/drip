import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.info(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.info([])]),
    alert.title([], [html.text("New version available")]),
    alert.description([], [
      html.text("Update now to pick up the latest elements and fixes."),
    ]),
  ])
}
