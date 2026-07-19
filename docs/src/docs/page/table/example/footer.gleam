import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/table

pub fn view() -> Element(message) {
  table.root([], [
    table.header([], [
      table.row([], [
        table.head([], [html.text("Invoice")]),
        table.head([], [html.text("Issued")]),
        table.head([], [html.text("Amount")]),
      ]),
    ]),
    table.body([], [
      table.row([], [
        table.cell([], [html.text("INV-001")]),
        table.cell([], [html.text("Apr 2026")]),
        table.cell([], [html.text("$1,200.00")]),
      ]),
      table.row([], [
        table.cell([], [html.text("INV-002")]),
        table.cell([], [html.text("Mar 2026")]),
        table.cell([], [html.text("$980.00")]),
      ]),
      table.row([], [
        table.cell([], [html.text("INV-003")]),
        table.cell([], [html.text("Feb 2026")]),
        table.cell([], [html.text("$640.00")]),
      ]),
    ]),
    table.footer([], [
      table.row([], [
        table.cell([attribute.colspan(2)], [html.text("Total")]),
        table.cell([], [html.text("$2,820.00")]),
      ]),
    ]),
  ])
}
