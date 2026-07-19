import lustre/element.{type Element}
import lustre/element/html
import ui/empty
import ui/icon

pub fn view() -> Element(message) {
  empty.root([empty.ghost()], [
    empty.header([], [
      empty.icon([], [icon.box([])]),
      empty.title([], [html.text("No projects yet")]),
      empty.description([], [
        html.text("Spin up your first project to start collecting data."),
      ]),
    ]),
  ])
}
