import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-96")], [
    field.label([attribute.for("intro-description")], [
      html.text("Description"),
    ]),
    text_area.input(
      [
        attribute.id("intro-description"),
        attribute.placeholder("Tell us what changed in this release…"),
      ],
      "",
    ),
  ])
}
