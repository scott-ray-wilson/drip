import docs/route
import docs/ui/search_palette
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import ui/button
import ui/icon

// --- View --------------------------------------------------------------------

pub fn view(
  dark dark: Bool,
  on_toggle_theme on_toggle_theme: message,
  on_open_sidebar on_open_sidebar: message,
) -> Element(message) {
  html.header(
    [
      attribute.class("sticky top-0 z-30 h-16 flex items-center gap-3 px-6"),
      attribute.class(
        "bg-background/80 backdrop-blur-md border-b border-border",
      ),
    ],
    [
      html.a(
        [
          route.href(route.Introduction),
          attribute.class("inline-flex items-center mr-auto"),
          attribute.class("rounded-xs outline-offset-1 focus-visible:outline-2"),
          attribute.class("focus-visible:ring-outline focus-visible:ring"),
        ],
        [
          icon.blocks([attribute.class("text-accent size-4.5 mr-2")]),
          html.span(
            [
              attribute.class("text-lg font-bold"),
              attribute.class("text-foreground"),
            ],
            [html.text("Drip Elements")],
          ),
        ],
      ),

      // --- Search Palette ----------------------------------------------------
      search_palette.view(),

      // --- Theme Toggle ------------------------------------------------------
      button.button(
        [
          button.outline(),
          event.on_click(on_toggle_theme),
          button.icon_only(),
          attribute.aria_label("Dark mode"),
          attribute.aria_pressed(case dark {
            True -> "true"
            False -> "false"
          }),
        ],
        [
          case dark {
            True -> icon.sun([])
            False -> icon.moon([])
          },
        ],
      ),

      // --- Mobile Menu -------------------------------------------------------
      button.button(
        [
          button.outline(),
          button.icon_only(),
          event.on_click(on_open_sidebar),
          attribute.class("lg:hidden"),
          attribute.aria_label("Open navigation menu"),
        ],
        [icon.menu([])],
      ),

      // --- Repository Link ---------------------------------------------------
      button.link(
        [
          button.outline(),
          button.icon_only(),
          attribute.href("https://github.com/scott-ray-wilson/drip"),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
          attribute.aria_label("GitHub repository"),
          attribute.class("max-lg:hidden"),
        ],
        [icon.github([])],
      ),
    ],
  )
}
