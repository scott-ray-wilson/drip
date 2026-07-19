import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/separator

pub fn view() -> Element(message) {
  html.div([attribute.class("flex flex-col gap-3 w-[320px]")], [
    button.button([button.primary()], [html.text("Sign in with email")]),
    separator.root([], [html.text("or")]),
    button.button([button.outline()], [
      html.text("Continue with a single-use link"),
    ]),
  ])
}
