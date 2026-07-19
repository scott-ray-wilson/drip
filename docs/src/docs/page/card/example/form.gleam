import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/card
import ui/field
import ui/text_field

pub fn view() -> Element(message) {
  card.root([attribute.class("w-[360px]")], [
    card.header([], [
      card.title([], [html.text("Sign in")]),
      card.description([], [
        html.text("Enter your credentials to access your account."),
      ]),
    ]),
    card.content([], [
      field.group([], [
        field.root(
          [
            field.vertical(),
          ],
          [
            field.label([attribute.for("login-email")], [html.text("Email")]),
            text_field.input([
              attribute.id("login-email"),
              attribute.type_("email"),
              attribute.placeholder("ada@glow.dev"),
            ]),
          ],
        ),
        field.root(
          [
            field.vertical(),
          ],
          [
            field.label([attribute.for("login-password")], [
              html.text("Password"),
            ]),
            text_field.input([
              attribute.id("login-password"),
              attribute.type_("password"),
            ]),
          ],
        ),
      ]),
    ]),
    card.footer([], [
      button.submit([button.primary(), button.full_width()], [
        html.text("Sign in"),
      ]),
    ]),
  ])
}
