import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-72")], [
    field.label([attribute.for("webhook-url")], [html.text("Webhook URL")]),
    text_field.input([
      attribute.id("webhook-url"),
      attribute.aria_invalid("true"),
      attribute.value("not-a-url"),
    ]),
    field.error([], [html.text("Must be a valid HTTPS URL.")]),
  ])
}
