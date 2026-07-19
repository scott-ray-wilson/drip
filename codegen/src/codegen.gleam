//// Build-time tool that turns the `drip/registry` catalog and the `ui/`
//// element sources into the docs site's code snippets and the CLI's release
//// set. Run it with `gleam run` from `codegen/`. It writes two gitignored
//// trees:
////
//// - `../docs/src/docs/generated/`: the syntax-highlighted snippet modules the
////   docs site renders (per-element installation HTML, the `tabs_for` lookup,
////   per-page example HTML, and the full default theme).
//// - `../dist/`: the flat release set the `drip` CLI fetches at runtime, the
////   `registry.json` index plus every listed element's files and `theme.css`.

import codegen/internal/registry_json
import codegen/internal/render
import drip/registry.{type Element}
import gleam/list
import gleam/string
import shellout
import simplifile

// --- Main --------------------------------------------------------------------

pub fn main() -> Nil {
  let assert Ok(_) = simplifile.create_directory_all(install_directory)
    as "codegen: could not create the generated/installation directory"
  let assert Ok(_) = simplifile.create_directory_all(example_directory)
    as "codegen: could not create the generated/example directory"

  generate_install_module()
  list.each(registry.all, generate_install_html)

  registry.all
  |> list.map(fn(element) { registry.to_string(element.name) })
  |> list.append(example_pages)
  |> list.each(generate_example_html)

  generate_theme_html()

  emit_dist()

  Nil
}

// Docs-only pages with no registry entry whose `example/` directories still
// need snippet modules generated.
const example_pages: List(String) = [
  "introduction", "getting_started", "theming",
]

// --- Installation HTML -------------------------------------------------------

fn generate_install_html(element: Element) -> Nil {
  let source_const = html_const("source_html", render.gleam_path(element))
  let css_const = html_const("css_html", render.css_path(element))

  let ffi_const = case element.ffi {
    True -> [html_const("ffi_html", render.ffi_path(element))]
    False -> []
  }

  let body =
    list.flatten([[source_const, css_const], ffi_const])
    |> render.generated_module

  let path =
    install_directory <> "/" <> registry.to_string(element.name) <> ".gleam"
  write_file(path, body)
}

fn html_const(name: String, path: String) -> String {
  let raw = read_file("../ui/" <> path)
  render.const_declaration(name, render.generate_html(path, raw))
}

// --- Installation Tabs -------------------------------------------------------

fn generate_install_module() -> Nil {
  let imports =
    registry.all
    |> list.map(fn(element) {
      "import docs/generated/installation/" <> registry.to_string(element.name)
    })
    |> string.join("\n")

  let clauses =
    registry.all
    |> list.map(render.installation_tabs_tuples)
    |> string.join("\n")

  let path = generated_directory <> "/installation.gleam"
  write_file(path, format_gleam(render.installation_module(imports, clauses)))
}

// --- Example HTML ------------------------------------------------------------

fn generate_example_html(name: String) -> Nil {
  let directory = docs_page_directory <> "/" <> name <> "/example"
  // Registry elements can exist before a docs page is authored for them.
  // Skip elements with no example directory rather than crashing.
  case simplifile.read_directory(directory) {
    Error(_) -> Nil
    Ok(filenames) -> {
      let elements =
        filenames
        |> list.filter(fn(filename) {
          string.ends_with(filename, ".gleam")
          || string.ends_with(filename, ".css")
        })
        |> list.sort(string.compare)
        |> list.map(fn(filename) {
          let source = string.trim_end(read_file(directory <> "/" <> filename))
          render.example_const(filename, source)
        })

      let path = example_directory <> "/" <> name <> ".gleam"
      write_file(path, render.generated_module(elements))
    }
  }
}

// --- Theme HTML --------------------------------------------------------------

// The theming page embeds the whole default theme; render it from the same
// file `emit_dist` ships so the docs can never drift from what init writes.
fn generate_theme_html() -> Nil {
  let body =
    render.generated_module([html_const("source_html", "src/ui/theme.css")])
  write_file(generated_directory <> "/theme.gleam", body)
}

// --- Release Dist ------------------------------------------------------------

// Writes the flat release set the CLI fetches at runtime: `registry.json`
// plus every element's files and `theme.css`.
fn emit_dist() -> Nil {
  case render.ensure_dependency_closed(registry.all) {
    Ok(_) -> Nil
    Error(message) -> panic as message
  }

  // Rebuild from scratch so a removed element leaves no stale asset
  // behind for the CLI to fetch.
  let _ = simplifile.delete(dist_directory)
  let assert Ok(_) = simplifile.create_directory_all(dist_directory)
    as "codegen: could not create the dist directory"

  let ui_files = read_directory(ui_directory)
  let elements =
    list.map(registry.all, fn(element) {
      #(element, copy_element_files(element, ui_files))
    })

  write_dist_file("registry.json", registry_json.encode(elements))
  copy_dist_file("theme.css")
}

fn copy_element_files(
  element: Element,
  ui_files: List(String),
) -> List(String) {
  let files = render.element_files(registry.to_string(element.name), ui_files)

  case files {
    [] ->
      panic as {
        "codegen: no files found in "
        <> ui_directory
        <> " for listed element `"
        <> registry.to_string(element.name)
        <> "`"
      }
    _ -> list.each(files, copy_dist_file)
  }
  files
}

fn copy_dist_file(filename: String) -> Nil {
  write_dist_file(filename, read_file(ui_directory <> "/" <> filename))
}

fn write_dist_file(filename: String, contents: String) -> Nil {
  let path = dist_directory <> "/" <> filename
  case simplifile.write(to: path, contents: contents) {
    Ok(_) -> Nil
    Error(e) ->
      panic as {
        "codegen: could not write "
        <> path
        <> ": "
        <> simplifile.describe_error(e)
      }
  }
}

// --- Helpers -----------------------------------------------------------------

fn read_file(from: String) -> String {
  case simplifile.read(from) {
    Ok(content) -> content
    Error(e) ->
      panic as {
        "codegen: could not read "
        <> from
        <> ": "
        <> simplifile.describe_error(e)
      }
  }
}

// Write only on real change; the docs dev server watches this tree, and
// rewriting identical content still results in reloading the browser
// every codegen run.
fn write_file(to: String, contents: String) -> Nil {
  case simplifile.read(to) {
    Ok(existing) if existing == contents -> Nil
    _ ->
      case simplifile.write(to:, contents:) {
        Ok(_) -> Nil
        Error(e) ->
          panic as {
            "codegen: could not write "
            <> to
            <> ": "
            <> simplifile.describe_error(e)
          }
      }
  }
}

fn read_directory(path: String) -> List(String) {
  case simplifile.read_directory(path) {
    Ok(files) -> files
    Error(e) ->
      panic as {
        "codegen: could not read "
        <> path
        <> ": "
        <> simplifile.describe_error(e)
      }
  }
}

// Only installation.gleam has code gleam format reflows; format it here (no
// stdin, hence the scratch) so write_file's idempotent check sees final bytes.
fn format_gleam(source: String) -> String {
  let scratch = "build/codegen_format_scratch.gleam"
  let assert Ok(_) = simplifile.write(scratch, source)
    as "codegen: could not write the format scratch file"
  let assert Ok(_) =
    shellout.command(run: "gleam", with: ["format", scratch], in: ".", opt: [])
    as "codegen: could not gleam-format the scratch file"
  let assert Ok(formatted) = simplifile.read(scratch)
    as "codegen: could not read back the formatted scratch file"
  let _ = simplifile.delete(scratch)
  formatted
}

// --- Constants ---------------------------------------------------------------

const generated_directory: String = "../docs/src/docs/generated"

const install_directory: String = generated_directory <> "/installation"

const example_directory: String = generated_directory <> "/example"

const dist_directory: String = "../dist"

const ui_directory: String = "../ui/src/ui"

const docs_page_directory: String = "../docs/src/docs/page"
