import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  element.fragment([
    button.button([attribute.aria_invalid("true")], [html.text("Primary")]),
    button.button([button.outline(), attribute.aria_invalid("true")], [
      html.text("Outline"),
    ]),
    button.button([button.ghost(), attribute.aria_invalid("true")], [
      html.text("Ghost"),
    ]),
    button.button([button.destructive(), attribute.aria_invalid("true")], [
      html.text("Destructive"),
    ]),
  ])
}
