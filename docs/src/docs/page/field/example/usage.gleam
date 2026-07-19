import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([attribute.class("w-64")], [
    field.label([attribute.for("display-name")], [html.text("Display name")]),
    text_field.input([
      attribute.id("display-name"),
      attribute.placeholder("Ada Lovelace"),
    ]),
    field.description([], [
      html.text("Shown on your profile and next to your comments."),
    ]),
  ])
}
