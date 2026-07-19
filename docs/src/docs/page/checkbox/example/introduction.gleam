import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-fit")], [
    checkbox.input([attribute.id("intro-terms"), attribute.checked(True)]),
    field.label([attribute.for("intro-terms")], [
      html.text("Accept terms of service"),
    ]),
  ])
}
