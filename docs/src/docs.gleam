import docs/page
import docs/route.{type Route}
import docs/ui/code_block
import docs/ui/header
import docs/ui/page_header
import docs/ui/preview
import docs/ui/search_palette
import docs/ui/sidebar
import docs/ui/table_of_contents
import drip/registry
import gleam/option
import gleam/uri.{type Uri}
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/keyed
import modem
import ui/command
import ui/dialog
import ui/dropdown_menu
import ui/input_group
import ui/tabs

// --- Main --------------------------------------------------------------------

pub fn main() -> Nil {
  let assert Ok(initial_url) = modem.initial_uri()

  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", initial_url)

  Nil
}

// --- Model -------------------------------------------------------------------

type Theme {
  Dark
  Light
}

type Model {
  Model(route: Route, theme: Theme, sidebar_open: Bool)
}

// Init -----------------------------------------------------------------------

fn init(initial_uri: Uri) -> #(Model, Effect(Message)) {
  let route = route.parse(initial_uri)

  let theme = case get_theme() {
    "light" -> Light
    _ -> Dark
  }

  #(
    Model(route:, theme:, sidebar_open: False),
    effect.batch([
      modem.init(UserChangedUrl),
      redirect_root_effect(initial_uri),
      global_init_effect(),
      scroll_init_effect(),
      scroll_to_fragment_effect(initial_uri),
      set_title_effect(route),
    ]),
  )
}

// Each stateful element attaches its DOM behaviors (focus traps, keyboard nav,
// dismissal) via FFI; run once after the first paint, when the markup they
// hook into exists.
fn global_init_effect() -> Effect(Message) {
  effect.after_paint(fn(_dispatch, _root) {
    tabs.init()
    command.init()
    dialog.init()
    dropdown_menu.init()
    input_group.init()
    code_block.init()
    page_header.init()
    preview.init()
    search_palette.init()
  })
}

// Unlike global_init_effect, this re-runs on every navigation: the ToC spy and
// edge fades are page-scoped, so they rebuild against the new page's headings
// and scroll areas whenever the route changes.
fn scroll_init_effect() -> Effect(Message) {
  effect.after_paint(fn(_dispatch, _root) {
    table_of_contents.init()
    init_scroll_fades()
  })
}

fn scroll_to_fragment_effect(url: Uri) -> Effect(Message) {
  case url.fragment {
    option.Some(fragment) ->
      effect.after_paint(fn(_dispatch, _root) { scroll_to_fragment(fragment) })
    option.None -> effect.none()
  }
}

fn set_title_effect(route: Route) -> Effect(Message) {
  let title = case route {
    route.Introduction -> "Introduction"
    route.GettingStarted -> "Getting Started"
    route.Theming -> "Theming"
    route.Cli -> "CLI"
    route.Elements -> "Elements"
    route.Element(name) -> registry.title(name)
    route.NotFound -> "Page Not Found"
  }
  effect.from(fn(_dispatch) { set_title(title <> " | Drip Elements") })
}

/// `/` already resolves to the Introduction route, so this changes nothing on
/// screen; it only canonicalizes the address bar to `/introduction` (via
/// replace, so no extra history entry) instead of leaving a bare `/`.
fn redirect_root_effect(url: Uri) -> Effect(Message) {
  case uri.path_segments(url.path) {
    [""] | [] -> modem.replace("/introduction", option.None, option.None)
    _ -> effect.none()
  }
}

// --- Update ------------------------------------------------------------------

type Message {
  UserChangedUrl(url: Uri)
  UserToggledTheme
  UserOpenedSidebar
  UserClosedSidebar
}

fn update(model: Model, message: Message) -> #(Model, Effect(Message)) {
  case message {
    UserChangedUrl(url) -> {
      let route = route.parse(url)

      #(
        Model(..model, route:, sidebar_open: False),
        effect.batch([
          scroll_init_effect(),
          set_title_effect(route),
          redirect_root_effect(url),
          // modem scrolls to the hash before the new page paints, so a
          // cross-page anchor link needs this second pass after the patch.
          scroll_to_fragment_effect(url),
        ]),
      )
    }

    UserToggledTheme -> {
      let next_theme = case model.theme {
        Dark -> Light
        Light -> Dark
      }
      let theme_name = case next_theme {
        Dark -> "dark"
        Light -> "light"
      }
      #(
        Model(..model, theme: next_theme),
        effect.from(fn(_) { set_theme(theme_name) }),
      )
    }

    UserOpenedSidebar -> #(Model(..model, sidebar_open: True), effect.none())
    UserClosedSidebar -> #(Model(..model, sidebar_open: False), effect.none())
  }
}

// --- View --------------------------------------------------------------------

fn view(model: Model) -> Element(Message) {
  case page.is_not_found(model.route) {
    True -> view_not_found()
    False -> view_docs(model)
  }
}

fn view_not_found() -> Element(Message) {
  html.div(
    [
      attribute.class("flex min-h-svh w-full items-center justify-center px-4"),
    ],
    [page.not_found()],
  )
}

fn view_docs(model: Model) -> Element(Message) {
  element.fragment([
    header.view(
      dark: model.theme == Dark,
      on_toggle_theme: UserToggledTheme,
      on_open_sidebar: UserOpenedSidebar,
    ),
    html.div([attribute.class("flex")], [
      sidebar.view(
        current_route: model.route,
        open: model.sidebar_open,
        on_close: UserClosedSidebar,
        children: [
          // Keyed by route so navigation replaces the page subtree instead of
          // morphing it: FFI-flipped state (expanded previews and code blocks,
          // tab selection) lives only in the real DOM and would survive a
          // cross-page morph. Theme and sidebar re-renders keep the same key,
          // so in-page state survives those.
          keyed.fragment([#(route.path(model.route), page.view(model.route))]),
        ],
      ),
      page.table_of_contents(model.route),
    ]),
  ])
}

// --- FFI ---------------------------------------------------------------------

@external(javascript, "./docs.ffi.mjs", "set_theme")
fn set_theme(theme: String) -> Nil

@external(javascript, "./docs.ffi.mjs", "get_theme")
fn get_theme() -> String

@external(javascript, "./docs.ffi.mjs", "set_title")
fn set_title(title: String) -> Nil

@external(javascript, "./docs.ffi.mjs", "scroll_to_fragment")
fn scroll_to_fragment(fragment: String) -> Nil

@external(javascript, "./docs.ffi.mjs", "init_scroll_fades")
fn init_scroll_fades() -> Nil
