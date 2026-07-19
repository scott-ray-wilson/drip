import docs/generated/installation
import docs/route
import docs/ui/code_block
import docs/ui/prose.{type Anchor, Anchor}
import docs/ui/table_of_contents.{type Entry}
import drip/registry.{type Element as RegistryElement, type ElementName}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon
import ui/tabs
import ui/typography

// --- Table of Contents -------------------------------------------------------

pub const heading_anchor: Anchor = Anchor(
  id: "installation",
  label: "Installation",
)

pub fn table_of_contents() -> List(Entry) {
  [table_of_contents.entry(heading_anchor)]
}

// --- View --------------------------------------------------------------------

pub fn view(element: RegistryElement) -> Element(message) {
  element.fragment([
    prose.heading(heading_anchor),
    tabs.root([], [
      tabs.list(
        [
          tabs.line(),
        ],
        [
          tabs.trigger(value: "cli", active: True, attributes: [], children: [
            html.text("CLI"),
          ]),
          tabs.trigger(
            value: "manual",
            active: False,
            attributes: [],
            children: [
              html.text("Manual"),
            ],
          ),
        ],
      ),

      // --- CLI Install Tab ---------------------------------------------------
      tabs.content(value: "cli", active: True, attributes: [], children: [
        prose.body([
          html.text(
            "Add this element and its dependencies to your project using the ",
          ),
          prose.link("Drip CLI", [route.href(route.Cli)]),
          html.text("."),
        ]),
        code_block.shell(
          "shell",
          "gleam run -m drip -- add " <> registry.to_string(element.name),
        ),
      ]),

      // --- Manual Install Tab ------------------------------------------------
      tabs.content(value: "manual", active: False, attributes: [], children: [
        prose.body([
          html.text("Drop the files below into your "),
          typography.code([], [html.text("src/ui/")]),
          html.text(" folder and "),
          typography.code([], [html.text("@import")]),
          html.text(" the CSS file in your "),
          prose.link("index stylesheet", [
            route.section_href(route.GettingStarted, route.manual_setup_id),
          ]),
          html.text("."),
        ]),

        // --- Dependency Callout ----------------------------------------------
        // Only rendered when the element vendors at least one other
        // element. Each dep links to its own docs page.
        case element.registry_dependencies {
          [] -> element.none()
          dependencies ->
            alert.root([alert.neutral(), attribute.class("mb-6")], [
              alert.icon([], [icon.box([])]),
              alert.title([], [html.text("Dependencies")]),
              alert.description(
                [],
                [
                  html.text("This element also vendors "),
                  ..interleave_commas(list.map(dependencies, dependency_link))
                ]
                  |> append_period(),
              ),
            ])
        },

        // --- Manual Install Code Block ---------------------------------------
        code_block.file(
          installation.tabs_for(registry.to_string(element.name)),
          expand: True,
        ),
      ]),
    ]),
  ])
}

// --- Helpers -----------------------------------------------------------------

fn dependency_link(name: ElementName) -> Element(message) {
  html.a([route.href(route.Element(name))], [html.text(registry.title(name))])
}

fn interleave_commas(items: List(Element(message))) -> List(Element(message)) {
  case items {
    [] -> []
    [last] -> [last]
    [a, b] -> [a, html.text(" and "), b]
    [head, ..rest] -> [head, html.text(", "), ..interleave_commas(rest)]
  }
}

fn append_period(parts: List(Element(message))) -> List(Element(message)) {
  list.append(parts, [html.text(".")])
}
