import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/empty
import ui/icon

pub fn view() -> Element(message) {
  empty.root([empty.outline()], [
    empty.header([], [
      empty.icon([], [icon.box([])]),
      empty.title([], [html.text("No items in this collection")]),
      empty.description([], [
        html.text(
          "Add an item from your library or import a CSV to get started.",
        ),
      ]),
    ]),
    empty.content([], [
      html.div([attribute.class("flex gap-2")], [
        button.button([button.primary(), button.sm()], [html.text("Add item")]),
        button.button([button.outline(), button.sm()], [
          html.text("Import CSV"),
        ]),
      ]),
      html.p([attribute.class("text-xs text-muted-foreground")], [
        html.text("Need help? "),
        html.a([attribute.href("#")], [html.text("Read the docs")]),
        html.text("."),
      ]),
    ]),
  ])
}
