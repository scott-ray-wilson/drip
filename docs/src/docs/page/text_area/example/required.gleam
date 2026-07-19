import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-96")], [
    field.label([attribute.for("rollback-reason")], [
      html.text("Rollback Reason"),
    ]),
    text_area.input(
      [
        attribute.id("rollback-reason"),
        attribute.placeholder("What went wrong?"),
        attribute.required(True),
      ],
      "",
    ),
    field.description([], [html.text("Posted to the incident channel.")]),
  ])
}
