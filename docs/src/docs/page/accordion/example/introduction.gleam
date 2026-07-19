import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [html.h3([], [html.text("What is Drip?")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Drip is an element registry for Lustre: small Gleam
            modules paired with per-element CSS.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("How do I install it?")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text("Run "),
          html.span([attribute.class("font-medium")], [html.text("drip init")]),
          html.text(" to scaffold the config and stylesheet, then "),
          html.span([attribute.class("font-medium")], [
            html.text("drip add <element>"),
          ]),
          html.text(" to pull in an element."),
        ]),
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Alternatively, copy the code straight from the
            docs into your project's src/ui/ folder.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        html.h3([], [html.text("Can I customize an element?")]),
      ]),
      accordion.content([attribute.class("text-muted-foreground")], [
        html.p([], [
          html.text(
            "Yes. Once an element is in your src/ui/ folder it's your code.
            Edit the Gleam markup or tweak the CSS to fit your design.",
          ),
        ]),
      ]),
    ]),
  ])
}
