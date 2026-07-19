import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([attribute.class("w-72")], [
    field.label([attribute.for("work-email")], [html.text("Work email")]),
    text_field.input([
      attribute.id("work-email"),
      attribute.type_("email"),
      attribute.value("not-an-email"),
      attribute.aria_invalid("true"),
    ]),
    field.error([], [html.text("Enter a valid email address.")]),
  ])
}
