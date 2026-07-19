import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-96")], [
    field.label([attribute.for("release-notes")], [html.text("Release Notes")]),
    text_area.input(
      [
        attribute.id("release-notes"),
        attribute.placeholder("v0.2.0: what shipped?"),
      ],
      "",
    ),
  ])
}
