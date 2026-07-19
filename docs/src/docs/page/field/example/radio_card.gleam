import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  field.set([attribute.class("w-80")], [
    field.legend([], [html.text("Compute environment")]),
    field.description([], [html.text("Choose where your GPU workloads run.")]),
    field.group([], [
      field.label([], [
        field.root([field.horizontal()], [
          field.content([], [
            field.title([], [html.text("Kubernetes")]),
            field.description([], [
              html.text("Run GPU workloads on a managed K8s cluster."),
            ]),
          ]),
          radio_group.item([
            attribute.id("env-kubernetes"),
            attribute.name("compute-environment"),
            attribute.value("kubernetes"),
            attribute.checked(True),
          ]),
        ]),
      ]),
      field.label([], [
        field.root([field.horizontal()], [
          field.content([], [
            field.title([], [html.text("Virtual machine")]),
            field.description([], [
              html.text("Spin up a dedicated VM with direct GPU access."),
            ]),
          ]),
          radio_group.item([
            attribute.id("env-vm"),
            attribute.name("compute-environment"),
            attribute.value("vm"),
          ]),
        ]),
      ]),
    ]),
  ])
}
