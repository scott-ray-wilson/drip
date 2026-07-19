import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/table

pub fn view() -> Element(message) {
  table.root([], [
    table.header([], [
      table.row([], [
        table.head([], [
          checkbox.input([attribute.aria_label("Select all rows")]),
        ]),
        table.head([], [html.text("Workspace")]),
        table.head([], [html.text("Plan")]),
        table.head([], [html.text("Members")]),
      ]),
    ]),
    table.body([], [
      table.row([], [
        table.cell([], [checkbox.input([attribute.aria_label("Select Drip")])]),
        table.cell([], [html.text("Drip")]),
        table.cell([], [html.text("Pro")]),
        table.cell([], [html.text("12")]),
      ]),
      table.row([attribute.data("state", "selected")], [
        table.cell([], [
          checkbox.input([
            attribute.aria_label("Select Acme Labs"),
            attribute.checked(True),
          ]),
        ]),
        table.cell([], [html.text("Acme Labs")]),
        table.cell([], [html.text("Enterprise")]),
        table.cell([], [html.text("48")]),
      ]),
      table.row([], [
        table.cell([], [
          checkbox.input([attribute.aria_label("Select Personal")]),
        ]),
        table.cell([], [html.text("Personal")]),
        table.cell([], [html.text("Free")]),
        table.cell([], [html.text("1")]),
      ]),
    ]),
  ])
}
