import drip/internal/project.{type FileChange, type Project}
import drip/internal/registry.{type Element}
import gleam/int
import gleam/list
import gleam/string

// --- Init Summary ------------------------------------------------------------

pub fn init_summary(project: Project, changes: List(FileChange)) -> String {
  let rows = change_rows(project, changes)

  let directory =
    project.relative_path(project, project.vendor_directory(project))

  let header = case list.all(changes, is_unchanged) {
    True -> "✓ drip is already initialized in " <> directory <> "."
    False -> "✓ Initialized drip in " <> directory <> "."
  }

  let footer =
    "Next steps:\n"
    <> "  gleam run -m drip -- add <element>   vendor an element\n"
    <> "  gleam run -m drip -- list            see what is available"

  list.flatten([[header, ""], rows, ["", footer]])
  |> string.join("\n")
}

// --- List Summary ------------------------------------------------------------

pub type Entry {
  Entry(name: String, vendored: Bool)
}

pub fn list_summary(entries: List(Entry)) -> String {
  case entries {
    [] -> "There are no elements in the source registry."
    _ -> {
      let rows =
        entries
        |> list.map(fn(entry) {
          #(
            vendored_glyph(entry.vendored),
            vendored_label(entry.vendored),
            entry.name,
          )
        })
        |> align_rows

      let count = list.length(entries)

      let header =
        int.to_string(count)
        <> " "
        <> pluralize(count, "element")
        <> " available in the source registry."

      let footer =
        "Next steps:\n"
        <> "  gleam run -m drip -- add <element>   vendor an element"

      list.flatten([[header, ""], rows, ["", footer]])
      |> string.join("\n")
    }
  }
}

fn vendored_glyph(vendored: Bool) -> String {
  case vendored {
    True -> "✓"
    False -> " "
  }
}

fn vendored_label(vendored: Bool) -> String {
  case vendored {
    True -> "vendored"
    False -> "available"
  }
}

// --- Add Summary -------------------------------------------------------------

pub fn add_summary(
  project: Project,
  vendored: List(Element),
  skipped: List(Element),
  changes: List(FileChange),
) -> String {
  let directory =
    project.relative_path(project, project.vendor_directory(project))
  let count = list.length(vendored)
  let header = case vendored {
    [] -> "Requested elements are already vendored in " <> directory <> "."
    _ ->
      "Vendored "
      <> int.to_string(count)
      <> " "
      <> pluralize(count, "element")
      <> " into "
      <> directory
      <> "."
  }
  join_blocks([
    changes_block(project, header, changes),
    skipped_block(names(skipped), "already vendored"),
    next_steps_block(vendored),
  ])
}

// FFI init() calls and required Hex packages are the actions left for the user
// after vendoring, so they read as the command's next steps.
fn next_steps_block(vendored: List(Element)) -> String {
  let ffi =
    vendored
    |> list.filter(has_ffi)
    |> names
    |> list.map(fn(name) { "  call " <> name <> ".init() from your app start" })
  let packages = case required_packages(vendored) {
    [] -> []
    packages -> ["  gleam add " <> string.join(packages, " ")]
  }
  case list.flatten([ffi, packages]) {
    [] -> ""
    steps -> string.join(["Next steps:", ..steps], "\n")
  }
}

fn required_packages(vendored: List(Element)) -> List(String) {
  vendored
  |> list.flat_map(fn(element) { element.dependencies })
  |> list.unique
  |> list.sort(string.compare)
}

fn names(elements: List(Element)) -> List(String) {
  list.map(elements, fn(element) { element.name })
}

fn has_ffi(element: Element) -> Bool {
  list.any(element.files, string.ends_with(_, ".ffi.mjs"))
}

// --- Remove Summary ----------------------------------------------------------

pub fn remove_summary(
  project: Project,
  removed: List(String),
  skipped: List(String),
  changes: List(FileChange),
) -> String {
  let directory =
    project.relative_path(project, project.vendor_directory(project))
  let count = list.length(removed)
  let header = case removed {
    [] -> "No elements to remove from " <> directory <> "."
    _ ->
      "Removed "
      <> int.to_string(count)
      <> " "
      <> pluralize(count, "element")
      <> " from "
      <> directory
      <> "."
  }
  join_blocks([
    changes_block(project, header, changes),
    skipped_block(skipped, "not vendored"),
  ])
}

// --- Layout ------------------------------------------------------------------

fn join_blocks(blocks: List(String)) -> String {
  blocks |> list.filter(fn(block) { block != "" }) |> string.join("\n\n")
}

fn changes_block(
  project: Project,
  header: String,
  changes: List(FileChange),
) -> String {
  case change_rows(project, changes) {
    [] -> header
    rows -> string.join([header, "", ..rows], "\n")
  }
}

fn skipped_block(names: List(String), reason: String) -> String {
  case names {
    [] -> ""
    _ ->
      list.map(names, fn(name) {
        #("=", "skipped", name <> " (" <> reason <> ")")
      })
      |> align_rows
      |> string.join("\n")
  }
}

fn change_rows(project: Project, changes: List(FileChange)) -> List(String) {
  changes |> list.map(change_row(project, _)) |> align_rows
}

fn change_row(
  project: Project,
  change: FileChange,
) -> #(String, String, String) {
  let path = project.relative_path(project, change.path)
  let value = case change {
    project.Unmodified(_) -> path <> " (unchanged)"
    project.Created(_) | project.Modified(_) | project.Deleted(_) -> path
  }
  #(change_glyph(change), change_label(change), value)
}

fn change_glyph(change: FileChange) -> String {
  case change {
    project.Created(_) -> "+"
    project.Modified(_) -> "~"
    project.Unmodified(_) -> "="
    project.Deleted(_) -> "-"
  }
}

fn change_label(change: FileChange) -> String {
  case change {
    project.Created(_) -> "created"
    project.Modified(_) -> "modified"
    project.Unmodified(_) -> "skipped"
    project.Deleted(_) -> "deleted"
  }
}

fn is_unchanged(change: FileChange) -> Bool {
  case change {
    project.Unmodified(_) -> True
    project.Created(_) | project.Modified(_) | project.Deleted(_) -> False
  }
}

fn align_rows(rows: List(#(String, String, String))) -> List(String) {
  let width =
    list.fold(rows, 0, fn(max, row) {
      let #(_, label, _) = row
      int.max(max, string.length(label))
    })
  list.map(rows, fn(row) {
    let #(glyph, label, value) = row
    "  "
    <> glyph
    <> " "
    <> string.pad_end(label, to: width, with: " ")
    <> " "
    <> value
  })
}

fn pluralize(count: Int, singular: String) -> String {
  case count {
    1 -> singular
    _ -> singular <> "s"
  }
}
