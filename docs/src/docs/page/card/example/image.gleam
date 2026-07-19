import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/card

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[320px]")], [
    html.img([
      attribute.src("/img/ridgeline-moonlight.svg"),
      attribute.alt("Moonlight and stars over layered mountain ridges"),
      attribute.class("block dark:hidden aspect-video w-full object-cover"),
    ]),
    html.img([
      attribute.src("/img/ridgeline-sunrise.svg"),
      attribute.alt("Sunrise over layered mountain ridges"),
      attribute.class("hidden dark:block aspect-video w-full object-cover"),
    ]),
    card.header([], [
      card.eyebrow([], [html.text("Featured")]),
      card.title([], [html.text("Ridgeline Overlook")]),
      card.description([], [html.text("From first light to the last star.")]),
    ]),
  ])
}
