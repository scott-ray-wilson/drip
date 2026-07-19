import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  element.fragment([
    field.root([field.vertical(), attribute.class("w-54")], [
      field.label([attribute.for("intro-email")], [html.text("Email")]),
      text_field.input([
        attribute.id("intro-email"),
        attribute.type_("email"),
        attribute.value("ada@glow.dev"),
      ]),
    ]),
    field.root([field.vertical(), attribute.class("w-54")], [
      field.label([attribute.for("intro-api-key")], [html.text("API Key")]),
      text_field.input([
        attribute.id("intro-api-key"),
        attribute.type_("password"),
        attribute.value("••••••••••••"),
      ]),
    ]),
  ])
}
