import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

/// The docs' pill buttons ("Show code", "Expand code", and their sticky
/// "Hide"/"Collapse" counterparts). Callers stack their own positioning and
/// state-variant utilities on top via `attributes`.
pub fn button(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.type_("button"),
      attribute.class("cursor-pointer select-none"),
      attribute.class("inline-flex items-center"),
      attribute.class("px-2 pt-0.5 pb-px"),
      attribute.class("font-sans text-[9.5px] uppercase tracking-[0.1em]"),
      attribute.class("font-medium text-foreground-subtle"),
      attribute.class("hover:text-foreground"),
      attribute.class("bg-gradient-to-br from-card to-background"),
      attribute.class("hover:bg-card/90 backdrop-blur-sm"),
      attribute.class("border border-border rounded-xs"),
      attribute.class("focus-visible:outline-2 focus-visible:border-outline"),
      attribute.class("transition-colors"),
      ..attributes
    ],
    children,
  )
}
