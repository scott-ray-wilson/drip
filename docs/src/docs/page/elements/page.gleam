import docs/element_icon
import docs/route
import docs/ui/page_header
import drip/registry.{type Element as RegistryElement}
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/card
import ui/icon

// --- View --------------------------------------------------------------------

/// The card grid derives from `registry.all`, so a newly registered element
/// shows up here automatically.
pub fn view() -> Element(message) {
  element.fragment([
    page_header.view(
      route: route.Elements,
      eyebrow: "Documentation",
      title:,
      lede:,
      markdown: markdown(),
      prompt: "help me pick the right drip elements for my UI",
    ),
    html.div(
      [
        attribute.class(
          "grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4 mt-8",
        ),
      ],
      list.map(registry.all, card_item),
    ),

    // --- Coming Soon ---------------------------------------------------------
    alert.root([alert.accent(), attribute.class("w-full mt-4")], [
      alert.icon([], [icon.sparkles([])]),
      alert.title([], [html.text(coming_soon_title)]),
      alert.description([], [html.text(coming_soon_description)]),
    ]),
  ])
}

// --- Markdown ----------------------------------------------------------------

/// The catalog as Markdown: one line per element linking its `.md` docs, so
/// an assistant reading `/elements.md` can follow through to any element.
pub fn markdown() -> String {
  let listing =
    registry.all
    |> list.map(fn(element) {
      "- ["
      <> registry.title(element.name)
      <> "]("
      <> route.public_origin
      <> route.path(route.Element(element.name))
      <> ".md): "
      <> element.description
    })
    |> string.join("\n")

  "# "
  <> title
  <> "\n\n"
  <> lede
  <> "\n\n"
  <> listing
  <> "\n\n"
  <> coming_soon_title
  <> ". "
  <> coming_soon_description
  <> "\n"
}

// --- Page Metadata -----------------------------------------------------------

const title = "Elements"

const lede = "The element catalog. Each element themes through the same CSS
variables and vendors into your project with a single CLI command. Pick one to
read its docs."

const coming_soon_title = "More elements on the way"

const coming_soon_description = "The registry is still growing. Check back soon
for new elements to drop into your project."

// --- Helpers -----------------------------------------------------------------

/// A single catalog tile: the whole card is a link to the element's page. The
/// `group` class lets the trailing arrow react to hovering anywhere on it.
fn card_item(element: RegistryElement) -> Element(message) {
  html.a(
    [
      route.href(route.Element(element.name)),
      attribute.class("group block h-full rounded-2xl"),
      attribute.class("hover:scale-[1.01] transition-transform duration-100"),
      attribute.class("motion-reduce:transition-none"),
      attribute.class("focus-visible:outline-2 focus-visible:outline-offset-0"),
    ],
    [
      card.root(
        [
          attribute.class("h-full min-w-0 bg-[var(--glass-bg)]!"),
          attribute.class(
            "border-[var(--glass-border)]! shadow-[var(--glass-shadow)]!",
          ),
          attribute.class(
            "backdrop-blur-md transition-colors duration-200 ease-out-soft",
          ),
          attribute.class("group-focus-visible:border-outline!"),
        ],
        [
          card.header([], [
            card.title([attribute.class("flex items-center gap-2")], [
              element_icon.for_category(element.category, [
                attribute.class(
                  "size-4 shrink-0 text-muted-foreground transition-colors",
                ),
                attribute.class(
                  "duration-200 ease-out-soft group-hover:text-accent",
                ),
              ]),
              html.text(registry.title(element.name)),
            ]),
            card.description([], [html.text(element.description)]),
            card.action([], [
              icon.arrow_right([
                attribute.class(
                  "size-4 text-muted-foreground transition-all duration-200",
                ),
                attribute.class("ease-out-soft group-hover:text-accent"),
              ]),
            ]),
          ]),
        ],
      ),
    ],
  )
}
