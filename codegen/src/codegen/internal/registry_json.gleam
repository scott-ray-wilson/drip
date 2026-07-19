//// Encodes the listed registry elements into the `registry.json` index the
//// `drip` CLI fetches at runtime.

import drip/registry.{type Category, type Element}
import gleam/json.{type Json}

// --- Registry JSON -----------------------------------------------------------

// The `registry.json` format version. Bump ONLY on a breaking change: additive
//  fields stay forward-compatible via the CLI's unknown-field tolerance.
const schema_version: Int = 1

pub fn encode(elements: List(#(Element, List(String)))) -> String {
  json.object([
    #("schema_version", json.int(schema_version)),
    #("name", json.string("drip")),
    #("homepage", json.string("https://drip.pink")),
    #("elements", json.array(elements, element)),
  ])
  |> json.to_string
}

pub fn element(pair: #(Element, List(String))) -> Json {
  let #(element, files) = pair
  json.object([
    #("name", json.string(registry.to_string(element.name))),
    #("description", json.string(element.description)),
    #("category", json.string(category_to_slug(element.category))),
    #(
      "registry_dependencies",
      json.array(element.registry_dependencies, fn(dependency) {
        json.string(registry.to_string(dependency))
      }),
    ),
    #("dependencies", json.array(element.dependencies, json.string)),
    #("files", json.array(files, json.string)),
  ])
}

fn category_to_slug(category: Category) -> String {
  case category {
    registry.Forms -> "forms"
    registry.Actions -> "actions"
    registry.Navigation -> "navigation"
    registry.Overlay -> "overlay"
    registry.Disclosure -> "disclosure"
    registry.Layout -> "layout"
    registry.DataDisplay -> "data_display"
    registry.Feedback -> "feedback"
  }
}
