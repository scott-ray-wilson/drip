import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/card

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[360px]")], [
    card.header([], [
      card.title([], [html.text("Notifications")]),
      card.description([], [html.text("Manage how and when we email you.")]),
      card.action([], [
        button.button([button.ghost(), button.sm()], [html.text("Edit")]),
      ]),
    ]),
    card.content([], [
      html.p([], [
        html.text("A weekly digest, plus instant alerts for mentions."),
      ]),
    ]),
  ])
}
