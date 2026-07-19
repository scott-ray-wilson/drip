import drip/registry
import gleam/list
import gleeunit

// --- Main --------------------------------------------------------------------

pub fn main() -> Nil {
  gleeunit.main()
}

// --- Registry ----------------------------------------------------------------

pub fn all_contains_button_test() {
  let assert Ok(_) = registry.find(registry.all, registry.Button)
}

pub fn from_string_test() {
  let assert Ok(registry.Button) = registry.from_string("button")
  let assert Error(_) = registry.from_string("nope")
}

pub fn to_string_test() {
  assert registry.to_string(registry.ButtonGroup) == "button_group"
  assert registry.to_string(registry.TextField) == "text_field"
}

pub fn metadata_fields_test() {
  let assert Ok(field) = registry.find(registry.all, registry.Field)
  assert field.registry_dependencies == [registry.Separator]
  assert field.category == registry.Forms

  let assert Ok(button) = registry.find(registry.all, registry.Button)
  assert !button.ffi
  assert button.dependencies == []
}

// The v1 catalog is script-free: the docs promise plain Gleam and CSS. Adding an
// ffi element means restoring the script prose in the docs first.
pub fn no_element_ships_a_script_test() {
  assert !list.any(registry.all, fn(element) { element.ffi })
}

// --- Source-Data Integrity ---------------------------------------------------

pub fn every_dependency_resolves_test() {
  let names = list.map(registry.all, fn(element) { element.name })
  // ensure all registry dependencies are present in the registry.
  assert registry.all
    |> list.flat_map(fn(element) { element.registry_dependencies })
    |> list.all(list.contains(names, _))
}
