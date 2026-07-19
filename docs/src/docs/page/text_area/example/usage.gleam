import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/text_area

pub fn view() -> Element(message) {
  field.root([field.vertical()], [
    field.label([attribute.for("description")], [html.text("Description")]),
    text_area.input(
      [attribute.id("description"), attribute.placeholder("Add a description…")],
      "",
    ),
  ])
}
