import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.warning(), alert.banner()], [
    alert.icon([], [icon.triangle_alert([])]),
    alert.title([], [html.text("Scheduled maintenance window")]),
    alert.description([], [
      html.text(
        "eu-west-1 will be offline 02:00–02:30 UTC on
        May 2 for planned database migration.",
      ),
    ]),
    alert.close([], [icon.x([])]),
  ])
}
