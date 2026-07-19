import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-fit")], [
    radio_group.root([attribute.aria_label("Contact method")], [
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("contact-email"),
          attribute.name("contact-method"),
          attribute.value("email"),
          attribute.aria_invalid("true"),
        ]),
        field.label([attribute.for("contact-email")], [html.text("Email")]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("contact-phone"),
          attribute.name("contact-method"),
          attribute.value("phone"),
          attribute.aria_invalid("true"),
        ]),
        field.label([attribute.for("contact-phone")], [html.text("Phone")]),
      ]),
    ]),
    field.error([], [html.text("Pick a contact method to continue.")]),
  ])
}
