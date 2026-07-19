import docs/element_page.{type ElementPage}
import drip/registry.{type ElementName}
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon
import ui/separator

import docs/page/accordion/page as accordion_page
import docs/page/alert/page as alert_page
import docs/page/button/page as button_page
import docs/page/button_group/page as button_group_page
import docs/page/card/page as card_page
import docs/page/checkbox/page as checkbox_page
import docs/page/cli/page as cli_page
import docs/page/elements/page as elements_page
import docs/page/empty/page as empty_page
import docs/page/field/page as field_page
import docs/page/getting_started/page as getting_started_page
import docs/page/introduction/page as introduction_page
import docs/page/radio_group/page as radio_group_page
import docs/page/separator/page as separator_page
import docs/page/spinner/page as spinner_page
import docs/page/switch/page as switch_page
import docs/page/table/page as table_page
import docs/page/text_area/page as text_area_page
import docs/page/text_field/page as text_field_page
import docs/page/theming/page as theming_page
import docs/route.{type Route}

// --- View --------------------------------------------------------------------

/// Render the page body for a route. Element routes are dispatched by registry
/// name.
pub fn view(route: Route) -> Element(message) {
  case route {
    route.Introduction -> introduction_page.view()
    route.GettingStarted -> getting_started_page.view()
    route.Theming -> theming_page.view()
    route.Cli -> cli_page.view()
    route.Elements -> elements_page.view()
    route.Element(name) -> element_page.view(page_for(name))
    route.NotFound -> not_found()
  }
}

/// Render the on-this-page table of contents for a route. Element pages and the
/// prose pages (introduction, getting started, CLI) carry one.
pub fn table_of_contents(route: Route) -> Element(message) {
  case route {
    route.Introduction -> introduction_page.table_of_contents()
    route.GettingStarted -> getting_started_page.table_of_contents()
    route.Theming -> theming_page.table_of_contents()
    route.Cli -> cli_page.table_of_contents()
    route.Element(name) -> element_page.table_of_contents(page_for(name))
    _ -> element.none()
  }
}

/// The prose (non-element) routes that carry Markdown, each paired with its
/// page module's `markdown` builder. Element pages come from the registry;
/// these few are listed by hand because they are not registry-driven.
fn prose_pages() -> List(#(Route, fn() -> String)) {
  [
    #(route.Introduction, introduction_page.markdown),
    #(route.GettingStarted, getting_started_page.markdown),
    #(route.Theming, theming_page.markdown),
    #(route.Cli, cli_page.markdown),
    #(route.Elements, elements_page.markdown),
  ]
}

/// Map an element to its documentation page. Total: every registry element has
/// a hand-authored page, and unknown slugs never reach here (they parse to
/// `route.NotFound`).
fn page_for(name: ElementName) -> ElementPage(message) {
  case name {
    registry.Accordion -> accordion_page.page()
    registry.Alert -> alert_page.page()
    registry.Button -> button_page.page()
    registry.ButtonGroup -> button_group_page.page()
    registry.Card -> card_page.page()
    registry.Checkbox -> checkbox_page.page()
    registry.Empty -> empty_page.page()
    registry.Field -> field_page.page()
    registry.RadioGroup -> radio_group_page.page()
    registry.Separator -> separator_page.page()
    registry.Spinner -> spinner_page.page()
    registry.Switch -> switch_page.page()
    registry.Table -> table_page.page()
    registry.TextArea -> text_area_page.page()
    registry.TextField -> text_field_page.page()
  }
}

// --- Markdown ----------------------------------------------------------------

/// The page rendered as Markdown, for the copy-page button and the
/// `/elements/<slug>.md` endpoint (aggregated by `markdown_files` and written by
/// `scripts/generate_md.mjs`).
pub fn markdown(route: Route) -> Result(String, Nil) {
  case route {
    route.Element(name) -> Ok(element_page.markdown(page_for(name)))
    _ ->
      case list.key_find(prose_pages(), route) {
        Ok(md) -> Ok(md())
        Error(Nil) -> Error(Nil)
      }
  }
}

/// Every page's Markdown as `#(relative_path, markdown)`: the path under the
/// served root (e.g. "introduction.md", "elements/button.md"). Consumed by
/// `scripts/generate_md.mjs`, which writes the files.
pub fn markdown_files() -> List(#(String, String)) {
  let prose_routes = list.map(prose_pages(), fn(entry) { entry.0 })

  let element_routes =
    list.map(registry.all, fn(element) { route.Element(element.name) })

  list.append(prose_routes, element_routes)
  |> list.filter_map(markdown_file)
}

fn markdown_file(route: Route) -> Result(#(String, String), Nil) {
  case markdown(route) {
    Ok(md) -> Ok(#(route.to_string(route) <> ".md", md))
    Error(Nil) -> Error(Nil)
  }
}

// --- Sitemap -----------------------------------------------------------------

/// The site's `sitemap.xml`: one canonical URL per prose page and element.
/// Written to `assets/` by `scripts/generate_md.mjs`, served at `/sitemap.xml`.
/// Built from the page route list, so it can't drift.
pub fn sitemap() -> String {
  let page_routes = [
    route.Introduction,
    route.GettingStarted,
    route.Cli,
    route.Theming,
    route.Elements,
  ]

  let element_routes =
    list.map(registry.all, fn(element) { route.Element(element.name) })

  let locs =
    list.append(page_routes, element_routes)
    |> list.map(fn(r) {
      "  <url><loc>" <> route.public_origin <> route.path(r) <> "</loc></url>"
    })
    |> string.join("\n")

  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
  <> "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
  <> locs
  <> "\n</urlset>\n"
}

// --- Not Found ---------------------------------------------------------------

/// Whether the route resolves to the 404 page: any unknown URL. Every prose
/// route and registry element resolves to a real page.
pub fn is_not_found(route: Route) -> Bool {
  case route {
    route.NotFound -> True
    _ -> False
  }
}

pub fn not_found() -> Element(message) {
  html.div([attribute.class("flex flex-col items-center gap-8")], [
    html.div([attribute.class("flex items-center gap-6")], [
      html.h1([attribute.class("text-2xl font-medium leading-8")], [
        html.text("404"),
      ]),
      separator.root([separator.vertical()], []),
      html.p([attribute.class("text-sm leading-8 text-muted-foreground")], [
        html.text("This page could not be found."),
      ]),
    ]),
    html.div(
      [
        attribute.class("flex flex-col sm:flex-row items-center gap-3"),
      ],
      [
        button.link(
          [
            button.primary(),
            route.href(route.Introduction),
          ],
          [
            icon.book([button.icon_start()]),
            html.text("View Docs"),
          ],
        ),
        button.link([button.outline(), route.href(route.Elements)], [
          icon.box([button.icon_start()]),
          html.text("Browse Elements"),
        ]),
      ],
    ),
  ])
}
