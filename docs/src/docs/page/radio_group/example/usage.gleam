import lustre/attribute
import lustre/element.{type Element}
import ui/radio_group

pub fn view() -> Element(message) {
  radio_group.root([attribute.aria_label("Billing cycle")], [
    radio_group.item([attribute.name("plan"), attribute.value("monthly")]),
    radio_group.item([attribute.name("plan"), attribute.value("yearly")]),
  ])
}
