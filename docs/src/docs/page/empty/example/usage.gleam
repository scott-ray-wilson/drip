import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/empty
import ui/icon

pub fn view() -> Element(message) {
  empty.root([], [
    empty.header([], [
      empty.icon([], [icon.file_text([])]),
      empty.title([], [html.text("No documents yet")]),
      empty.description([], [
        html.text("Create your first document to start writing."),
      ]),
    ]),
    empty.content([], [
      button.button([button.primary()], [html.text("New document")]),
    ]),
  ])
}
