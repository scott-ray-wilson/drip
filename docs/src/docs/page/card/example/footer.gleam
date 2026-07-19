import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/card

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[360px]")], [
    card.header([], [
      card.title([], [html.text("Invite teammates")]),
      card.description([], [
        html.text("Send a magic link to add a new member."),
      ]),
    ]),
    card.content([], [
      html.p([], [
        html.text("New members get access as soon as they accept."),
      ]),
    ]),
    card.footer([], [
      button.button([button.primary(), button.sm()], [html.text("Send invite")]),
    ]),
  ])
}
