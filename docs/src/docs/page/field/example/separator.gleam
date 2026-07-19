import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.group([attribute.class("w-72")], [
    field.root([], [
      field.label([attribute.for("current-password")], [
        html.text("Current password"),
      ]),
      text_field.input([
        attribute.id("current-password"),
        attribute.type_("password"),
        attribute.placeholder("Enter current password"),
      ]),
    ]),
    field.separator([], [html.text("then")]),
    field.root([], [
      field.label([attribute.for("new-password")], [html.text("New password")]),
      text_field.input([
        attribute.id("new-password"),
        attribute.type_("password"),
        attribute.placeholder("At least 8 characters"),
      ]),
    ]),
  ])
}
