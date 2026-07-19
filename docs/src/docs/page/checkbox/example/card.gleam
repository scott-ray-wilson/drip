import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.label([attribute.class("max-w-72")], [
    field.root([field.horizontal()], [
      checkbox.input([attribute.checked(True)]),
      field.content([], [
        field.title([], [html.text("Enable notifications")]),
        field.description([], [
          html.text("You can enable or disable notifications at any time."),
        ]),
      ]),
    ]),
  ])
}
