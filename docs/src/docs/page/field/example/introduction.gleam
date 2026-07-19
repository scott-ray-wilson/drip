import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([attribute.class("w-72")], [
    field.label([attribute.for("email")], [html.text("Email")]),
    text_field.input([
      attribute.id("email"),
      attribute.type_("email"),
      attribute.placeholder("ada@glow.dev"),
    ]),
    field.description([], [
      html.text("We'll only contact you about your account."),
    ]),
  ])
}
