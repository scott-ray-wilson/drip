import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost()], [
    accordion.item([], [
      accordion.trigger([], [html.text("Question")]),
      accordion.content([], [html.text("Answer")]),
    ]),
  ])
}
