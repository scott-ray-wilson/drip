import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon
import ui/spinner

pub fn view() -> Element(message) {
  element.fragment([
    button.button(
      [
        button.secondary(),
        attribute.aria_busy(True),
        attribute.disabled(True),
        button.xs(),
      ],
      [spinner.icon([]), html.text("Secondary")],
    ),
    button.button(
      [
        button.outline(),
        attribute.aria_busy(True),
        attribute.disabled(True),
        button.sm(),
      ],
      [spinner.icon([]), html.text("Outline")],
    ),
    button.button(
      [
        button.destructive(),
        attribute.aria_busy(True),
        attribute.disabled(True),
      ],
      [
        spinner.icon([]),
        html.text("Destructive"),
      ],
    ),
    button.button(
      [
        attribute.aria_busy(True),
        attribute.disabled(True),
        button.icon_only(),
        button.lg(),
        attribute.aria_label("Next"),
      ],
      [spinner.icon([]), icon.arrow_right([])],
    ),
  ])
}
