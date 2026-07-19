import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-72")], [
    checkbox.input([
      attribute.id("email-notifications"),
      attribute.checked(True),
    ]),
    field.content([], [
      field.label([attribute.for("email-notifications")], [
        html.text("Email notifications"),
      ]),
      field.description([], [
        html.text("Send a digest of activity once per week."),
      ]),
    ]),
  ])
}
