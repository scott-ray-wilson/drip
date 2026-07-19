import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

pub fn view() -> Element(message) {
  alert.root([alert.neutral(), attribute.class("w-full max-w-lg")], [
    alert.icon([], [icon.book_open_text([])]),
    alert.title([], [html.text("Tip")]),
    alert.description([], [
      html.text(
        "Prefer composing variants over building one-off alerts;
        every slot here is part of the public API.",
      ),
    ]),
  ])
}
