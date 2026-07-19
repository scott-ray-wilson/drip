import lustre/attribute
import lustre/element.{type Element}
import ui/spinner

pub fn view() -> Element(message) {
  element.fragment([
    spinner.icon([attribute.class("size-3")]),
    spinner.icon([attribute.class("size-5")]),
    spinner.icon([attribute.class("size-7")]),
    spinner.icon([attribute.class("size-9")]),
  ])
}
