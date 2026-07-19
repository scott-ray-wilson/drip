import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/spinner

pub fn view() -> Element(message) {
  html.div(
    [
      attribute.class(
        "inline-flex items-center gap-2 text-sm text-muted-foreground",
      ),
    ],
    [spinner.icon([]), html.text("Loading…")],
  )
}
