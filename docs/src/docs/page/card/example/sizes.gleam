import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/card

pub fn view() -> Element(message) {
  element.fragment([
    card.root([card.sm(), attribute.class("w-[260px]")], [
      card.header([], [
        card.title([], [html.text("Small")]),
        card.description([], [html.text("Compact and efficient.")]),
      ]),
      card.content([], [
        html.p([], [html.text("Tighter spacing for dense layouts.")]),
      ]),
    ]),
    card.root([card.md(), attribute.class("w-[260px]")], [
      card.header([], [
        card.title([], [html.text("Medium (default)")]),
        card.description([], [html.text("A balanced baseline.")]),
      ]),
      card.content([], [
        html.p([], [html.text("Standard spacing for most content.")]),
      ]),
    ]),
    card.root([card.lg(), attribute.class("w-[320px]")], [
      card.header([], [
        card.title([], [html.text("Large")]),
        card.description([], [html.text("Spacious and prominent.")]),
      ]),
      card.content([], [
        html.p([], [html.text("Roomier padding for hero blocks.")]),
      ]),
    ]),
  ])
}
