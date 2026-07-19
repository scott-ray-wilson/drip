import lustre/attribute
import lustre/element.{type Element}
import ui/spinner

pub fn view() -> Element(message) {
  spinner.icon([attribute.class("size-5 text-muted-foreground")])
}
