import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/separator
import ui/typography

pub fn view() -> Element(message) {
  html.div([attribute.class("flex flex-col gap-3 w-[320px]")], [
    typography.body([], [html.text("Above the line.")]),
    separator.root([separator.horizontal()], []),
    typography.body([], [html.text("Below the line.")]),
  ])
}
