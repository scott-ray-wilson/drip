import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A surface container for grouping related content. Pair with the sibling
/// `header`, `eyebrow`, `title`, `description`, `action`, `content`, and
/// `footer` elements to compose a card. A direct `img` first or last child
/// renders edge-to-edge, flush with the card's corners.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card"), ..attributes], children)
}

/// Top region of the card. Hosts the optional `eyebrow`, the `title`,
/// `description`, and optional `action`.
pub fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-header"), ..attributes], children)
}

/// Small uppercase label rendered above the `title` inside a `header`. Use to
/// categorize the card or signal context, such as "Quick Start" or "New".
pub fn eyebrow(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-eyebrow"), ..attributes], children)
}

/// Primary heading inside a `header`.
pub fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-title"), ..attributes], children)
}

/// Secondary supporting text inside a `header`.
pub fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-description"), ..attributes], children)
}

/// Trailing slot inside a `header` for buttons or other controls.
pub fn action(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-action"), ..attributes], children)
}

/// Main body region of the card.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-content"), ..attributes], children)
}

/// Bottom region of the card, typically holding actions or summary text.
pub fn footer(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "card-footer"), ..attributes], children)
}

// --- Size Attributes ---------------------------------------------------------

/// Renders the card at a small size.
pub fn sm() -> Attribute(message) {
  attribute.data("size", "sm")
}

/// Renders the card at a medium size. This is the default when no size
/// attribute is supplied.
pub fn md() -> Attribute(message) {
  attribute.data("size", "md")
}

/// Renders the card at a large size.
pub fn lg() -> Attribute(message) {
  attribute.data("size", "lg")
}
