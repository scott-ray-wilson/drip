import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-64")], [
    field.label([attribute.for("username")], [html.text("Username")]),
    text_field.input([
      attribute.id("username"),
      attribute.placeholder("ada"),
    ]),
    field.description([], [html.text("Lowercase letters and underscores.")]),
  ])
}
