import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/button
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.error(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.circle_x([])]),
    alert.title([], [html.text("Deployment failed")]),
    alert.description([], [
      html.text("Build #2413 exited with status 1. Check the logs for details."),
    ]),
    alert.actions([], [
      button.button([button.primary(), button.sm()], [
        html.text("View logs"),
      ]),
      button.button([button.destructive(), button.sm()], [
        html.text("Rollback"),
      ]),
    ]),
  ])
}
