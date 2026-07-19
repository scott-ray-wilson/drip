import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.group([attribute.class("w-72")], [
    field.root([], [
      field.label([attribute.for("first-name")], [html.text("First name")]),
      text_field.input([
        attribute.id("first-name"),
        attribute.placeholder("Ada"),
      ]),
    ]),
    field.root([], [
      field.label([attribute.for("last-name")], [html.text("Last name")]),
      text_field.input([
        attribute.id("last-name"),
        attribute.placeholder("Lovelace"),
      ]),
    ]),
    field.root([], [
      field.label([attribute.for("email-address")], [html.text("Email")]),
      text_field.input([
        attribute.id("email-address"),
        attribute.type_("email"),
        attribute.placeholder("ada@glow.dev"),
      ]),
    ]),
  ])
}
