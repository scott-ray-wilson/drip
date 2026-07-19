import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-96")], [
    field.label([attribute.for("commit-message")], [
      html.text("Commit Message"),
    ]),
    text_area.input(
      [
        attribute.id("commit-message"),
        attribute.aria_invalid("true"),
        attribute.placeholder("Describe your change…"),
      ],
      "wip",
    ),
    field.error([], [
      html.text("Commit messages must be at least 10 characters."),
    ]),
  ])
}
