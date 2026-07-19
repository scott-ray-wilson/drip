import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/checkbox
import ui/field

pub fn view() -> Element(message) {
  field.root([field.vertical(), attribute.class("w-fit")], [
    field.root([field.horizontal()], [
      checkbox.input([
        attribute.id("disabled-sync"),
        attribute.disabled(True),
      ]),
      field.label([attribute.for("disabled-sync")], [
        html.text("Sync across devices"),
      ]),
    ]),
    field.root([field.horizontal()], [
      checkbox.input([
        attribute.id("disabled-backup"),
        attribute.disabled(True),
        attribute.checked(True),
      ]),
      field.label([attribute.for("disabled-backup")], [
        html.text("Back up automatically"),
      ]),
    ]),
  ])
}
