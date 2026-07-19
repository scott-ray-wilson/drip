import docs/element_icon
import docs/route.{type Route}
import drip/registry
import gleam/list
import lustre/element.{type Element}

// --- Element Navigation ------------------------------------------------------

// The registry-derived element nav, shared by the sidebar sub-nav and the
// search palette so both stay in sync from one projection.

pub fn items() -> List(#(Route, Element(message), String, String)) {
  registry.all
  |> list.map(fn(entry) {
    #(
      route.Element(entry.name),
      element_icon.for_category(entry.category, []),
      registry.title(entry.name),
      entry.description,
    )
  })
}
