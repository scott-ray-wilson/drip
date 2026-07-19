import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Available")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text("This row toggles normally."),
        ]),
      ]),
    ]),
    accordion.item([attribute.inert(True)], [
      accordion.trigger([], [html.h3([], [html.text("Coming soon")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Mark an item with inert to dim it visually and remove it from
            the focus order.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Also available")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text("Disabled items don't break the keyboard tab order."),
        ]),
      ]),
    ]),
  ])
}
