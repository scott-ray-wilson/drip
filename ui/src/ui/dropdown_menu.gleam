import gleam/int
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/portal

// --- Setup -------------------------------------------------------------------

/// Wires the click and keyboard listeners and registers the `<lustre-portal>`
/// custom element the content slot uses to teleport itself to the document
/// body. Call once at app start.
pub fn init() -> Nil {
  let _ = portal.register()
  do_init()
}

@external(javascript, "./dropdown_menu.ffi.mjs", "init")
fn do_init() -> Nil

// --- Elements ----------------------------------------------------------------

/// Groups a trigger and its floating content slot. Renders as a fragment, so
/// only the trigger lays out in flow: the content teleports to `<body>` via
/// `lustre_portal` and its host element is hidden, contributing no layout
/// box at the declaration site.
pub fn root(children: List(Element(message))) -> Element(message) {
  element.fragment(children)
}

/// Popover surface that holds the menu items. Hidden until the trigger
/// toggles it open. The content is teleported to `<body>` and positioned by
/// the FFI; the `<lustre-portal>` host left in place is hidden so it never
/// becomes a flex or grid item.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  portal.to(target: "body", with: [attribute.hidden(True)], teleport: [
    html.div(
      [
        attribute.data("slot", "dropdown-menu-content"),
        attribute.attribute("role", "menu"),
        attribute.data("state", "closed"),
        ..attributes
      ],
      children,
    ),
  ])
}

/// Semantic grouping for related items inside the menu, via `role="group"`.
pub fn group(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "dropdown-menu-group"),
      attribute.attribute("role", "group"),
      ..attributes
    ],
    children,
  )
}

/// Standard menu item.
pub fn item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  base_item([attribute.data("variant", "default"), ..attributes], children)
}

/// Menu item styled to indicate an irreversible or dangerous action.
pub fn destructive_item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  base_item([attribute.data("variant", "destructive"), ..attributes], children)
}

/// Menu item that navigates rather than acts: an anchor styled like a
/// standard item. Pass `attribute.href(..)` along with any `target` or `rel`
/// attributes.
pub fn link_item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.a(
    [
      attribute.data("slot", "dropdown-menu-item"),
      attribute.data("variant", "default"),
      attribute.attribute("role", "menuitem"),
      ..attributes
    ],
    children,
  )
}

/// Section heading inside the menu.
pub fn label(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "dropdown-menu-label"), ..attributes],
    children,
  )
}

/// Visual divider between groups of items.
pub fn separator(attributes: List(Attribute(message))) -> Element(message) {
  html.hr([
    attribute.data("slot", "dropdown-menu-separator"),
    attribute.attribute("role", "separator"),
    ..attributes
  ])
}

/// Trailing keyboard-shortcut hint, aligned to the right of an item.
pub fn shortcut(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [attribute.data("slot", "dropdown-menu-shortcut"), ..attributes],
    children,
  )
}

// --- Trigger Attributes ------------------------------------------------------

/// The attributes any clickable element needs to act as a dropdown trigger.
/// Spread these onto a custom button (e.g. a `button.button(..)`) to wire
/// `aria-controls` to the matching `dropdown_menu.content` (which must carry
/// `attribute.id(content_id)`).
pub fn trigger_attributes(content_id: String) -> List(Attribute(message)) {
  [
    attribute.attribute("data-dropdown-menu-trigger", ""),
    attribute.attribute("aria-haspopup", "menu"),
    attribute.attribute("aria-expanded", "false"),
    attribute.attribute("aria-controls", content_id),
  ]
}

// --- Side Attributes ---------------------------------------------------------

/// Anchors the content above the trigger.
pub fn top() -> Attribute(message) {
  attribute.data("side", "top")
}

/// Anchors the content below the trigger. This is the default.
pub fn bottom() -> Attribute(message) {
  attribute.data("side", "bottom")
}

/// Anchors the content to the left of the trigger.
pub fn left() -> Attribute(message) {
  attribute.data("side", "left")
}

/// Anchors the content to the right of the trigger.
pub fn right() -> Attribute(message) {
  attribute.data("side", "right")
}

// --- Alignment Attributes ----------------------------------------------------

/// Aligns the content's start edge with the trigger's start edge along the
/// cross axis (inline-start for top/bottom, block-start for left/right).
/// This is the default.
pub fn align_start() -> Attribute(message) {
  attribute.data("align", "start")
}

/// Centers the content on the trigger along the cross axis.
pub fn align_center() -> Attribute(message) {
  attribute.data("align", "center")
}

/// Aligns the content's end edge with the trigger's end edge along the cross
/// axis.
pub fn align_end() -> Attribute(message) {
  attribute.data("align", "end")
}

// --- Offset Attributes -------------------------------------------------------

/// Overrides the gap (pixels) between the trigger and the content along the
/// anchor side. Defaults to 4px when unset. Spread onto a
/// `dropdown_menu.content`.
pub fn side_offset(px: Int) -> Attribute(message) {
  attribute.data("side-offset", int.to_string(px))
}

/// Shifts the content along the cross axis when align is `start` or `end`.
/// Has no effect with `center` alignment. Spread onto a
/// `dropdown_menu.content`.
pub fn align_offset(px: Int) -> Attribute(message) {
  attribute.data("align-offset", int.to_string(px))
}

// --- Collision Attributes ----------------------------------------------------

/// Toggles the FFI's collision-avoidance pass. Enabled by default: the menu
/// flips to the opposite side when the preferred side overflows the
/// viewport, and clamps along the cross axis to stay on screen. Pass `False`
/// to anchor strictly on the requested side and let it clip. Spread onto a
/// `dropdown_menu.content`.
pub fn avoid_collisions(enabled: Bool) -> Attribute(message) {
  attribute.data("avoid-collisions", case enabled {
    True -> "true"
    False -> "false"
  })
}

/// Pads the viewport boundary used by the flip and shift steps, in pixels.
/// Larger values reserve more breathing room at the edge before the menu
/// flips or starts clamping. Defaults to 0 when unset. Spread onto a
/// `dropdown_menu.content`. Per-side helpers (`collision_padding_top`,
/// etc.) override this value on a single edge.
pub fn collision_padding(px: Int) -> Attribute(message) {
  attribute.data("collision-padding", int.to_string(px))
}

/// Overrides the top-edge collision padding. Falls back to the value set by
/// `collision_padding` when unset. Use to clear a sticky header without
/// inflating padding on the other three sides.
pub fn collision_padding_top(px: Int) -> Attribute(message) {
  attribute.data("collision-padding-top", int.to_string(px))
}

/// Overrides the right-edge collision padding. Falls back to the value set
/// by `collision_padding` when unset.
pub fn collision_padding_right(px: Int) -> Attribute(message) {
  attribute.data("collision-padding-right", int.to_string(px))
}

/// Overrides the bottom-edge collision padding. Falls back to the value set
/// by `collision_padding` when unset.
pub fn collision_padding_bottom(px: Int) -> Attribute(message) {
  attribute.data("collision-padding-bottom", int.to_string(px))
}

/// Overrides the left-edge collision padding. Falls back to the value set
/// by `collision_padding` when unset.
pub fn collision_padding_left(px: Int) -> Attribute(message) {
  attribute.data("collision-padding-left", int.to_string(px))
}

// --- Item Base ---------------------------------------------------------------

fn base_item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "dropdown-menu-item"),
      attribute.attribute("role", "menuitem"),
      attribute.type_("button"),
      ..attributes
    ],
    children,
  )
}
