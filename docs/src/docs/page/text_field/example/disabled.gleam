import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-72")], [
    field.label([attribute.for("workspace-id")], [html.text("Workspace ID")]),
    text_field.input([
      attribute.id("workspace-id"),
      attribute.value("ws_8d4f1a2c"),
      attribute.disabled(True),
    ]),
    field.description([], [html.text("Generated on workspace creation.")]),
  ])
}
