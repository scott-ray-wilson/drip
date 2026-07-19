import lustre
import lustre/element.{type Element}
import lustre/element/html
import ui/button

pub fn main() -> Nil {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view() -> Element(message) {
  button.button([button.accent()], [html.text("Hello, drip")])
}
