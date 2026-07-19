import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/empty
import ui/icon

pub fn view() -> Element(message) {
  empty.root([empty.outline()], [
    empty.header([], [
      empty.icon([], [icon.user([])]),
      empty.title([], [html.text("No team members")]),
      empty.description([], [
        html.text("Invite your teammates to start collaborating on projects."),
      ]),
    ]),
    empty.content([], [
      button.button([button.primary(), button.sm()], [
        html.text("Invite people"),
      ]),
    ]),
  ])
}
