import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/switch

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-fit")], [
    field.root([field.horizontal()], [
      switch.input([
        attribute.id("disabled-analytics"),
        attribute.disabled(True),
      ]),
      field.label([attribute.for("disabled-analytics")], [
        html.text("Share usage analytics"),
      ]),
    ]),
    field.root([field.horizontal()], [
      switch.input([
        attribute.id("disabled-updates"),
        attribute.disabled(True),
        attribute.checked(True),
      ]),
      field.label([attribute.for("disabled-updates")], [
        html.text("Install updates automatically"),
      ]),
    ]),
  ])
}
