import lustre/element.{type Element}
import lustre/element/html
import ui/table

pub fn view() -> Element(message) {
  table.root([], [
    table.caption([], [html.text("A list of recent design tokens.")]),
    table.header([], [
      table.row([], [
        table.head([], [html.text("Token")]),
        table.head([], [html.text("Value")]),
      ]),
    ]),
    table.body([], [
      table.row([], [
        table.cell([], [html.text("--accent")]),
        table.cell([], [html.text("oklch(0.78 0.18 350)")]),
      ]),
      table.row([], [
        table.cell([], [html.text("--border")]),
        table.cell([], [html.text("oklch(0.30 0.02 264)")]),
      ]),
      table.row([], [
        table.cell([], [html.text("--radius")]),
        table.cell([], [html.text("2px")]),
      ]),
    ]),
  ])
}
