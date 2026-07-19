import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion
import ui/icon

pub fn view() -> Element(message) {
  accordion.root([accordion.filled(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [
        icon.box([]),
        html.h3([], [html.text("Starter")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Free for hobby projects. Up to three collaborators, 1 GB of
            storage, and community support.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        icon.zap([]),
        html.h3([], [html.text("Pro")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "$12 per user per month. Unlimited collaborators, 100 GB of
            storage, priority email support, and SSO.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        icon.shield([]),
        html.h3([], [html.text("Enterprise")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Custom pricing. Dedicated infrastructure, SAML/SCIM, 24/7
            support, and signed SLAs.",
          ),
        ]),
      ]),
    ]),
  ])
}
