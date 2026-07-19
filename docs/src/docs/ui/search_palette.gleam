import docs/doc_nav
import docs/element_nav
import docs/route.{type Route}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/command
import ui/dialog

// --- View --------------------------------------------------------------------

const id = "command-palette"

pub fn view() -> Element(message) {
  element.fragment([
    command.trigger(
      list.append(dialog.trigger_attributes(id), [
        attribute.class("hidden md:inline-flex md:w-72"),
        attribute.aria_label("Search documentation (" <> shortcut_hint() <> ")"),
      ]),
      [
        command.trigger_label([attribute.class("hidden sm:block")], [
          html.text("Search documentation..."),
        ]),
        command.kbd([attribute.class("hidden sm:inline-flex")], [
          html.text(shortcut_hint()),
        ]),
      ],
    ),
    command.dialog(id, [], [
      command.root([], [
        command.input(
          placeholder: "Search documentation…",
          attrs: [
            attribute.aria_label("Search documentation"),
            attribute.autofocus(True),
          ],
          trailing: [],
        ),
        command.list([], [
          command.group(
            heading: "Documentation",
            attrs: [],
            children: list.map(doc_nav.items(), item),
          ),
          command.group(
            heading: "Elements",
            attrs: [],
            children: list.map(element_nav.items(), item),
          ),
          command.empty([], [html.text("No results found.")]),
        ]),
        command.footer([], [
          command.key([], [html.text("Enter")]),
          html.text("Open"),
          command.spacer(),
          command.key([], [html.text("Esc")]),
          html.text("Close"),
        ]),
      ]),
    ]),
  ])
}

/// A result row: the entry's one-line description renders as a second line
/// and, via the palette's text matching, makes the entry searchable by what
/// it does, not just what it's called.
fn item(entry: #(Route, Element(message), String, String)) -> Element(message) {
  let #(target, icon, label, description) = entry
  command.item_link(href: route.path(target), attrs: [], children: [
    icon,
    command.label([], [
      html.text(label),
      command.description([], [html.text(description)]),
    ]),
  ])
}

/// The trigger's shortcut hint: ⌘K on Apple platforms, Ctrl+K elsewhere.
fn shortcut_hint() -> String {
  case is_apple_platform() {
    True -> "⌘K"
    False -> "Ctrl+K"
  }
}

// --- FFI ---------------------------------------------------------------------

@external(javascript, "./search_palette.ffi.mjs", "init")
fn do_init(id: String) -> Nil

/// Wire up the ⌘K / Ctrl-K toggle, result dismissal, and query reset on close
/// for the search palette.
pub fn init() -> Nil {
  do_init(id)
}

@external(javascript, "./search_palette.ffi.mjs", "is_apple_platform")
fn is_apple_platform() -> Bool
