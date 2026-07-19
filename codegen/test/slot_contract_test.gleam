//// Gleam<->CSS slot contract. Every `data-slot` an element can stamp (from its
//// Gleam source or its FFI) must be styled by some UI stylesheet, and every
//// slot the CSS targets must be stamped somewhere. The compiler guards neither
//// side: a typo or a one-sided rename ships silently unstyled. This pins the
//// seam across the whole `ui/` tree so drift fails the build.

import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

// --- Configuration -----------------------------------------------------------

// The element source tree, relative to `codegen/`, where `gleam test` runs.
const ui_source: String = "../ui/src/ui"

// --- Tests -------------------------------------------------------------------

// Forward: a slot the Gleam or FFI can stamp with no CSS rule ships unstyled.
// Every emitted slot must be styled; there are no exceptions.
pub fn every_emitted_slot_is_styled_test() {
  let styled = css_slots()
  let orphans =
    emitted_slots()
    |> set.to_list
    |> list.filter(fn(slot) { !set.contains(styled, slot) })
    |> list.sort(string.compare)
  assert orphans == []
}

// Reverse: a `[data-slot="x"]` selector no element stamps is dead or renamed.
pub fn every_styled_slot_is_emitted_test() {
  let emitted = emitted_slots()
  let dead =
    css_slots()
    |> set.to_list
    |> list.filter(fn(slot) { !set.contains(emitted, slot) })
    |> list.sort(string.compare)
  assert dead == []
}

// --- Slot Extraction ---------------------------------------------------------

fn emitted_slots() -> Set(String) {
  let from_gleam =
    read_sources(".gleam")
    |> list.flat_map(extract(_, "data(\"slot\", \""))
  let from_ffi =
    read_sources(".mjs")
    |> list.flat_map(extract(_, "data-slot=\""))
  set.from_list(list.append(from_gleam, from_ffi))
}

fn css_slots() -> Set(String) {
  read_sources(".css")
  |> list.flat_map(extract(_, "data-slot=\""))
  |> set.from_list
}

// Every value sitting between `prefix` and the next `"` in `source`.
fn extract(source: String, prefix: String) -> List(String) {
  source
  |> string.split(prefix)
  |> list.drop(1)
  |> list.filter_map(fn(chunk) {
    case string.split_once(chunk, "\"") {
      Ok(#(value, _)) -> Ok(value)
      Error(Nil) -> Error(Nil)
    }
  })
}

// --- File Reading ------------------------------------------------------------

fn read_sources(extension: String) -> List(String) {
  let assert Ok(filenames) = simplifile.read_directory(ui_source)
    as { "slot contract: could not read " <> ui_source }
  filenames
  |> list.filter(string.ends_with(_, extension))
  |> list.map(fn(name) {
    let assert Ok(content) = simplifile.read(ui_source <> "/" <> name)
      as { "slot contract: could not read " <> name }
    content
  })
}
