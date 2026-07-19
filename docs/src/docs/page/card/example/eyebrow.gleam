import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/card

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[320px]")], [
    card.header([], [
      card.eyebrow([], [html.text("New")]),
      card.title([], [html.text("Workspace insights")]),
      card.description([], [
        html.text("Track activity across every project in one place."),
      ]),
    ]),
    card.content([], [
      html.p([], [
        html.text("Commits, reviews, and deploys in one live feed."),
      ]),
    ]),
  ])
}
