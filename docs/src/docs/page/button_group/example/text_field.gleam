import lustre/attribute
import lustre/element.{type Element}
import ui/button
import ui/button_group
import ui/icon
import ui/text_field

pub fn view() -> Element(message) {
  button_group.root([attribute.aria_label("Search")], [
    text_field.input([attribute.placeholder("Search...")]),
    button.button(
      [button.secondary(), button.icon_only(), attribute.aria_label("Search")],
      [icon.search([])],
    ),
  ])
}
