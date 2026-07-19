import drip/internal/error
import drip/internal/project
import drip/internal/source
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import helpers
import simplifile
import tomlet

// --- Load Project ------------------------------------------------------------

pub fn load_from_finds_root_in_place_test() {
  use directory <- helpers.with_temp_directory("drip_root_in_place")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)
  assert project.root(project) == directory
}

pub fn load_from_walks_up_to_ancestor_root_test() {
  use directory <- helpers.with_temp_directory("drip_root_above")
  write_gleam_toml(directory)
  let nested_directory = directory <> "/a/b/c"
  let assert Ok(Nil) = simplifile.create_directory_all(nested_directory)
  let assert Ok(project) = project.load_from(nested_directory)
  assert simplifile.is_file(project.root(project) <> "/gleam.toml") == Ok(True)
}

pub fn load_from_errors_when_no_root_test() {
  use directory <- helpers.with_temp_directory("drip_no_root")
  let assert Error(error.FailedToFindProjectRoot(_)) =
    project.load_from(directory)
}

// --- Prefix ------------------------------------------------------------------

pub fn load_from_accepts_nested_prefix_test() {
  use directory <- helpers.with_temp_directory("drip_prefix_nested")
  write_drip_toml(directory, "lib/ui")
  let assert Ok(project) = project.load_from(directory)
  assert project.prefix(project) == "lib/ui"
}

pub fn load_from_defaults_prefix_when_unset_test() {
  use directory <- helpers.with_temp_directory("drip_prefix_default")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)
  assert project.prefix(project) == "ui"
}

pub fn load_from_rejects_traversal_prefix_test() {
  use directory <- helpers.with_temp_directory("drip_prefix_traversal")
  write_drip_toml(directory, "../../etc")
  let assert Error(error.InvalidPrefix(_)) = project.load_from(directory)
}

pub fn load_from_rejects_non_string_prefix_test() {
  use directory <- helpers.with_temp_directory("drip_prefix_non_string")
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n\n[tools.drip]\nprefix = 123\n",
    )
  let assert Error(error.FailedToGetGleamTomlValue(tomlet.WrongType(
    ["tools", "drip", "prefix"],
    _,
  ))) = project.load_from(directory)
}

// --- Source ------------------------------------------------------------------

pub fn load_from_reads_source_test() {
  use directory <- helpers.with_temp_directory("drip_source_set")
  write_drip_source_toml(directory, "https://mirror.test/dist/")
  let assert Ok(project) = project.load_from(directory)
  let assert Ok(expected) = source.parse("https://mirror.test/dist/")
  assert project.source(project) == expected
}

pub fn load_from_defaults_source_to_release_when_unset_test() {
  use directory <- helpers.with_temp_directory("drip_source_default")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)
  let assert Ok(expected) =
    source.parse(
      "https://github.com/scott-ray-wilson/drip/releases/latest/download",
    )
  assert project.source(project) == expected
}

pub fn load_from_rejects_non_string_source_test() {
  use directory <- helpers.with_temp_directory("drip_source_non_string")
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n\n[tools.drip]\nsource = 123\n",
    )
  let assert Error(error.FailedToGetGleamTomlValue(tomlet.WrongType(
    ["tools", "drip", "source"],
    _,
  ))) = project.load_from(directory)
}

pub fn load_from_rejects_invalid_source_url_test() {
  use directory <- helpers.with_temp_directory("drip_source_invalid_url")
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n\n[tools.drip]\nsource = \"http://has space\"\n",
    )
  let assert Error(error.InvalidSourceUrl("http://has space")) =
    project.load_from(directory)
}

// --- With Overrides ----------------------------------------------------------

pub fn with_overrides_rejects_invalid_prefix_test() {
  use directory <- helpers.with_temp_directory("drip_with_prefix_invalid")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Error(error.InvalidPrefix("../sketch")) =
    project.with_overrides(project, prefix: Some("../sketch"), source: None)
}

pub fn with_overrides_rejects_invalid_source_test() {
  use directory <- helpers.with_temp_directory("drip_with_source_invalid")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Error(error.InvalidSourceUrl("http://has space")) =
    project.with_overrides(
      project,
      prefix: None,
      source: Some("http://has space"),
    )
}

// --- Write Settings ----------------------------------------------------------

pub fn write_settings_appends_table_when_absent_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_append")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Ok([project.Modified(_)]) =
    project.write_settings(project, prefix: Some("lib"), source: None)

  // A fresh table opens its own stanza, separated from the existing content by
  // a newline.
  assert simplifile.read(directory <> "/gleam.toml")
    == Ok("name = \"app\"\n\n[tools.drip]\nprefix = \"lib\"\n")
}

pub fn write_settings_adds_key_to_existing_table_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_add_key")
  write_drip_source_toml(directory, "https://mirror.test/dist/")
  let assert Ok(project) = project.load_from(directory)

  let assert Ok([project.Modified(_)]) =
    project.write_settings(project, prefix: Some("lib"), source: None)

  // The new key is appended to the table; the sibling source key is left intact.
  assert simplifile.read(directory <> "/gleam.toml")
    == Ok(
      "name = \"app\"\n\n[tools.drip]\nsource = \"https://mirror.test/dist/\"\n"
      <> "prefix = \"lib\"\n",
    )
}

pub fn write_settings_updates_existing_key_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_update")
  write_drip_toml(directory, "ui")
  let assert Ok(project) = project.load_from(directory)

  let assert Ok([project.Modified(_)]) =
    project.write_settings(project, prefix: Some("lib/ui"), source: None)

  // The existing prefix is rewritten in place.
  assert simplifile.read(directory <> "/gleam.toml")
    == Ok("name = \"app\"\n\n[tools.drip]\nprefix = \"lib/ui\"\n")
}

pub fn write_settings_writes_multiple_keys_in_one_edit_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_multi")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Ok([project.Modified(_)]) =
    project.write_settings(
      project,
      prefix: Some("lib"),
      source: Some("https://mirror.test/dist"),
    )

  // Both keys land in the one new table.
  assert simplifile.read(directory <> "/gleam.toml")
    == Ok(
      "name = \"app\"\n\n[tools.drip]\nprefix = \"lib\"\n"
      <> "source = \"https://mirror.test/dist\"\n",
    )
}

pub fn write_settings_is_unchanged_when_value_matches_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_noop")
  write_drip_toml(directory, "lib")
  let assert Ok(project) = project.load_from(directory)

  // Re-recording the same value rewrites nothing.
  let assert Ok([project.Unmodified(_)]) =
    project.write_settings(project, prefix: Some("lib"), source: None)
  assert simplifile.read(directory <> "/gleam.toml")
    == Ok("name = \"app\"\n\n[tools.drip]\nprefix = \"lib\"\n")
}

pub fn write_settings_is_a_no_op_when_nothing_requested_test() {
  use directory <- helpers.with_temp_directory("drip_write_settings_none")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  // With neither flag given there is nothing to record, so no change is
  // reported and gleam.toml is left untouched.
  let assert Ok([]) =
    project.write_settings(project, prefix: None, source: None)
  assert simplifile.read(directory <> "/gleam.toml") == Ok("name = \"app\"\n")
}

// --- Vendored Files ----------------------------------------------------------

pub fn vendored_files_matches_only_the_named_element_test() {
  use directory <- helpers.with_temp_directory("drip_vendored_files")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Ok(Nil) = simplifile.create_directory_all(directory <> "/src/ui")
  let assert Ok(Nil) =
    simplifile.write(to: directory <> "/src/ui/button.gleam", contents: "")
  let assert Ok(Nil) =
    simplifile.write(to: directory <> "/src/ui/button.css", contents: "")
  // A prefix-sharing sibling that must not be swept in.
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/src/ui/button_group.gleam",
      contents: "",
    )

  let assert Ok(files) = project.vendored_files(project, "button")
  let sorted = files |> list.sort(string.compare)
  assert sorted
    == [
      directory <> "/src/ui/button.css",
      directory <> "/src/ui/button.gleam",
    ]
}

pub fn vendored_files_is_empty_when_nothing_vendored_test() {
  use directory <- helpers.with_temp_directory("drip_vendored_files_empty")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  // No install directory exists yet, so nothing is reported as vendored.
  assert project.vendored_files(project, "button") == Ok([])
}

// Ensure any consumer conflicting element files count as vendored
// so we don't unintentionally overwrite them
pub fn is_vendored_detects_an_element_without_a_gleam_module_test() {
  use directory <- helpers.with_temp_directory("drip_is_vendored_css_only")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Ok(Nil) = simplifile.create_directory_all(directory <> "/src/ui")
  let assert Ok(Nil) =
    simplifile.write(to: directory <> "/src/ui/divider.css", contents: "")

  assert project.is_vendored(project, "divider") == Ok(True)
}

pub fn is_vendored_ignores_prefix_sharing_siblings_test() {
  use directory <- helpers.with_temp_directory("drip_is_vendored_sibling")
  write_gleam_toml(directory)
  let assert Ok(project) = project.load_from(directory)

  let assert Ok(Nil) = simplifile.create_directory_all(directory <> "/src/ui")
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/src/ui/button_group.gleam",
      contents: "",
    )

  assert project.is_vendored(project, "button") == Ok(False)
}

// --- Helpers -----------------------------------------------------------------

fn write_gleam_toml(directory: String) -> Nil {
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n",
    )

  Nil
}

fn write_drip_toml(directory: String, prefix: String) -> Nil {
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n\n[tools.drip]\nprefix = \""
        <> prefix
        <> "\"\n",
    )

  Nil
}

fn write_drip_source_toml(directory: String, source: String) -> Nil {
  let assert Ok(Nil) =
    simplifile.write(
      to: directory <> "/gleam.toml",
      contents: "name = \"app\"\n\n[tools.drip]\nsource = \""
        <> source
        <> "\"\n",
    )

  Nil
}
