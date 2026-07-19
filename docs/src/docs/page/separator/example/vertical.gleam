import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/separator

pub fn view() -> Element(message) {
  html.div([attribute.class("flex h-5 items-center gap-4 text-sm")], [
    html.span([], [html.text("Inbox")]),
    separator.root([separator.vertical()], []),
    html.span([], [html.text("Drafts")]),
    separator.root([separator.vertical()], []),
    html.span([], [html.text("Sent")]),
  ])
}
