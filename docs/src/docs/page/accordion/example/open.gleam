import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [html.h3([], [html.text("Open by default")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Pass the open attribute to render an item in its expanded
            state on first paint.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Closed by default")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Items default to closed when the open attribute is omitted.",
          ),
        ]),
      ]),
    ]),
  ])
}
