import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.set([attribute.class("w-72")], [
    field.legend_label([], [html.text("Email preferences")]),
    field.description([], [
      html.text("Choose which updates Drip sends to your inbox."),
    ]),
    field.group([], [
      field.root([field.horizontal()], [
        checkbox.input([
          attribute.id("group-product"),
          attribute.checked(True),
        ]),
        field.label([attribute.for("group-product")], [
          html.text("Product updates"),
        ]),
      ]),
      field.root([field.horizontal()], [
        checkbox.input([
          attribute.id("group-security"),
          attribute.checked(True),
        ]),
        field.label([attribute.for("group-security")], [
          html.text("Security alerts"),
        ]),
      ]),
      field.root([field.horizontal()], [
        checkbox.input([attribute.id("group-newsletter")]),
        field.label([attribute.for("group-newsletter")], [
          html.text("Weekly newsletter"),
        ]),
      ]),
      field.root([field.horizontal()], [
        checkbox.input([attribute.id("group-offers")]),
        field.label([attribute.for("group-offers")], [
          html.text("Partner offers"),
        ]),
      ]),
    ]),
  ])
}
