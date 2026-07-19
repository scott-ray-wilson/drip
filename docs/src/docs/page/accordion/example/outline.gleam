import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.outline(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [html.h3([], [html.text("General")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Set your display name, language, and time zone. These appear
            across the app and in any documents you share.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Notifications")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Choose which events send you email or in-app alerts. Granular
            per channel and per mentionable thread.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Privacy & security")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Manage active sessions, enable two-factor auth, and review
            recent account activity in the audit log.",
          ),
        ]),
      ]),
    ]),
  ])
}
