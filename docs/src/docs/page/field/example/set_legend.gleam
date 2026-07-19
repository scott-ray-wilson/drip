import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.set([attribute.class("w-72")], [
    field.legend([], [html.text("Workspace")]),
    field.description([], [
      html.text("Shown wherever your workspace appears."),
    ]),
    field.group([], [
      field.root([], [
        field.label([attribute.for("display-name")], [
          html.text("Display name"),
        ]),
        text_field.input([
          attribute.id("display-name"),
          attribute.placeholder("Acme Inc"),
        ]),
      ]),
      field.root([], [
        field.label([attribute.for("handle")], [
          html.text("Workspace handle"),
        ]),
        text_field.input([
          attribute.id("handle"),
          attribute.placeholder("acme"),
        ]),
      ]),
    ]),
  ])
}
