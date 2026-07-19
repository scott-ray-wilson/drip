import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion
import ui/icon

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [
        icon.user([]),
        html.h3([], [html.text("Account")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Update your name, email, and the avatar shown next to your
            comments.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        icon.shield([]),
        html.h3([], [html.text("Security")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Turn on two-factor authentication and review the devices signed
            in to your account.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [
        icon.layout_template([]),
        html.h3([], [html.text("Workspace")]),
      ]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Rename the workspace, set its default landing page, and manage
            shared templates.",
          ),
        ]),
      ]),
    ]),
  ])
}
