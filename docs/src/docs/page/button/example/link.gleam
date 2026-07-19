import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn view() -> Element(message) {
  element.fragment([
    button.link([attribute.href("/get-started")], [html.text("Get Started")]),
    button.link([button.outline(), attribute.href("/docs")], [
      html.text("View Docs"),
    ]),
  ])
}
