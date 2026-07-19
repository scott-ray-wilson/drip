import lustre/element.{type Element}
import lustre/element/html
import ui/table

pub fn view() -> Element(message) {
  table.root([], [
    table.header([], [table.row([], [table.head([], [html.text("Column")])])]),
    table.body([], [table.row([], [table.cell([], [html.text("Value")])])]),
  ])
}
