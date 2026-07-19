import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion

pub fn view() -> Element(message) {
  accordion.root([accordion.ghost(), attribute.class("w-96")], [
    accordion.item([attribute.open(True)], [
      accordion.trigger([], [html.h3([], [html.text("Materials")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "100% organic cotton, pre-shrunk and garment-dyed for a softer
            hand and a lived-in feel.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Care")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Machine wash cold with like colors. Tumble dry low or hang
            to preserve the print.",
          ),
        ]),
      ]),
    ]),
    accordion.item([], [
      accordion.trigger([], [html.h3([], [html.text("Shipping & returns")])]),
      accordion.content([], [
        html.p([attribute.class("text-muted-foreground")], [
          html.text(
            "Free standard shipping on orders over $50. Returns accepted
            within 30 days, tags attached.",
          ),
        ]),
      ]),
    ]),
  ])
}
