import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon

pub fn view() -> Element(message) {
  element.fragment([
    button.button([attribute.disabled(True)], [html.text("Primary")]),
    button.button([button.ghost(), attribute.disabled(True)], [
      html.text("Ghost"),
    ]),
    button.button([button.destructive(), attribute.disabled(True)], [
      html.text("Destructive"),
    ]),
    button.button(
      [
        attribute.disabled(True),
        button.icon_only(),
        attribute.aria_label("Next"),
      ],
      [icon.arrow_right([])],
    ),
  ])
}
