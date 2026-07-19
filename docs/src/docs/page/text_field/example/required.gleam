import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-72")], [
    field.label([attribute.for("workspace-name")], [
      html.text("Workspace Name"),
    ]),
    text_field.input([
      attribute.id("workspace-name"),
      attribute.placeholder("acme-rocketry"),
      attribute.required(True),
    ]),
    field.description([], [html.text("Used in your workspace URL.")]),
  ])
}
