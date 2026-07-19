import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [html.h3([], [html.text("Multi-paragraph body")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Content panels accept any markup and style paragraphs and links
            for you.",
          ),
        ]),
        html.p([attribute.class("text-muted-foreground")], [
          html.text("Read more in the "),
          html.a([attribute.href("#")], [html.text("getting started")]),
          html.text(" guide."),
        ]),
      ]),
    ]),
  ])
}
