import lustre/element.{type Element}
import lustre/element/html
import ui/empty
import ui/icon

pub fn view() -> Element(message) {
  empty.root([empty.outline()], [
    empty.header([], [
      empty.icon([], [icon.search([])]),
      empty.title([], [html.text("No matching results")]),
      empty.description([], [
        html.text("Try a different keyword or clear your filters."),
      ]),
    ]),
  ])
}
