import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.accent(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.sparkles([])]),
    alert.title([], [html.text("Theme it your way")]),
    alert.description([], [
      html.text(
        "Every element ships with CSS variables. Swap palettes, radius, and
        motion without touching markup. ",
      ),
      html.a([attribute.href("#"), attribute.class("text-accent")], [
        html.text("Learn more"),
      ]),
    ]),
  ])
}
