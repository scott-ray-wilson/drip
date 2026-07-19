import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  field.set([attribute.class("w-72")], [
    field.legend([attribute.id("subscription-plan-legend")], [
      html.text("Subscription plan"),
    ]),
    field.description([], [
      html.text("Yearly and lifetime plans offer the biggest savings."),
    ]),
    radio_group.root([attribute.aria_labelledby("subscription-plan-legend")], [
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-monthly"),
          attribute.name("subscription-plan"),
          attribute.value("monthly"),
          attribute.checked(True),
        ]),
        field.label([attribute.for("plan-monthly")], [html.text("Monthly")]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-yearly"),
          attribute.name("subscription-plan"),
          attribute.value("yearly"),
        ]),
        field.label([attribute.for("plan-yearly")], [html.text("Yearly")]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-lifetime"),
          attribute.name("subscription-plan"),
          attribute.value("lifetime"),
        ]),
        field.label([attribute.for("plan-lifetime")], [html.text("Lifetime")]),
      ]),
    ]),
  ])
}
