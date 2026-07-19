import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/separator

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  element.fragment([
    separator.root([attribute.class("mt-14 mb-6")], []),
    html.footer([attribute.class("w-full")], [
      html.div(
        [attribute.class("flex items-center justify-between flex-wrap gap-4")],
        [
          html.span([attribute.class("text-xs text-foreground-subtle")], [
            html.text("© 2026 Scott Wilson"),
          ]),
          html.div([attribute.class("flex items-center gap-6")], [
            link("https://github.com/scott-ray-wilson/drip", "GitHub"),
            link("https://github.com/lustre-labs/lustre", "Lustre"),
            link("https://gleam.run", "Gleam"),
          ]),
        ],
      ),
    ]),
  ])
}

fn link(href: String, label: String) -> Element(message) {
  html.a(
    [
      attribute.href(href),
      attribute.target("_blank"),
      attribute.rel("noopener noreferrer"),
      attribute.class(
        "text-xs text-foreground-subtle hover:text-muted-foreground",
      ),
      attribute.class("rounded-xs outline-offset-1 focus-visible:outline-2"),
      attribute.class("focus-visible:ring-outline focus-visible:ring"),
      attribute.class("transition-colors duration-100"),
    ],
    [html.text(label)],
  )
}
