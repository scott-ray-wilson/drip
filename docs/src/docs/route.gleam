import drip/registry.{type ElementName}
import gleam/string
import gleam/uri.{type Uri}
import lustre/attribute.{type Attribute}

// --- Route -------------------------------------------------------------------

pub const public_origin = "https://drip.pink"

pub type Route {
  Introduction
  GettingStarted
  Theming
  Cli
  Elements
  Element(name: ElementName)
  NotFound
}

pub fn parse(url: Uri) -> Route {
  let url_segments = uri.path_segments(url.path)
  case url_segments {
    [] | ["introduction"] -> Introduction
    ["getting-started"] -> GettingStarted
    ["theming"] -> Theming
    ["cli"] -> Cli
    ["elements"] -> Elements
    ["elements", slug] ->
      case registry.from_string(slug_to_name(slug)) {
        Ok(name) -> Element(name)
        Error(Nil) -> NotFound
      }
    _ -> NotFound
  }
}

pub fn href(route: Route) -> Attribute(message) {
  attribute.href(path(route))
}

/// Sections other pages deep-link into. The owning page builds its heading
/// `Anchor` from the same id, so the links and the headings cannot drift
/// apart.
pub const manual_setup_id = "manual-setup"

pub const default_theme_id = "default-theme"

/// A link into an anchored section of another page: `/theming#default-theme`.
/// In-page hash links use `prose.anchor_href` instead, which adds the marker
/// the scroll-spy tracks; cross-page links must not carry it.
pub fn section_href(route: Route, id: String) -> Attribute(message) {
  attribute.href(path(route) <> "#" <> id)
}

pub fn path(route: Route) -> String {
  let relative = case route {
    Introduction -> ["introduction"]
    GettingStarted -> ["getting-started"]
    Theming -> ["theming"]
    Cli -> ["cli"]
    Elements -> ["elements"]
    Element(name) -> ["elements", name_to_slug(registry.to_string(name))]
    NotFound -> ["404"]
  }

  "/" <> string.join(relative, with: "/")
}

/// The route as a relative path with no leading slash (`elements/button`),
/// used to build each page's `.md` filename. See `path` for the absolute URL
/// form used in links.
pub fn to_string(route: Route) -> String {
  string.drop_start(path(route), up_to: 1)
}

// Registry names are snake_case (`button_group`); URLs hyphenate them
// (`/elements/button-group`) to stay consistent with the other routes
// (`/getting-started`).
fn name_to_slug(name: String) -> String {
  string.replace(name, each: "_", with: "-")
}

fn slug_to_name(slug: String) -> String {
  string.replace(slug, each: "-", with: "_")
}
