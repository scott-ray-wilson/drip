import drip/internal/error.{type Error}
import drip/internal/source.{type Source}
import filepath
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile
import tomlet

// --- Project -----------------------------------------------------------------

pub opaque type Project {
  Project(root: String, name: String, prefix: String, source: Source)
}

pub fn root(project: Project) -> String {
  project.root
}

pub fn name(project: Project) -> String {
  project.name
}

pub fn prefix(project: Project) -> String {
  project.prefix
}

pub fn with_overrides(
  project: Project,
  prefix prefix: Option(String),
  source source: Option(String),
) -> Result(Project, Error) {
  use project <- result.try(case prefix {
    Some(value) ->
      case is_valid_prefix(value) {
        True -> Ok(Project(..project, prefix: value))
        False -> Error(error.InvalidPrefix(value))
      }
    None -> Ok(project)
  })
  case source {
    Some(value) -> {
      use source <- result.map(source.parse(value))
      Project(..project, source:)
    }
    None -> Ok(project)
  }
}

pub fn source(project: Project) -> Source {
  project.source
}

pub fn vendor_directory(project: Project) -> String {
  filepath.join(project.root, "src/" <> project.prefix)
}

fn theme_css_path(project: Project) -> String {
  filepath.join(vendor_directory(project), "theme.css")
}

fn index_css_path(project: Project) -> String {
  filepath.join(vendor_directory(project), "index.css")
}

fn entry_css_path(project: Project) -> String {
  filepath.join(project.root, "src/" <> project.name <> ".css")
}

pub fn file_path(project: Project, filename: String) -> String {
  filepath.join(vendor_directory(project), filename)
}

// Strips the project root so output shows src/ui/... not an absolute path.
pub fn relative_path(project: Project, path: String) -> String {
  case string.starts_with(path, project.root) {
    True ->
      path
      |> string.drop_start(string.length(project.root))
      |> trim_leading_slash
    False -> path
  }
}

fn trim_leading_slash(path: String) -> String {
  case string.starts_with(path, "/") {
    True -> string.drop_start(path, 1)
    False -> path
  }
}

pub fn is_vendored(project: Project, name: String) -> Result(Bool, Error) {
  use files <- result.map(vendored_files(project, name))
  files != []
}

fn is_initialized(project: Project) -> Result(Bool, Error) {
  file_exists(index_css_path(project))
}

// add/remove require an initialized project; index.css is the marker.
pub fn ensure_initialized(project: Project) -> Result(Nil, Error) {
  use initialized <- result.try(is_initialized(project))
  case initialized {
    True -> Ok(Nil)
    False -> Error(error.FailedToFindIndexStylesheet(index_css_path(project)))
  }
}

// --- Loading -----------------------------------------------------------------

const default_prefix = "ui"

const default_source = "https://github.com/scott-ray-wilson/drip/releases/latest/download"

pub fn load() -> Result(Project, Error) {
  load_from("./")
}

pub fn load_from(directory: String) -> Result(Project, Error) {
  use root <- result.try(find_project_root(directory, 0))

  use toml <- result.try(
    simplifile.read(filepath.join(root, "gleam.toml"))
    |> result.map_error(error.FailedToReadGleamToml),
  )

  use document <- result.try(
    tomlet.parse(toml) |> result.map_error(error.FailedToParseGleamToml),
  )

  use name <- result.try(
    tomlet.get_string(document, ["name"])
    |> result.map_error(error.FailedToGetGleamTomlValue),
  )

  use prefix <- result.try(
    case tomlet.get_string(document, ["tools", "drip", "prefix"]) {
      Ok(prefix) ->
        case is_valid_prefix(prefix) {
          True -> Ok(prefix)
          False -> Error(error.InvalidPrefix(prefix))
        }
      Error(tomlet.KeyNotFound(_)) -> Ok(default_prefix)
      Error(cause) -> Error(error.FailedToGetGleamTomlValue(cause))
    },
  )

  use raw_source <- result.try(
    case tomlet.get_string(document, ["tools", "drip", "source"]) {
      Ok(source) -> Ok(source)
      Error(tomlet.KeyNotFound(_)) -> Ok(default_source)
      Error(cause) -> Error(error.FailedToGetGleamTomlValue(cause))
    },
  )

  use source <- result.map(source.parse(raw_source))

  Project(root:, name:, prefix:, source:)
}

const max_depth = 64

fn find_project_root(directory: String, depth: Int) -> Result(String, Error) {
  case simplifile.is_file(filepath.join(directory, "gleam.toml")) {
    Ok(True) -> Ok(directory)
    // A read error is treated like "not here" and keeps climbing.
    _ ->
      case depth < max_depth {
        True -> find_project_root(filepath.join(directory, "../"), depth + 1)
        False -> Error(error.FailedToFindProjectRoot(directory))
      }
  }
}

// --- Gleam TOML --------------------------------------------------------------

fn gleam_toml_path(project: Project) -> String {
  filepath.join(project.root, "gleam.toml")
}

// Persist user overrides for future commands.
pub fn write_settings(
  project: Project,
  prefix prefix: Option(String),
  source source: Option(String),
) -> Result(List(FileChange), Error) {
  let settings =
    list.flatten([
      case prefix {
        Some(value) -> [#("prefix", value)]
        None -> []
      },
      case source {
        Some(value) -> [#("source", value)]
        None -> []
      },
    ])
  case settings {
    [] -> Ok([])
    _ -> {
      let path = gleam_toml_path(project)
      use raw <- result.try(read_file(path))
      use document <- result.try(
        tomlet.parse(raw) |> result.map_error(error.FailedToParseGleamToml),
      )
      // tomlet glues a freshly created table onto the last existing line, so
      // when [tools.drip] is absent seed a blank separator into the source and
      // reparse.
      use document <- result.try(case tomlet.get(document, ["tools", "drip"]) {
        Ok(_) -> Ok(document)
        Error(_) ->
          tomlet.parse(string.trim_end(raw) <> "\n\n")
          |> result.map_error(error.FailedToParseGleamToml)
      })

      use updated <- result.try(
        list.try_fold(settings, document, fn(document, setting) {
          let #(key, value) = setting
          tomlet.set_string(document, ["tools", "drip", key], value)
          |> result.map_error(error.FailedToEditGleamToml)
        }),
      )
      use change <- result.map(write_change(path, tomlet.to_string(updated)))
      [change]
    }
  }
}

// --- Filesystem --------------------------------------------------------------

pub type FileChange {
  Created(path: String)
  Modified(path: String)
  Unmodified(path: String)
  Deleted(path: String)
}

// Whether an existing file may be overwritten, carried from the --force flag.
pub type Overwrite {
  Force
  Preserve
}

fn file_exists(path: String) -> Result(Bool, Error) {
  case simplifile.is_file(path) {
    Ok(present) -> Ok(present)
    Error(cause) -> Error(error.FailedToCheckIfProjectFileExists(path, cause))
  }
}

fn read_file(path: String) -> Result(String, Error) {
  simplifile.read(path)
  |> result.map_error(error.FailedToReadProjectFile(path, _))
}

fn write_file(path: String, body: String) -> Result(Nil, Error) {
  use _ <- result.try(
    simplifile.create_directory_all(filepath.directory_name(path))
    |> result.map_error(error.FailedToCreateProjectDirectory(path, _)),
  )
  simplifile.write(to: path, contents: body)
  |> result.map_error(error.FailedToWriteProjectFile(path, _))
}

pub fn write_changes(
  files: List(#(String, String)),
) -> Result(List(FileChange), Error) {
  list.try_map(files, fn(file) {
    let #(path, body) = file
    write_change(path, body)
  })
}

fn write_change(path: String, body: String) -> Result(FileChange, Error) {
  use exists <- result.try(file_exists(path))
  case exists {
    False -> {
      use _ <- result.try(write_file(path, body))
      Ok(Created(path))
    }
    True -> {
      use current <- result.try(read_file(path))
      case current == body {
        True -> Ok(Unmodified(path))
        False -> {
          use _ <- result.try(write_file(path, body))
          Ok(Modified(path))
        }
      }
    }
  }
}

pub fn delete_files(paths: List(String)) -> Result(List(FileChange), Error) {
  list.try_map(paths, fn(path) {
    use _ <- result.map(delete_file(path))
    Deleted(path)
  })
}

fn delete_file(path: String) -> Result(Nil, Error) {
  simplifile.delete(path)
  |> result.map_error(error.FailedToDeleteProjectFile(path, _))
}

pub fn vendored_files(
  project: Project,
  name: String,
) -> Result(List(String), Error) {
  use filenames <- result.map(read_vendor_directory(project))
  filenames
  |> list.filter(fn(filename) { string.starts_with(filename, name <> ".") })
  |> list.sort(string.compare)
  |> list.map(file_path(project, _))
}

/// The raw filenames in the vendor directory.
pub fn vendored_filenames(project: Project) -> Result(List(String), Error) {
  read_vendor_directory(project)
}

/// Whether `name`'s files are present among `filenames`.
pub fn vendored_in(filenames: List(String), name: String) -> Bool {
  list.any(filenames, fn(filename) { string.starts_with(filename, name <> ".") })
}

fn read_vendor_directory(project: Project) -> Result(List(String), Error) {
  let directory = vendor_directory(project)
  case simplifile.read_directory(directory) {
    Ok(names) -> Ok(names)
    Error(simplifile.Enoent) -> Ok([])
    Error(cause) -> Error(error.FailedToReadProjectDirectory(directory, cause))
  }
}

// --- Index CSS ---------------------------------------------------------------

pub fn rewrite_index_css(project: Project) -> Result(FileChange, Error) {
  use body <- result.try(current_index_css_body(project))
  write_change(index_css_path(project), body)
}

// Derive the index from the element CSS actually on disk so it's
// always up-to-date with vendored elements.
fn current_index_css_body(project: Project) -> Result(String, Error) {
  use filenames <- result.try(read_vendor_directory(project))
  let css_files = list.filter(filenames, is_element_css)
  Ok(index_css_body(css_files))
}

const index_header = "/* Generated by drip; do not edit. "
  <> "Run drip add / drip remove to change it. */"

const theme_import = "@import \"./theme.css\";"

fn index_css_body(css_files: List(String)) -> String {
  let imports =
    css_files
    |> list.unique
    |> list.sort(string.compare)
    |> list.map(fn(name) { "@import \"./" <> name <> "\";" })
  string.join([index_header, theme_import, ..imports], "\n") <> "\n"
}

fn is_element_css(name: String) -> Bool {
  string.ends_with(name, ".css") && name != "theme.css" && name != "index.css"
}

// --- Entry CSS ---------------------------------------------------------------

const tailwind_import = "@import \"tailwindcss\";"

// @import "tailwindcss" must come first otherwise lustre_dev_tools prepends
// its own duplicate import.
fn entry_css_body(project: Project) -> String {
  tailwind_import <> "\n" <> index_import(project) <> "\n"
}

fn index_import(project: Project) -> String {
  "@import \"./" <> prefix(project) <> "/index.css\";"
}

// The entry stylesheet belongs to the consumer; if it's not present
// we add it, otherwise we append the index import.
fn wire_entry_css(project: Project) -> Result(FileChange, Error) {
  let path = entry_css_path(project)
  use exists <- result.try(file_exists(path))
  case exists {
    False -> {
      use _ <- result.try(write_file(path, entry_css_body(project)))
      Ok(Created(path))
    }
    True -> {
      use body <- result.try(read_file(path))
      case merge_index_import(project, body) {
        None -> Ok(Unmodified(path))
        Some(merged) -> {
          use _ <- result.try(write_file(path, merged))
          Ok(Modified(path))
        }
      }
    }
  }
}

fn merge_index_import(project: Project, body: String) -> Option(String) {
  let import_line = index_import(project)
  let lines = string.split(body, "\n")
  let has_index = list.any(lines, fn(line) { string.trim(line) == import_line })
  let has_tailwind = list.any(lines, is_tailwind_import)
  case has_index, has_tailwind {
    // Already fully wired, do nothing.
    True, True -> None
    // Index is present but tailwind is missing; prepend it.
    True, False -> Some(tailwind_import <> "\n" <> body)
    // Index is missing but tailwind is present; splice it in after tailwind.
    False, True ->
      Some(string.join(splice_after_tailwind(lines, import_line), "\n"))
    // Neither is present; prepend both.
    False, False -> Some(entry_css_body(project) <> body)
  }
}

// We need to insert the index import after the tailwind import as
// lustre_dev_tools will append duplicate imports if it is not the first line.
fn splice_after_tailwind(
  lines: List(String),
  import_line: String,
) -> List(String) {
  case list.split_while(lines, fn(line) { !is_tailwind_import(line) }) {
    #(_, []) -> lines
    #(before, [anchor, ..after]) ->
      list.append(before, [anchor, import_line, ..after])
  }
}

fn is_tailwind_import(line: String) -> Bool {
  let line = string.trim(line)
  string.starts_with(line, "@import") && string.contains(line, "tailwindcss")
}

// --- Scaffold ----------------------------------------------------------------

pub fn scaffold(
  project: Project,
  overwrite: Overwrite,
) -> Result(List(FileChange), Error) {
  let theme = theme_css_path(project)
  let index = index_css_path(project)

  use _ <- result.try(guard_overwrite([theme, index], overwrite))
  use theme_body <- result.try(source.fetch(project.source, "theme.css"))

  use theme_change <- result.try(write_change(theme, theme_body))
  use index_body <- result.try(current_index_css_body(project))
  use index_change <- result.try(write_change(index, index_body))
  use entry <- result.try(wire_entry_css(project))

  Ok([theme_change, index_change, entry])
}

fn guard_overwrite(
  paths: List(String),
  overwrite: Overwrite,
) -> Result(Nil, Error) {
  case overwrite {
    Force -> Ok(Nil)
    Preserve ->
      list.try_each(paths, fn(path) {
        use exists <- result.try(file_exists(path))
        case exists {
          True -> Error(error.ProjectFileAlreadyExists(path))
          False -> Ok(Nil)
        }
      })
  }
}

// --- Helpers -----------------------------------------------------------------

// prefix must be valid Gleam module path ("ui", "lib/ui", etc.).
fn is_valid_prefix(prefix: String) -> Bool {
  string.split(prefix, "/") |> list.all(is_valid_path_segment)
}

fn is_valid_path_segment(segment: String) -> Bool {
  case string.to_graphemes(segment) {
    [] -> False
    [first, ..rest] -> is_lower_alpha(first) && list.all(rest, is_identifier)
  }
}

fn is_identifier(char: String) -> Bool {
  is_lower_alpha(char) || is_digit(char) || char == "_"
}

fn is_lower_alpha(char: String) -> Bool {
  string.contains("abcdefghijklmnopqrstuvwxyz", char)
}

fn is_digit(char: String) -> Bool {
  string.contains("0123456789", char)
}
