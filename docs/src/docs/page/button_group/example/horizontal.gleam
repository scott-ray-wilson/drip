import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group
import ui/icon

pub fn view() -> Element(message) {
  button_group.root(
    [button_group.horizontal(), attribute.aria_label("Clipboard actions")],
    [
      button.button([button.outline()], [
        icon.copy([button.icon_start()]),
        html.text("Copy"),
      ]),
      button.button([button.outline()], [
        icon.clipboard_paste([button.icon_start()]),
        html.text("Paste"),
      ]),
    ],
  )
}
