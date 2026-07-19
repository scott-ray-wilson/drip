import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/empty

pub fn view() -> Element(message) {
  empty.root([], [
    empty.header([], [
      empty.media([], [
        html.img([
          attribute.src("/img/avatar.jpg"),
          attribute.alt("Your profile photo"),
          attribute.class("size-12 rounded-full"),
        ]),
      ]),
      empty.title([], [html.text("No recent activity")]),
      empty.description([], [
        html.text(
          "You haven't opened a dashboard in a while.
          Pick up where you left off.",
        ),
      ]),
    ]),
  ])
}
