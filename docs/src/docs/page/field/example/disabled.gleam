import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  field.root([attribute.class("w-72")], [
    field.label([attribute.for("workspace-handle")], [
      html.text("Workspace handle"),
    ]),
    text_field.input([
      attribute.id("workspace-handle"),
      attribute.value("acme"),
      attribute.disabled(True),
    ]),
  ])
}
