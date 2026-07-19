import drip/internal/error
import drip/internal/registry.{type Element}
import drip/internal/source
import gleam/json.{type Json}
import gleam/list
import helpers
import simplifile

// --- Fetch -------------------------------------------------------------------

pub fn fetch_reads_valid_registry_test() {
  use directory <- helpers.with_temp_directory("drip_registry_valid")
  write_registry(directory, registry_with("\"schema_version\":1,"))
  let assert Ok(source) = source.parse(directory)
  let assert Ok(index) = registry.fetch(source)
  assert index
    == [
      registry.Element(
        name: "button",
        registry_dependencies: [],
        dependencies: [],
        files: ["button.gleam"],
      ),
    ]
}

pub fn fetch_rejects_newer_schema_version_test() {
  use directory <- helpers.with_temp_directory("drip_registry_schema_new")
  write_registry(directory, registry_with("\"schema_version\":2,"))
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.UnsupportedRegistrySchemaVersion(
    found: 2,
    supported: 1,
  )) = registry.fetch(source)
}

pub fn fetch_rejects_missing_schema_version_test() {
  use directory <- helpers.with_temp_directory("drip_registry_schema_missing")
  write_registry(directory, registry_with(""))
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.FailedToDecodeRegistryFile(_, _)) =
    registry.fetch(source)
}

pub fn fetch_errors_on_malformed_json_test() {
  use directory <- helpers.with_temp_directory("drip_registry_malformed")
  write_registry(directory, "{ not valid json")
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.FailedToDecodeRegistryFile(_, _)) =
    registry.fetch(source)
}

pub fn fetch_errors_on_wrong_shape_test() {
  use directory <- helpers.with_temp_directory("drip_registry_wrong_shape")
  write_registry(
    directory,
    "{\"schema_version\":1,\"elements\":[{\"name\":\"button\"}]}",
  )
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.FailedToDecodeRegistryFile(_, _)) =
    registry.fetch(source)
}

pub fn fetch_decodes_http_registry_test() {
  use port <- helpers.with_server(fn(_request) {
    helpers.respond(200, registry_with("\"schema_version\":1,"))
  })
  let assert Ok(source) = source.parse(helpers.base_url(port))
  let assert Ok(index) = registry.fetch(source)
  assert index
    == [
      registry.Element(
        name: "button",
        registry_dependencies: [],
        dependencies: [],
        files: ["button.gleam"],
      ),
    ]
}

// A registry entry whose file path escapes the install directory is
// rejected before any of it is fetched or written.
pub fn fetch_rejects_parent_traversal_in_files_test() {
  use directory <- helpers.with_temp_directory("drip_registry_unsafe_parent")
  write_registry(directory, registry_with_files(["../../sketch.gleam"]))
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.UnsupportedRegistryFile(
    element: "button",
    file: "../../sketch.gleam",
  )) = registry.fetch(source)
}

pub fn fetch_rejects_separator_in_files_test() {
  use directory <- helpers.with_temp_directory("drip_registry_unsafe_sep")
  write_registry(directory, registry_with_files(["nested/button.gleam"]))
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.UnsupportedRegistryFile(
    file: "nested/button.gleam",
    ..,
  )) = registry.fetch(source)
}

// --- Decoding ----------------------------------------------------------------

// decode and schema-version parsing run through the public fetch.

pub fn fetch_reads_rich_registry_test() {
  let entries = [
    element("button", ["button.gleam"]),
    registry.Element(
      name: "input_group",
      registry_dependencies: ["button", "input"],
      dependencies: ["lustre", "gleam_stdlib"],
      files: ["input_group.gleam", "input_group.ffi.mjs"],
    ),
  ]
  use directory <- helpers.with_temp_directory("drip_registry_rich")
  write_registry(directory, registry_body(1, entries))
  let assert Ok(source) = source.parse(directory)
  assert registry.fetch(source) == Ok(entries)
}

pub fn fetch_reads_empty_registry_test() {
  use directory <- helpers.with_temp_directory("drip_registry_empty")
  write_registry(directory, registry_body(1, []))
  let assert Ok(source) = source.parse(directory)
  assert registry.fetch(source) == Ok([])
}

pub fn fetch_errors_when_elements_key_missing_test() {
  use directory <- helpers.with_temp_directory("drip_registry_no_elements")
  write_registry(directory, "{\"schema_version\":1}")
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.FailedToDecodeRegistryFile(_, _)) =
    registry.fetch(source)
}

// A future schema may reshape elements, but the version must still
// be read so we report an upgrade prompt rather than a decode error.
pub fn fetch_rejects_newer_schema_version_in_unreadable_body_test() {
  let body =
    json.object([
      #("schema_version", json.int(2)),
      #("elements", json.string("reshaped by a future schema")),
    ])
    |> json.to_string
  use directory <- helpers.with_temp_directory("drip_registry_future")
  write_registry(directory, body)
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.UnsupportedRegistrySchemaVersion(
    found: 2,
    supported: 1,
  )) = registry.fetch(source)
}

// --- Resolve -----------------------------------------------------------------

pub fn resolve_orders_dependencies_before_dependents_test() {
  let registry = [
    dependency_element("a", ["b"]),
    dependency_element("b", ["c"]),
    dependency_element("c", []),
  ]
  let assert Ok(resolved) = registry.resolve_elements(registry, ["a"])
  assert names(resolved) == ["c", "b", "a"]
}

pub fn resolve_deduplicates_shared_dependencies_test() {
  let registry = [
    dependency_element("a", ["b", "c"]),
    dependency_element("b", ["d"]),
    dependency_element("c", ["d"]),
    dependency_element("d", []),
  ]
  let assert Ok(resolved) = registry.resolve_elements(registry, ["a"])
  // d is shared by b and c but vendored once, ahead of both.
  assert names(resolved) == ["d", "b", "c", "a"]
}

// A cycle is a producer bug, but we ensure it doesn't
// hang or fail a consumer's add.
pub fn resolve_tolerates_cycles_test() {
  let registry = [
    dependency_element("a", ["b"]),
    dependency_element("b", ["a"]),
  ]
  let assert Ok(resolved) = registry.resolve_elements(registry, ["a"])
  assert names(resolved) == ["b", "a"]
}

pub fn resolve_errors_on_unknown_element_test() {
  let registry = [dependency_element("a", [])]
  assert registry.resolve_elements(registry, ["missing"])
    == Error(error.UnknownElement("missing"))
}

// --- Helpers -----------------------------------------------------------------

fn element(name: String, files: List(String)) -> Element {
  registry.Element(name:, registry_dependencies: [], dependencies: [], files:)
}

fn dependency_element(name: String, deps: List(String)) -> Element {
  registry.Element(name:, registry_dependencies: deps, dependencies: [], files: [
    name <> ".gleam",
  ])
}

fn names(elements: List(Element)) -> List(String) {
  list.map(elements, fn(entry) { entry.name })
}

fn element_json(element: Element) -> Json {
  json.object([
    #("name", json.string(element.name)),
    #(
      "registry_dependencies",
      json.array(element.registry_dependencies, json.string),
    ),
    #("dependencies", json.array(element.dependencies, json.string)),
    #("files", json.array(element.files, json.string)),
  ])
}

fn write_registry(directory: String, contents: String) -> Nil {
  let assert Ok(Nil) =
    simplifile.write(to: directory <> "/registry.json", contents:)

  Nil
}

fn registry_with(fields: String) -> String {
  "{"
  <> fields
  <> "\"elements\":[{\"name\":\"button\",\"registry_dependencies\":[],"
  <> "\"dependencies\":[],\"files\":[\"button.gleam\"]}]}"
}

fn registry_body(version: Int, elements: List(Element)) -> String {
  json.object([
    #("schema_version", json.int(version)),
    #("elements", json.array(elements, element_json)),
  ])
  |> json.to_string
}

fn registry_with_files(files: List(String)) -> String {
  registry_body(1, [element("button", files)])
}
