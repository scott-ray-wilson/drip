import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/switch

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-fit")], [
    field.label([attribute.for("reduced-motion")], [
      html.text("Reduced motion"),
    ]),
    switch.input([
      attribute.id("reduced-motion"),
      attribute.checked(True),
    ]),
  ])
}
