import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  radio_group.root(
    [attribute.aria_label("Workspace plan"), attribute.class("w-fit max-w-sm")],
    [
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-starter"),
          attribute.name("workspace-plan"),
          attribute.value("starter"),
          attribute.checked(True),
        ]),
        field.content([], [
          field.label([attribute.for("plan-starter")], [html.text("Starter")]),
          field.description([], [
            html.text("Up to 5 projects and 2 GB of storage."),
          ]),
        ]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-team"),
          attribute.name("workspace-plan"),
          attribute.value("team"),
        ]),
        field.content([], [
          field.label([attribute.for("plan-team")], [html.text("Team")]),
          field.description([], [
            html.text("Unlimited projects and 100 GB of storage."),
          ]),
        ]),
      ]),
      field.root([field.horizontal()], [
        radio_group.item([
          attribute.id("plan-enterprise"),
          attribute.name("workspace-plan"),
          attribute.value("enterprise"),
        ]),
        field.content([], [
          field.label([attribute.for("plan-enterprise")], [
            html.text("Enterprise"),
          ]),
          field.description([], [
            html.text("Dedicated support and a custom contract."),
          ]),
        ]),
      ]),
    ],
  )
}
