import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-72")], [
    field.label([attribute.for("project-name")], [html.text("Project Name")]),
    text_field.input([
      attribute.id("project-name"),
      attribute.placeholder("my-glow-app"),
    ]),
  ])
}
