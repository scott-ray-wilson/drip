import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.root([field.horizontal(), attribute.class("w-fit max-w-sm")], [
    checkbox.input([attribute.id("description-usage")]),
    field.content([], [
      field.label([attribute.for("description-usage")], [
        html.text("Share usage data"),
      ]),
      field.description([], [
        html.text("Help improve Drip by sending anonymous usage reports."),
      ]),
    ]),
  ])
}
