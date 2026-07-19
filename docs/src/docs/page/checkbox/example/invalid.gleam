import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-fit")], [
    field.root([field.horizontal()], [
      checkbox.input([
        attribute.id("agree-eula"),
        attribute.aria_invalid("true"),
      ]),
      field.label([attribute.for("agree-eula")], [
        html.text("I agree to the EULA"),
      ]),
    ]),
    field.error([], [html.text("You must accept to continue.")]),
  ])
}
