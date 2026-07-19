import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/card

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[320px]")], [
    card.header([], [
      card.title([], [html.text("Quick Start")]),
      card.description([], [html.text("Get configured in seconds.")]),
    ]),
    card.content([], [
      html.p([], [
        html.text("Install the CLI, add your first element, and ship."),
      ]),
    ]),
  ])
}
