import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.name("faq"), attribute.open(True)], [
      accordion.trigger([], [
        html.h3([], [html.text("Only one open at a time")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Opening a heading closes whichever section was open before, so
            there's only ever one in view.",
          ),
        ]),
      ]),
    ]),
    accordion.item([attribute.name("faq")], [
      accordion.trigger([], [
        html.h3([], [html.text("Switch between sections")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Pick a different heading and the previous one tucks itself
            away, no need to close it first.",
          ),
        ]),
      ]),
    ]),
    accordion.item([attribute.name("faq")], [
      accordion.trigger([], [
        html.h3([], [html.text("Tidy for longer answers")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Showing one section at a time keeps the page scannable even
            when each answer runs long.",
          ),
        ]),
      ]),
    ]),
  ])
}
