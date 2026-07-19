import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/switch

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-fit")], [
    field.root([field.horizontal()], [
      switch.input([switch.sm(), attribute.id("size-small")]),
      field.label([attribute.for("size-small")], [html.text("Small")]),
    ]),
    field.root([field.horizontal()], [
      switch.input([attribute.id("size-medium")]),
      field.label([attribute.for("size-medium")], [html.text("Medium")]),
    ]),
  ])
}
