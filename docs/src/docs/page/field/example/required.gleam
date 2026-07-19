import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([attribute.class("w-72")], [
    field.label([attribute.for("full-name")], [html.text("Full name")]),
    text_field.input([
      attribute.id("full-name"),
      attribute.required(True),
      attribute.placeholder("Ada Lovelace"),
    ]),
  ])
}
