import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-72")], [
    field.label([attribute.for("feedback")], [html.text("Feedback")]),
    text_area.input(
      [
        attribute.id("feedback"),
        attribute.placeholder("Tell us what you think..."),
      ],
      "",
    ),
    field.description([], [
      html.text("Share anything that would make Drip better."),
    ]),
  ])
}
