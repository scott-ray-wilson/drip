import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Setup -------------------------------------------------------------------

/// Wires the delegated click listener that focuses the inner control when an
/// addon (but not a button inside it) is clicked. Call once on app start.
@external(javascript, "./input_group.ffi.mjs", "init")
pub fn init() -> Nil

// --- Elements ----------------------------------------------------------------

/// Wraps an input control plus addons in a single bordered surface. Focus,
/// hover, and validation state propagate from the inner control to the group.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "input-group"),
      attribute.attribute("role", "group"),
      ..attributes
    ],
    children,
  )
}

/// Leading slot inside an input-group, aligned to the inline-start edge.
/// Hosts icons, badges, or kbd hints.
pub fn addon_start(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  addon("inline-start", attributes, children)
}

/// Trailing slot inside an input-group, mirroring `addon_start` on the
/// inline-end edge.
pub fn addon_end(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  addon("inline-end", attributes, children)
}

/// Top-row slot that stacks above the control. Stretches the input-group
/// into a column layout.
pub fn addon_block_start(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  addon("block-start", attributes, children)
}

/// Bottom-row slot that stacks below the control.
pub fn addon_block_end(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  addon("block-end", attributes, children)
}

/// Compact ghost button sized for inline use inside an addon slot.
pub fn button(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "input-group-button"),
      attribute.type_("button"),
      ..attributes
    ],
    children,
  )
}

/// Muted inline text adornment inside an addon slot: for prefixes,
/// suffixes, or unit labels.
pub fn text(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [attribute.data("slot", "input-group-text"), ..attributes],
    children,
  )
}

/// Single-line input control sized to fill the remaining space inside an
/// input-group.
pub fn text_field(attributes: List(Attribute(message))) -> Element(message) {
  html.input([attribute.data("slot", "input-group-control"), ..attributes])
}

/// Multi-line textarea control sized to fill an input-group. Auto-grows
/// with its content.
pub fn text_area(attributes: List(Attribute(message))) -> Element(message) {
  html.textarea(
    [attribute.data("slot", "input-group-control"), ..attributes],
    "",
  )
}

// --- Addon Base --------------------------------------------------------------

fn addon(
  align: String,
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "input-group-addon"),
      attribute.data("align", align),
      attribute.attribute("role", "group"),
      ..attributes
    ],
    children,
  )
}
