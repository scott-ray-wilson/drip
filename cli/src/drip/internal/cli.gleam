import drip/internal/error.{type Error}
import drip/internal/project.{type FileChange, type Overwrite, type Project}
import drip/internal/registry.{type Element, type Registry}
import drip/internal/render.{type Entry}
import drip/internal/source
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import glint.{type Command}

// --- Run ---------------------------------------------------------------------

pub fn run(project: Project, args: List(String)) -> Result(String, Error) {
  let cli =
    glint.new()
    |> glint.as_module
    |> glint.with_name("drip")
    |> glint.add(at: ["init"], do: init(project))
    |> glint.add(at: ["list"], do: list(project))
    |> glint.add(at: ["add"], do: add(project))
    |> glint.add(at: ["remove"], do: remove(project))

  case glint.execute(cli, args) {
    Ok(glint.Help(help)) -> Ok(help)
    Ok(glint.Out(Ok(output))) -> Ok(output)
    Ok(glint.Out(Error(cause))) -> Error(cause)
    Error(message) -> Error(error.InvalidUsage(message))
  }
}

// --- Init Command ------------------------------------------------------------

fn init(project: Project) -> Command(Result(String, Error)) {
  use <- glint.command_help("Scaffold the theme, index, and entry stylesheets.")

  use prefix <- glint.flag(
    glint.string_flag("prefix")
    |> glint.flag_help(
      "Directory under src/ that elements vendor into, recorded in gleam.toml's"
      <> " [tools.drip] table (default: ui).",
    ),
  )

  use source <- glint.flag(
    glint.string_flag("source")
    |> glint.flag_help(
      "Registry to vendor from, a URL or local path, recorded in gleam.toml's"
      <> " [tools.drip] table (default: the latest GitHub release).",
    ),
  )

  use force <- glint.flag(
    glint.bool_flag("force")
    |> glint.flag_default(False)
    |> glint.flag_help(
      "Overwrite the scaffolded stylesheets when they already exist.",
    ),
  )

  use <- glint.unnamed_args(glint.EqArgs(0))
  use _named, _unnamed, flags <- glint.command

  let overwrite = to_overwrite(force(flags) |> result.unwrap(False))
  let prefix_override = option.from_result(prefix(flags))
  let source_override = option.from_result(source(flags))

  use project <- result.try(project.with_overrides(
    project,
    prefix: prefix_override,
    source: source_override,
  ))

  use changes <- result.try(project.scaffold(project, overwrite))

  // Persist overrides after the scaffold so a failed overwrite guard
  // or theme fetch leaves gleam.toml untouched.
  use toml_changes <- result.try(project.write_settings(
    project,
    prefix: prefix_override,
    source: source_override,
  ))

  Ok(render.init_summary(project, list.append(changes, toml_changes)))
}

// --- List Command ------------------------------------------------------------

fn list(project: Project) -> Command(Result(String, Error)) {
  use <- glint.command_help(
    "List the elements available in the source registry.",
  )

  use <- glint.unnamed_args(glint.EqArgs(0))
  use _named, _unnamed, _flags <- glint.command

  use registry <- result.try(registry.fetch(project.source(project)))
  use entries <- result.try(list_elements(project, registry))

  Ok(render.list_summary(entries))
}

fn list_elements(
  project: Project,
  registry: Registry,
) -> Result(List(Entry), Error) {
  use filenames <- result.map(project.vendored_filenames(project))
  list.map(registry, fn(element) {
    render.Entry(
      name: element.name,
      vendored: project.vendored_in(filenames, element.name),
    )
  })
}

// --- Add Command -------------------------------------------------------------

fn add(project: Project) -> Command(Result(String, Error)) {
  use <- glint.command_help(
    "Vendor elements and their dependencies into your project.",
  )

  use force <- glint.flag(
    glint.bool_flag("force")
    |> glint.flag_default(False)
    |> glint.flag_help(
      "Re-vendor the resolved elements, overwriting files already on disk.",
    ),
  )

  use <- glint.unnamed_args(glint.MinArgs(0))
  use _named, element_names, flags <- glint.command

  let overwrite = to_overwrite(force(flags) |> result.unwrap(False))

  use element_names <- result.try(require_elements("add", element_names))

  use _ <- result.try(project.ensure_initialized(project))

  use registry <- result.try(registry.fetch(project.source(project)))
  use elements <- result.try(registry.resolve_elements(registry, element_names))

  // Partition already vendored elements so we don't overwrite them
  // unless --force flag is passed.
  use #(to_vendor, already_vendored) <- result.try(partition_vendored(
    project,
    elements,
    overwrite,
  ))

  use element_files <- result.try(fetch_elements(project, to_vendor))

  use file_changes <- result.try(project.write_changes(element_files))
  use index_css_change <- result.try(project.rewrite_index_css(project))

  Ok(render.add_summary(
    project,
    to_vendor,
    already_vendored,
    list.append(file_changes, surfaced(index_css_change, overwrite)),
  ))
}

// Split the resolved elements into what to vendor and what's already vendored
// so we don't overwrite existing files. Under --force everything is re-vendored.
fn partition_vendored(
  project: Project,
  elements: List(Element),
  overwrite: Overwrite,
) -> Result(#(List(Element), List(Element)), Error) {
  use #(to_vendor, already_vendored) <- result.map(case overwrite {
    project.Force -> Ok(#(elements, []))
    project.Preserve ->
      list.try_fold(elements, #([], []), fn(acc, element) {
        let #(to_vendor, already_vendored) = acc
        use present <- result.map(project.is_vendored(project, element.name))
        case present {
          True -> #(to_vendor, [element, ..already_vendored])
          False -> #([element, ..to_vendor], already_vendored)
        }
      })
  })
  #(sort_by_name(to_vendor), sort_by_name(already_vendored))
}

fn fetch_elements(
  project: Project,
  elements: List(Element),
) -> Result(List(#(String, String)), Error) {
  use nested <- result.map(
    list.try_map(elements, fn(element) { fetch_element_files(project, element) }),
  )
  list.flatten(nested)
}

fn fetch_element_files(
  project: Project,
  element: Element,
) -> Result(List(#(String, String)), Error) {
  let prefix = project.prefix(project)
  list.try_map(element.files, fn(filename) {
    use body <- result.map(source.fetch(project.source(project), filename))
    let body = case string.ends_with(filename, ".gleam") {
      True -> rewrite_imports(prefix, body)
      False -> body
    }
    #(project.file_path(project, filename), body)
  })
}

// Vendored elements import the library under `ui/` so if
// prefix is customized we need to modify it.
fn rewrite_imports(prefix: String, source: String) -> String {
  string.split(source, "\n")
  |> list.map(fn(line) {
    case string.starts_with(line, import_marker) {
      True ->
        "import "
        <> prefix
        <> "/"
        <> string.drop_start(line, string.length(import_marker))
      False -> line
    }
  })
  |> string.join("\n")
}

const import_marker = "import ui/"

// --- Remove Command ----------------------------------------------------------

fn remove(project: Project) -> Command(Result(String, Error)) {
  use <- glint.command_help(
    "Remove vendored elements and their files from your project.",
  )

  use <- glint.unnamed_args(glint.MinArgs(0))
  use _named, element_names, _flags <- glint.command

  use element_names <- result.try(require_elements("remove", element_names))

  use _ <- result.try(project.ensure_initialized(project))

  use #(vendored, absent) <- result.try(partition_removable(
    project,
    element_names,
  ))

  // Removal doesn't cascade: only the explicitly requested elements go,
  // since a dependency may be shared by others still on disk.
  let files = list.flat_map(vendored, fn(element) { element.files })
  use file_changes <- result.try(project.delete_files(files))
  use index_change <- result.try(project.rewrite_index_css(project))

  Ok(render.remove_summary(
    project,
    list.map(vendored, fn(element) { element.name }),
    absent,
    list.append(file_changes, surfaced(index_change, project.Preserve)),
  ))
}

type Vendored {
  Vendored(name: String, files: List(String))
}

// Split the requested names into those with files on disk (to delete, each
// paired with the files it owns) and those that aren't vendored (skipped).
fn partition_removable(
  project: Project,
  names: List(String),
) -> Result(#(List(Vendored), List(String)), Error) {
  use #(vendored, absent) <- result.map(
    list.try_fold(names, #([], []), fn(acc, name) {
      let #(vendored, absent) = acc
      use files <- result.map(project.vendored_files(project, name))
      case files {
        [] -> #(vendored, [name, ..absent])
        _ -> #([Vendored(name, files), ..vendored], absent)
      }
    }),
  )
  #(
    list.sort(vendored, fn(a, b) { string.compare(a.name, b.name) }),
    list.sort(absent, string.compare),
  )
}

// --- Helpers -----------------------------------------------------------------

fn require_elements(
  command: String,
  names: List(String),
) -> Result(List(String), Error) {
  case names {
    [] -> Error(error.NoElementsRequested(command))
    _ -> Ok(list.unique(names))
  }
}

// Lift the --force flag into the overwrite policy shared with project.
fn to_overwrite(force: Bool) -> Overwrite {
  case force {
    True -> project.Force
    False -> project.Preserve
  }
}

// A changed index is always worth showing; an unchanged one is noise unless
// --force asked to re-vendor everything.
fn surfaced(change: FileChange, overwrite: Overwrite) -> List(FileChange) {
  case change {
    project.Unmodified(_) ->
      case overwrite {
        project.Force -> [change]
        project.Preserve -> []
      }
    project.Created(_) | project.Modified(_) | project.Deleted(_) -> [change]
  }
}

fn sort_by_name(elements: List(Element)) -> List(Element) {
  list.sort(elements, fn(a, b) { string.compare(a.name, b.name) })
}
