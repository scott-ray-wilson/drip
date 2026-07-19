import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  radio_group.root(
    [attribute.aria_label("Shipping speed"), attribute.class("w-fit")],
    [
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("disabled-standard"),
          attribute.name("shipping-speed"),
          attribute.value("standard"),
          attribute.disabled(True),
        ]),
        field.label([attribute.for("disabled-standard")], [
          html.text("Standard"),
        ]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("disabled-priority"),
          attribute.name("shipping-speed"),
          attribute.value("priority"),
          attribute.disabled(True),
          attribute.checked(True),
        ]),
        field.label([attribute.for("disabled-priority")], [
          html.text("Priority"),
        ]),
      ]),
    ],
  )
}
