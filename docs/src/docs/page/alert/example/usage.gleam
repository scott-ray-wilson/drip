import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.info()], [
    alert.icon([], [icon.info([])]),
    alert.title([], [html.text("Heads up")]),
    alert.description([], [html.text("Something to note.")]),
    alert.close([], [icon.x([])]),
  ])
}
