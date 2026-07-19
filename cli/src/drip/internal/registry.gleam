import drip/internal/error.{type Error}
import drip/internal/source.{type Source}
import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type DecodeError}
import gleam/list
import gleam/result
import gleam/string

// --- Registry ----------------------------------------------------------------

pub type Registry =
  List(Element)

pub type Element {
  Element(
    name: String,
    registry_dependencies: List(String),
    dependencies: List(String),
    files: List(String),
  )
}

// --- Fetch -------------------------------------------------------------------

const registry_file = "registry.json"

pub fn fetch(source: Source) -> Result(Registry, Error) {
  use body <- result.try(source.fetch(source, registry_file))
  use _ <- result.try(validate_schema_version(body))
  use registry <- result.try(
    decode(body)
    |> result.map_error(fn(cause) {
      error.FailedToDecodeRegistryFile(registry_file, cause)
    }),
  )
  use _ <- result.try(validate_files(registry))
  Ok(registry)
}

const supported_schema_version = 1

fn validate_schema_version(body: String) -> Result(Nil, Error) {
  case decode_schema_version(body) {
    Ok(version) ->
      case version <= supported_schema_version {
        True -> Ok(Nil)
        False ->
          Error(error.UnsupportedRegistrySchemaVersion(
            found: version,
            supported: supported_schema_version,
          ))
      }
    Error(cause) ->
      Error(error.FailedToDecodeRegistryFile(registry_file, cause))
  }
}

// drip vendors files flat into src/<prefix>, so reject anything that isn't a
// plain filename: separators escape or nest, and the CLI manages only the top
// level (remove and index derivation read the vendor dir non-recursively).
fn validate_files(registry: Registry) -> Result(Nil, Error) {
  use element <- list.try_each(registry)
  use file <- list.try_each(element.files)
  case is_supported_filename(file) {
    True -> Ok(Nil)
    False -> Error(error.UnsupportedRegistryFile(element: element.name, file:))
  }
}

fn is_supported_filename(filename: String) -> Bool {
  filename != ""
  && filename != "."
  && filename != ".."
  && !has_separator(filename)
}

fn has_separator(filename: String) -> Bool {
  string.contains(filename, "/") || string.contains(filename, "\\")
}

// --- Decoding ----------------------------------------------------------------

// Decode schema version separate from registry to cleanly version gate and
// prompt users to upgrade cli.
fn decode_schema_version(json: String) -> Result(Int, DecodeError) {
  json.parse(json, schema_version_decoder())
}

fn schema_version_decoder() -> Decoder(Int) {
  use version <- decode.field("schema_version", decode.int)
  decode.success(version)
}

fn decode(json: String) -> Result(Registry, DecodeError) {
  json.parse(json, registry_decoder())
}

fn registry_decoder() -> Decoder(Registry) {
  use elements <- decode.field("elements", decode.list(element_decoder()))
  decode.success(elements)
}

fn element_decoder() -> Decoder(Element) {
  use name <- decode.field("name", decode.string)
  use registry_dependencies <- decode.field(
    "registry_dependencies",
    decode.list(decode.string),
  )
  use dependencies <- decode.field("dependencies", decode.list(decode.string))
  use files <- decode.field("files", decode.list(decode.string))
  decode.success(Element(name:, registry_dependencies:, dependencies:, files:))
}

// --- Resolution --------------------------------------------------------------

fn find(registry: Registry, name: String) -> Result(Element, Nil) {
  list.find(registry, fn(element) { element.name == name })
}

// Resolve requested elements and their dependencies so we can vendor everything
// the user requires without explicitly requesting any registry dependencies.
pub fn resolve_elements(
  registry: Registry,
  names: List(String),
) -> Result(List(Element), Error) {
  use Walk(acc:, ..) <- result.map(visit_all(names, registry, [], []))
  list.reverse(acc)
}

type Walk {
  Walk(seen: List(String), acc: List(Element))
}

fn visit_all(
  names: List(String),
  registry: Registry,
  seen: List(String),
  acc: List(Element),
) -> Result(Walk, Error) {
  case names {
    [] -> Ok(Walk(seen:, acc:))
    [name, ..rest] -> {
      use Walk(seen:, acc:) <- result.try(visit(name, registry, seen, acc))
      visit_all(rest, registry, seen, acc)
    }
  }
}

fn visit(
  name: String,
  registry: Registry,
  seen: List(String),
  acc: List(Element),
) -> Result(Walk, Error) {
  case list.contains(seen, name) {
    True -> Ok(Walk(seen:, acc:))
    False ->
      case find(registry, name) {
        Error(Nil) -> Error(error.UnknownElement(name))
        Ok(element) -> {
          // Mark before recursing so a dependency pointing back here terminates.
          use Walk(seen:, acc:) <- result.map(visit_all(
            element.registry_dependencies,
            registry,
            [name, ..seen],
            acc,
          ))
          // Append after dependencies so they land ahead of this element.
          Walk(seen:, acc: [element, ..acc])
        }
      }
  }
}
