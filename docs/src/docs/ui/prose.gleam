import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/typography

// --- Anchor ------------------------------------------------------------------

/// A linkable section: `id` is the heading's DOM id and URL hash target,
/// `label` the visible title text.
pub type Anchor {
  Anchor(id: String, label: String)
}

/// Attributes for an in-page link to an anchor: the `#id` href plus the
/// `data-anchor-link` marker the TOC scroll-spy locks onto. Spread into
/// bespoke links; `anchor_link` is the styled version.
pub fn anchor_href(anchor: Anchor) -> List(Attribute(message)) {
  [attribute.href("#" <> anchor.id), attribute.data("anchor-link", "true")]
}

// --- Views -------------------------------------------------------------------

/// An anchor's label wrapped in a link to its own `#id`.
pub fn anchor_link(
  anchor: Anchor,
  attributes: List(Attribute(message)),
) -> Element(message) {
  html.a(
    list.append(anchor_href(anchor), [
      attribute.class(
        "underline decoration-transparent rounded-xs outline-offset-1",
      ),
      attribute.class(
        "focus-visible:outline-2 focus-visible:ring-outline focus-visible:ring",
      ),
      attribute.class(
        "decoration-1 transition-colors hover:decoration-foreground-subtle",
      ),
      ..attributes
    ]),
    [html.text(anchor.label)],
  )
}

/// A standalone "read more" link: accent label with a trailing arrow.
pub fn arrow_link(
  label: String,
  attributes: List(Attribute(message)),
) -> Element(message) {
  html.a(
    [
      attribute.class("font-sans text-[13px] font-medium text-accent"),
      attribute.class(
        "underline-offset-2 hover:decoration-accent decoration-transparent",
      ),
      attribute.class("underline transition-colors duration-200 ease-out-soft"),
      attribute.class("rounded-xs outline-offset-1 focus-visible:outline-2"),
      attribute.class("focus-visible:ring-outline focus-visible:ring"),
      ..attributes
    ],
    [
      // A non-breaking space keeps the underline continuous through the gap
      // (a flex gap would break it) and stops the arrow wrapping alone.
      html.text(label <> "\u{00A0}"),
      html.span([attribute.aria_hidden(True)], [html.text("→")]),
    ],
  )
}

/// An inline link within body prose: accent-colored, settling to the
/// foreground color on hover.
pub fn link(
  label: String,
  attributes: List(Attribute(message)),
) -> Element(message) {
  html.a(
    [
      attribute.class(
        "transition-colors hover:text-(--accent-hover) focus-visible:ring-outline",
      ),
      attribute.class(
        "hover:decoration-accent underline-offset-2 focus-visible:ring",
      ),
      attribute.class(
        "rounded-xs underline transition-colors duration-200 ease-out-soft",
      ),
      attribute.class("outline-offset-1 focus-visible:outline-2"),
      ..attributes
    ],
    [html.text(label)],
  )
}

/// An `h2` section title linking to its own anchor, decorative star at the
/// end.
pub fn heading(anchor: Anchor) -> Element(message) {
  typography.h2([attribute.id(anchor.id)], [
    anchor_link(anchor, [attribute.class("underline-offset-4")]),
    typography.star([], [html.text("*")]),
  ])
}

/// The `h3` counterpart to `heading`.
pub fn subheading(anchor: Anchor) -> Element(message) {
  typography.h3([attribute.id(anchor.id)], [
    anchor_link(anchor, [attribute.class("underline-offset-4")]),
    typography.star([], [html.text("*")]),
  ])
}

/// A body paragraph with the docs' vertical rhythm.
pub fn body(children: List(Element(message))) -> Element(message) {
  typography.body(
    [attribute.class("mt-2 mb-6 [[data-slot=table-container]+&]:mt-6")],
    children,
  )
}

/// A bulleted list with `body`'s type and rhythm.
pub fn bullet_list(items: List(List(Element(message)))) -> Element(message) {
  html.ul(
    [
      attribute.class(
        "mt-2 mb-6 pl-5 list-disc space-y-1.5 font-sans text-sm leading-5",
      ),
      attribute.class("text-muted-foreground marker:text-foreground-subtle"),
    ],
    list.map(items, fn(item) { html.li([], item) }),
  )
}
