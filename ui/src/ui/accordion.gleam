import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/icon

// --- Elements ----------------------------------------------------------------

/// A stack of collapsible sections. Wrap one or more `item`s and set the
/// visual style with a variant attribute.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "accordion"), ..attributes], children)
}

/// A single collapsible row. Wrap a `trigger` and a `content` together
/// inside each item.
pub fn item(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.details(
    [attribute.data("slot", "accordion-item"), ..attributes],
    children,
  )
}

/// Clickable header that toggles its parent `item` open and closed.
pub fn trigger(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.summary(
    [attribute.data("slot", "accordion-trigger"), ..attributes],
    list.append(children, [
      icon.chevron_down([
        attribute.data("slot", "accordion-trigger-icon"),
        attribute.aria_hidden(True),
      ]),
    ]),
  )
}

/// Body of the row revealed when its parent `item` is open.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "accordion-content"), ..attributes],
    children,
  )
}

// --- Variant Attributes ------------------------------------------------------

/// Borderless stack of collapsible sections separated by a hairline. This is
/// the default when no variant attribute is supplied.
pub fn ghost() -> Attribute(message) {
  attribute.data("variant", "ghost")
}

/// Bordered rows collapsed into a single outlined group, no fill.
pub fn outline() -> Attribute(message) {
  attribute.data("variant", "outline")
}

/// Bordered, filled rows collapsed into a single group. Highest emphasis variant.
pub fn filled() -> Attribute(message) {
  attribute.data("variant", "filled")
}
