import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/spinner

pub fn view() -> Element(message) {
  button.button([attribute.aria_busy(True), attribute.disabled(True)], [
    spinner.icon([]),
    html.text("Saving"),
  ])
}
