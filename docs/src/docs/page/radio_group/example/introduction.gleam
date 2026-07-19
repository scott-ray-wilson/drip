import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  radio_group.root(
    [attribute.aria_label("Billing cycle"), attribute.class("w-fit")],
    [
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("intro-plan-monthly"),
          attribute.name("intro-plan"),
          attribute.value("monthly"),
          attribute.checked(True),
        ]),
        field.label([attribute.for("intro-plan-monthly")], [
          html.text("Monthly"),
        ]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("intro-plan-yearly"),
          attribute.name("intro-plan"),
          attribute.value("yearly"),
        ]),
        field.label([attribute.for("intro-plan-yearly")], [html.text("Yearly")]),
      ]),
    ],
  )
}
