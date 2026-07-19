//// `drip` vendors Lustre UI elements (Gleam, CSS, and sometimes a little FFI)
//// straight into your project's `src/`. Run it from the root of a Gleam +
//// Lustre project with `gleam run -m drip -- <command>`.
////
//// ## Commands
////
//// | Command | What it does |
//// |---------|--------------|
//// | `init` | Scaffolds `theme.css`, the generated `index.css`, and wires up your entry stylesheet. |
//// | `list` | Lists the elements in the registry, marking which are already vendored. |
//// | `add <element>...` | Vendors one or more elements and their dependencies into `src/<prefix>/`. |
//// | `remove <element>...` | Deletes the named elements' files. |
////
//// ## Flags
////
//// | Flag | Commands | Description |
//// |------|----------|-------------|
//// | `--prefix <dir>` | `init` | Directory under `src/` that elements vendor into, saved to `[tools.drip]` in your `gleam.toml` (default: `ui`). |
//// | `--source <url-or-path>` | `init` | Registry to vendor from, a URL or local path, saved to `[tools.drip]` in your `gleam.toml` (default: the latest GitHub release). |
//// | `--force` | `init`, `add` | Overwrite files that already exist on disk. |
////
//// Pass `--help` to any command to see its usage. The full element catalog,
//// configuration reference, and live examples live at <https://drip.pink>.

import argv
import drip/internal/cli
import drip/internal/error
import drip/internal/project
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam_community/ansi

// --- Main --------------------------------------------------------------------

/// Entry point for the `drip` CLI, invoked by `gleam run -m drip`.
pub fn main() -> Nil {
  let result = {
    use project <- result.try(project.load())

    use output <- result.map(cli.run(project, argv.load().arguments))

    case output {
      "" -> Nil
      _ -> io.println(colorize(output))
    }
  }

  case result {
    Ok(_) -> Nil
    // glint usage errors carry their own header and help text; red would drown it.
    Error(error.InvalidUsage(message)) -> {
      io.println_error(message)
      halt(1)
    }
    Error(cause) -> {
      io.println_error(ansi.red(error.describe(cause)))
      halt(1)
    }
  }
}

// --- Colorize ----------------------------------------------------------------

fn colorize(text: String) -> String {
  text
  |> string.split("\n")
  |> list.map(colorize_line)
  |> string.join("\n")
}

fn colorize_line(line: String) -> String {
  case string.trim_start(line) {
    "+ " <> _ -> ansi.green(line)
    "- " <> _ -> ansi.red(line)
    "~ " <> _ -> ansi.yellow(line)
    "= " <> _ -> ansi.dim(line)
    "✓ " <> _ -> ansi.green(line)
    "Next steps:" <> _ -> ansi.bold(line)
    "call " <> _ -> ansi.bright_yellow(line)
    "gleam " <> _ -> ansi.bright_yellow(line)
    _ -> line
  }
}

// --- FFI ---------------------------------------------------------------------

@external(erlang, "erlang", "halt")
fn halt(code: Int) -> Nil
