import docs/ui/prose.{type Anchor}
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

@external(javascript, "./table_of_contents.ffi.mjs", "init")
pub fn init() -> Nil

// --- Table of Contents -------------------------------------------------------

/// A top-level TOC entry.
pub type Entry {
  Entry(anchor: Anchor, children: List(Anchor))
}

/// Leaf TOC entry: single heading anchor, no nested items.
pub fn entry(anchor: Anchor) -> Entry {
  Entry(anchor:, children: [])
}

/// Grouped TOC entry: top-level heading anchor with nested sub-item anchors.
pub fn group(anchor: Anchor, children children: List(Anchor)) -> Entry {
  Entry(anchor:, children:)
}

/// Render a flat list of top-level entries into a complete TOC element.
pub fn view(entries: List(Entry)) -> Element(message) {
  root([], [
    heading([], [html.text("On This Page")]),
    list([], list.map(entries, view_top_level)),
  ])
}

fn view_top_level(entry: Entry) -> Element(message) {
  case entry.children {
    [] -> item("#" <> entry.anchor.id, entry.anchor.label, [])
    children ->
      item("#" <> entry.anchor.id, entry.anchor.label, [
        sub_list([], list.map(children, view_sub_item)),
      ])
  }
}

fn view_sub_item(anchor: Anchor) -> Element(message) {
  sub_item("#" <> anchor.id, anchor.label)
}

// Root -----------------------------------------------------------------------

fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.nav(
    [
      attribute.data("slot", "toc"),
      attribute.aria_label("On this page"),
      attribute.class(
        "hidden xl:flex flex-col w-[14rem] shrink-0 sticky top-[104px]",
      ),
      attribute.class("self-start max-h-[calc(100svh-9rem)]"),
      ..attributes
    ],
    children,
  )
}

// Heading --------------------------------------------------------------------

fn heading(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "toc-heading"),
      attribute.class("font-sans text-2xs tracking-[0.1em] uppercase"),
      attribute.class("text-foreground-subtle font-medium mb-3 shrink-0"),
      ..attributes
    ],
    children,
  )
}

// --- List --------------------------------------------------------------------

fn list(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.ul(
    [
      attribute.data("slot", "toc-list"),
      attribute.data("scroll-fade", "true"),
      attribute.class("flex flex-col text-[13px]"),
      // Negative margin + equal left padding cancel out but move the clip
      // edge 2px outward so focus outlines paint instead of clipping; the
      // right padding keeps focused links off the pane edge.
      attribute.class("overflow-y-auto overflow-x-clip min-h-0"),
      attribute.class("-ml-0.5 pl-0.5 pr-3"),
      ..attributes
    ],
    children,
  )
}

fn sub_list(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.ul(
    [
      attribute.data("slot", "toc-sublist"),
      attribute.class("flex flex-col"),
      ..attributes
    ],
    children,
  )
}

// --- Item --------------------------------------------------------------------

fn item(
  href: String,
  label: String,
  children: List(Element(message)),
) -> Element(message) {
  html.li([attribute.data("slot", "toc-item")], [
    link(href, "pl-3", label),
    ..children
  ])
}

fn sub_item(href: String, label: String) -> Element(message) {
  html.li([attribute.data("slot", "toc-subitem")], [link(href, "pl-8", label)])
}

fn link(href: String, indent: String, label: String) -> Element(message) {
  html.a(
    [
      attribute.data("toc-link", "true"),
      attribute.href(href),
      attribute.class("block py-1 border-l border-border"),
      attribute.class(indent),
      attribute.class(
        "text-foreground-subtle hover:text-foreground transition-colors",
      ),
      // Lift the focused link so the rail borders of the items after it
      // cannot paint over the bottom edge of its focus ring.
      attribute.class("relative focus-visible:z-10"),
      attribute.class("focus-visible:outline-2 focus-visible:outline-offset-0"),
      // The focus border adds 1px on top and bottom; padding gives it back
      // so the row height does not shift.
      attribute.class("focus-visible:border focus-visible:py-[3px]"),
      attribute.class("focus-visible:border-outline!"),
      attribute.class(
        "data-[active=true]:text-accent data-[active=true]:border-accent",
      ),
    ],
    [html.text(label)],
  )
}
