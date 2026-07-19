import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([], [
      accordion.trigger([], [
        html.h3([], [html.text("Open multiple at once")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Click a heading to expand it. Sections open independently, so
            you can keep two side by side while you read.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        html.h3([], [html.text("Click again to collapse")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Selecting an open heading hides its content. The other sections
            stay just the way you left them.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        html.h3([], [html.text("Reach it from the keyboard")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Tab moves the focus between headings; Enter or Space toggles
            the highlighted one.",
          ),
        ]),
      ]),
    ]),
  ])
}
