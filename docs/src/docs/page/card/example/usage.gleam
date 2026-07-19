import lustre/element.{type Element}
import lustre/element/html
import ui/card

pub fn view() -> Element(message) {
  card.root([], [
    card.header([], [
      card.title([], [html.text("Title")]),
      card.description([], [html.text("Supporting description.")]),
    ]),
    card.content([], [html.text("Body content.")]),
  ])
}
