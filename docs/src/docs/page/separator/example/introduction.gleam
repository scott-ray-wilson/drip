import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/separator
import ui/typography

pub fn view() -> Element(message) {
  html.div([attribute.class("flex flex-col gap-4 w-[320px]")], [
    typography.body([], [html.text("A horizontal separator splits stacks.")]),
    separator.root([], []),
    html.div([attribute.class("flex h-5 items-center gap-4 text-sm")], [
      html.span([], [html.text("Docs")]),
      separator.root([separator.vertical()], []),
      html.span([], [html.text("Source")]),
      separator.root([separator.vertical()], []),
      html.span([], [html.text("Issues")]),
    ]),
  ])
}
