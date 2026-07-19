import docs/doc_nav
import docs/element_nav
import docs/route.{type Route}
import docs/ui/footer
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import ui/button
import ui/icon
import ui/sidebar

// --- View --------------------------------------------------------------------

pub fn view(
  current_route current_route: Route,
  open open: Bool,
  on_close on_close: message,
  children children: List(Element(message)),
) -> Element(message) {
  sidebar.root(
    open: open,
    on_close: on_close,
    attributes: [attribute.class("min-h-[calc(100svh-4rem)]! min-w-0")],
    children: [
      sidebar.panel(
        [
          sidebar.not_collapsible(),
          attribute.class(
            "lg:sticky! lg:top-16! lg:h-[calc(100svh-4rem)]! bg-background/80! backdrop-blur-md! lg:self-start!",
          ),
        ],
        [
          // header that only shows in mobile view
          html.div(
            [
              attribute.class(
                "lg:hidden flex items-center justify-between gap-3 mb-3",
              ),
            ],
            [
              button.button(
                [
                  button.ghost(),
                  event.on_click(on_close),
                  attribute.class("-ml-2 gap-2 text-base!"),
                  attribute.aria_label("Close navigation menu"),
                ],
                [icon.x([]), html.text("Menu")],
              ),
              button.link(
                [
                  button.ghost(),
                  button.icon_only(),
                  attribute.href("https://github.com/scott-ray-wilson/drip"),
                  attribute.target("_blank"),
                  attribute.rel("noopener noreferrer"),
                  attribute.aria_label("GitHub repository"),
                ],
                [icon.github([])],
              ),
            ],
          ),
          sidebar.content([attribute.data("scroll-fade", "true")], [
            sidebar.group([], [
              sidebar.group_label([], [html.text("Documentation")]),
              sidebar.menu(
                [],
                list.map(doc_nav.items(), fn(entry) {
                  let #(target, icon, label, _description) = entry
                  case target {
                    route.Elements ->
                      sidebar.menu_item([], [
                        sidebar.menu_link(
                          href: route.path(target),
                          active: current_route == target,
                          attributes: [],
                          children: [icon, html.span([], [html.text(label)])],
                        ),
                        sidebar.menu_sub(
                          [],
                          list.map(element_nav.items(), fn(item) {
                            let #(target, icon, label, _description) = item
                            nav_sub_link(current_route, target, icon, label, [])
                          }),
                        ),
                      ])
                    _ -> nav_link(current_route, target, icon, label)
                  }
                }),
              ),
            ]),
          ]),
        ],
      ),

      // --- Page Content ------------------------------------------------------
      sidebar.inset(
        [
          attribute.class("bg-transparent! min-h-[calc(100svh-4rem)]! py-10"),
          attribute.class("px-4 sm:px-12 xl:px-32"),
        ],
        [
          // A growing flex column so short pages still push the footer to the
          // bottom of the viewport: the content sits in a `grow` spacer, the
          // footer trails it.
          html.div(
            [
              attribute.class(
                "w-full max-w-3xl lg:max-w-4xl mx-auto flex grow flex-col",
              ),
            ],
            [
              html.div([attribute.class("grow")], children),
              footer.view(),
            ],
          ),
        ],
      ),
    ],
  )
}

fn nav_link(
  current_route: Route,
  route: Route,
  icon: Element(message),
  label: String,
) -> Element(message) {
  sidebar.menu_item([], [
    sidebar.menu_link(
      href: route.path(route),
      active: route == current_route,
      attributes: [],
      children: [icon, html.span([], [html.text(label)])],
    ),
  ])
}

fn nav_sub_link(
  current_route: Route,
  route: Route,
  icon: Element(message),
  label: String,
  trailing: List(Element(message)),
) -> Element(message) {
  sidebar.menu_sub_item([], [
    sidebar.menu_sub_link(
      href: route.path(route),
      active: route == current_route,
      attributes: [],
      children: list.append([icon, html.span([], [html.text(label)])], trailing),
    ),
  ])
}
