import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon

pub fn view() -> Element(message) {
  element.fragment([
    button.button([button.ghost(), button.xs()], [
      icon.plus([button.icon_start()]),
      html.text("Create New"),
    ]),
    button.button([button.secondary(), button.sm()], [
      icon.copy([button.icon_start()]),
      html.text("Copy"),
    ]),
    button.button([], [
      html.text("Download"),
      icon.download([button.icon_end()]),
    ]),
    button.button([button.destructive(), button.lg()], [
      icon.trash([button.icon_start()]),
      html.text("Delete Record"),
    ]),
  ])
}
