import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/switch

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-fit")], [
    field.root([field.horizontal()], [
      switch.input([
        attribute.id("accept-policy"),
        attribute.aria_invalid("true"),
      ]),
      field.label([attribute.for("accept-policy")], [
        html.text("Accept the privacy policy"),
      ]),
    ]),
    field.error([], [html.text("You must accept to continue.")]),
  ])
}
