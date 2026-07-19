import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import ui/icon
import ui/separator

// --- Elements ----------------------------------------------------------------

/// Lays out a sidebar beside its main content. Holds the open/closed
/// `data-state` that descendants react to, and renders a mobile backdrop that
/// fires `on_close` when tapped. Place a `panel` and an `inset` inside.
pub fn root(
  open open: Bool,
  on_close on_close: message,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let state = case open {
    True -> "expanded"
    False -> "collapsed"
  }
  html.div(
    [
      attribute.data("slot", "sidebar-wrapper"),
      attribute.data("state", state),
      ..attributes
    ],
    list.append(children, [mobile_backdrop(on_close)]),
  )
}

fn mobile_backdrop(on_close: message) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "sidebar-backdrop"),
      attribute.attribute("aria-hidden", "true"),
      event.on_click(on_close),
    ],
    [],
  )
}

/// The sidebar itself. Compose its look with the side, variant, and collapsible
/// attribute functions; the default is a left, standard, off-canvas sidebar.
pub fn panel(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.aside([attribute.data("slot", "sidebar"), ..attributes], [
    html.div([attribute.data("slot", "sidebar-inner")], children),
  ])
}

/// The main content region rendered beside the sidebar.
pub fn inset(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.main([attribute.data("slot", "sidebar-inset"), ..attributes], children)
}

/// A toggle button carrying a panel-left icon and an accessible label. Wire it
/// to your own toggle message with `event.on_click`.
pub fn trigger(attributes: List(Attribute(message))) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "sidebar-trigger"),
      attribute.type_("button"),
      attribute.attribute("aria-label", "Toggle Sidebar"),
      ..attributes
    ],
    [icon.panel_left([])],
  )
}

/// A thin, keyboard-skippable strip along the sidebar's edge that toggles it on
/// click. Wire it with `event.on_click`.
pub fn rail(attributes: List(Attribute(message))) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "sidebar-rail"),
      attribute.type_("button"),
      attribute.attribute("aria-label", "Toggle Sidebar"),
      attribute.attribute("tabindex", "-1"),
      attribute.attribute("title", "Toggle Sidebar"),
      ..attributes
    ],
    [],
  )
}

/// Top region of the sidebar, above the scrolling content.
pub fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "sidebar-header"), ..attributes], children)
}

/// Bottom region of the sidebar, pinned below the scrolling content.
pub fn footer(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "sidebar-footer"), ..attributes], children)
}

/// The scrolling middle region that holds the sidebar's groups and menus.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "sidebar-content"), ..attributes], children)
}

/// A titled section within the content, wrapping a `group_label` and a `menu`.
pub fn group(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "sidebar-group"), ..attributes], children)
}

/// A small heading that titles a `group`.
pub fn group_label(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "sidebar-group-label"), ..attributes],
    children,
  )
}

/// An icon button pinned to a `group`'s top-right corner for a section action.
pub fn group_action(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "sidebar-group-action"),
      attribute.type_("button"),
      ..attributes
    ],
    children,
  )
}

/// Wraps the body of a `group` below its label.
pub fn group_content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "sidebar-group-content"), ..attributes],
    children,
  )
}

/// The list of navigation items within a group.
pub fn menu(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.ul([attribute.data("slot", "sidebar-menu"), ..attributes], children)
}

/// A single row in a `menu`, wrapping a button or link and any actions.
pub fn menu_item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.li([attribute.data("slot", "sidebar-menu-item"), ..attributes], children)
}

/// A button-based menu item. Set `active` to mark the current item.
pub fn menu_button(
  active active: Bool,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let rest = case active {
    True -> [attribute.data("active", "true"), ..attributes]
    False -> attributes
  }
  html.button(
    [
      attribute.data("slot", "sidebar-menu-button"),
      attribute.type_("button"),
      ..rest
    ],
    children,
  )
}

/// A link-based menu item. Set `active` to mark the current page; this also
/// exposes `aria-current="page"` to assistive tech.
pub fn menu_link(
  href href: String,
  active active: Bool,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let rest = case active {
    True -> [
      attribute.data("active", "true"),
      attribute.aria_current("page"),
      ..attributes
    ]
    False -> attributes
  }
  html.a(
    [
      attribute.data("slot", "sidebar-menu-button"),
      attribute.href(href),
      ..rest
    ],
    children,
  )
}

/// An icon button pinned to a `menu_item`'s trailing edge for a row action.
pub fn menu_action(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "sidebar-menu-action"),
      attribute.type_("button"),
      ..attributes
    ],
    children,
  )
}

/// A small count or status badge pinned to a `menu_item`'s trailing edge.
pub fn menu_badge(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "sidebar-menu-badge"), ..attributes],
    children,
  )
}

/// A loading placeholder shaped like a menu item, with an optional leading
/// icon block.
pub fn menu_skeleton(show_icon show_icon: Bool) -> Element(message) {
  let children = case show_icon {
    True -> [
      html.div([attribute.data("slot", "sidebar-menu-skeleton-icon")], []),
      html.div([attribute.data("slot", "sidebar-menu-skeleton-text")], []),
    ]
    False -> [
      html.div([attribute.data("slot", "sidebar-menu-skeleton-text")], []),
    ]
  }
  html.div([attribute.data("slot", "sidebar-menu-skeleton")], children)
}

/// A nested list of secondary items, indented under a `menu_item`.
pub fn menu_sub(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.ul([attribute.data("slot", "sidebar-menu-sub"), ..attributes], children)
}

/// A single row within a `menu_sub`.
pub fn menu_sub_item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.li(
    [attribute.data("slot", "sidebar-menu-sub-item"), ..attributes],
    children,
  )
}

/// A link-based submenu item. Set `active` to mark the current page; this also
/// exposes `aria-current="page"` to assistive tech.
pub fn menu_sub_link(
  href href: String,
  active active: Bool,
  attributes attributes: List(Attribute(message)),
  children children: List(Element(message)),
) -> Element(message) {
  let rest = case active {
    True -> [
      attribute.data("active", "true"),
      attribute.aria_current("page"),
      ..attributes
    ]
    False -> attributes
  }
  html.a(
    [
      attribute.data("slot", "sidebar-menu-sub-button"),
      attribute.href(href),
      ..rest
    ],
    children,
  )
}

/// A horizontal rule that divides sidebar sections, inset to match the
/// sidebar's padding.
pub fn separator(attributes: List(Attribute(message))) -> Element(message) {
  separator.root([attribute.data("variant", "sidebar"), ..attributes], [])
}

// --- Side Attributes ---------------------------------------------------------

/// Positions the sidebar against the left edge. This is the default when no
/// side attribute is supplied.
pub fn left() -> Attribute(message) {
  attribute.data("side", "left")
}

/// Positions the sidebar against the right edge.
pub fn right() -> Attribute(message) {
  attribute.data("side", "right")
}

// --- Variant Attributes ------------------------------------------------------

/// Detaches the sidebar into a rounded, shadowed panel set in from the edge.
pub fn floating() -> Attribute(message) {
  attribute.data("variant", "floating")
}

/// Sits the sidebar flush and floats the `inset` content beside it as a rounded
/// card. Pair with an `inset` for the main content region.
pub fn inset_variant() -> Attribute(message) {
  attribute.data("variant", "inset")
}

// --- Collapsible Attributes --------------------------------------------------

/// Collapses the sidebar fully off-canvas on desktop. This is the default when
/// no collapsible attribute is supplied.
pub fn offcanvas() -> Attribute(message) {
  attribute.data("collapsible", "offcanvas")
}

/// Collapses the sidebar to a narrow icon rail on desktop.
pub fn icon_rail() -> Attribute(message) {
  attribute.data("collapsible", "icon")
}

/// Keeps the sidebar at full width on desktop; it never collapses.
pub fn not_collapsible() -> Attribute(message) {
  attribute.data("collapsible", "none")
}
