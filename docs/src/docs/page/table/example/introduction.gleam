import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/table

pub fn view() -> Element(message) {
  table.root([], [
    table.header([], [
      table.row([], [
        table.head([], [html.text("Deployment")]),
        table.head([], [html.text("Status")]),
        table.head([], [html.text("Region")]),
        table.head([], [html.text("Updated")]),
      ]),
    ]),
    table.body([], [
      table.row([], [
        table.cell([attribute.class("font-mono text-foreground")], [
          html.text("dpl_8d4f1a2c"),
        ]),
        table.cell([], [html.text("Live")]),
        table.cell([], [html.text("iad1")]),
        table.cell([], [html.text("2 min ago")]),
      ]),
      table.row([], [
        table.cell([attribute.class("font-mono text-foreground")], [
          html.text("dpl_47c91be0"),
        ]),
        table.cell([], [html.text("Building")]),
        table.cell([], [html.text("sfo1")]),
        table.cell([], [html.text("12 min ago")]),
      ]),
      table.row([], [
        table.cell([attribute.class("font-mono text-foreground")], [
          html.text("dpl_19ae33df"),
        ]),
        table.cell([], [html.text("Live")]),
        table.cell([], [html.text("fra1")]),
        table.cell([], [html.text("1 hr ago")]),
      ]),
      table.row([], [
        table.cell([attribute.class("font-mono text-foreground")], [
          html.text("dpl_22bb70a5"),
        ]),
        table.cell([], [html.text("Failed")]),
        table.cell([], [html.text("sin1")]),
        table.cell([], [html.text("3 hr ago")]),
      ]),
    ]),
  ])
}
