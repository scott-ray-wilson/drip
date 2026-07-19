import codegen/internal/registry_json
import drip/registry
import gleam/json

// --- Registry JSON -----------------------------------------------------------

pub fn element_full_test() {
  let element =
    registry.Element(
      name: registry.Table,
      description: "A data table.",
      category: registry.DataDisplay,
      ffi: True,
      registry_dependencies: [registry.Button],
      dependencies: ["lustre"],
    )
  let files = ["table.css", "table.ffi.mjs", "table.gleam"]
  assert json.to_string(registry_json.element(#(element, files)))
    == "{\"name\":\"table\",\"description\":\"A data table.\","
    <> "\"category\":\"data_display\",\"registry_dependencies\":[\"button\"],"
    <> "\"dependencies\":[\"lustre\"],"
    <> "\"files\":[\"table.css\",\"table.ffi.mjs\",\"table.gleam\"]}"
}

pub fn element_minimal_test() {
  let element =
    registry.Element(
      name: registry.Button,
      description: "Triggers an action.",
      category: registry.Actions,
      ffi: False,
      registry_dependencies: [],
      dependencies: [],
    )
  let files = ["button.css", "button.gleam"]
  assert json.to_string(registry_json.element(#(element, files)))
    == "{\"name\":\"button\",\"description\":\"Triggers an action.\","
    <> "\"category\":\"actions\",\"registry_dependencies\":[],"
    <> "\"dependencies\":[],\"files\":[\"button.css\",\"button.gleam\"]}"
}

pub fn encode_test() {
  let element =
    registry.Element(
      name: registry.Button,
      description: "Triggers an action.",
      category: registry.Actions,
      ffi: False,
      registry_dependencies: [],
      dependencies: [],
    )
  let files = ["button.css", "button.gleam"]
  assert registry_json.encode([#(element, files)])
    == "{\"schema_version\":1,\"name\":\"drip\","
    <> "\"homepage\":\"https://drip.pink\",\"elements\":["
    <> "{\"name\":\"button\",\"description\":\"Triggers an action.\","
    <> "\"category\":\"actions\",\"registry_dependencies\":[],"
    <> "\"dependencies\":[],\"files\":[\"button.css\",\"button.gleam\"]}]}"
}
