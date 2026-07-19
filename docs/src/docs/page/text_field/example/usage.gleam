import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical()], [
    field.label([attribute.for("email")], [html.text("Email")]),
    text_field.input([
      attribute.id("email"),
      attribute.placeholder("ada@glow.dev"),
    ]),
  ])
}
