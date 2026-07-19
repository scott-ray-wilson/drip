import lustre/element.{type Element}
import lustre/element/html
import ui/empty
import ui/spinner

pub fn view() -> Element(message) {
  empty.root([], [
    empty.header([], [
      empty.icon([], [spinner.icon([])]),
      empty.title([], [html.text("Processing your request")]),
      empty.description([], [
        html.text("Please wait while we sync your workspace."),
      ]),
    ]),
  ])
}
