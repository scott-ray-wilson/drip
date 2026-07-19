import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/switch

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-fit")], [
    switch.input([attribute.id("marketing-emails"), attribute.checked(True)]),
    field.label([attribute.for("marketing-emails")], [
      html.text("Send me marketing emails"),
    ]),
  ])
}
