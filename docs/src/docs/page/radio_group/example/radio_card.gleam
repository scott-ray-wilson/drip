import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/field
import ui/radio_group

pub fn view() -> Element(message) {
  radio_group.root(
    [attribute.aria_label("Pricing tier"), attribute.class("max-w-sm")],
    [
      field.label([], [
        field.root(
          [
            field.horizontal(),
          ],
          [
            radio_group.item([
              attribute.id("tier-plus"),
              attribute.name("pricing-tier"),
              attribute.value("plus"),
              attribute.checked(True),
            ]),
            field.content([], [
              field.title([], [html.text("Plus")]),
              field.description([], [
                html.text("For individuals getting started."),
              ]),
            ]),
          ],
        ),
      ]),
      field.label([], [
        field.root(
          [
            field.horizontal(),
          ],
          [
            radio_group.item([
              attribute.id("tier-pro"),
              attribute.name("pricing-tier"),
              attribute.value("pro"),
            ]),
            field.content([], [
              field.title([], [html.text("Pro")]),
              field.description([], [
                html.text("For teams that need more room to grow."),
              ]),
            ]),
          ],
        ),
      ]),
      field.label([], [
        field.root(
          [
            field.horizontal(),
          ],
          [
            radio_group.item([
              attribute.id("tier-enterprise"),
              attribute.name("pricing-tier"),
              attribute.value("enterprise"),
            ]),
            field.content([], [
              field.title([], [html.text("Enterprise")]),
              field.description([], [
                html.text("Advanced controls and dedicated support."),
              ]),
            ]),
          ],
        ),
      ]),
    ],
  )
}
