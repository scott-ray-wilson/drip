import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// Surface container for an empty state housing a `header` and `content`. Set
/// the framing with a variant attribute.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "empty"), ..attributes], children)
}

/// Top region of the empty state. Wraps the optional `media`, `icon`,
/// `title`, and `description`.
pub fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "empty-header"), ..attributes], children)
}

/// Transparent media slot for illustrations or larger imagery in a `header`.
pub fn media(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "empty-media"), ..attributes], children)
}

/// Tinted square media slot sized for a single decorative icon inside a
/// `header`. Hidden from assistive technology; use `media` for meaningful
/// imagery.
pub fn icon(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "empty-icon"),
      attribute.aria_hidden(True),
      ..attributes
    ],
    children,
  )
}

/// Primary heading inside a `header`.
pub fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "empty-title"), ..attributes], children)
}

/// Secondary supporting text inside a `header`.
pub fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "empty-description"), ..attributes],
    children,
  )
}

/// Main body region of the empty state, typically holding actions or
/// follow-up text below the `header`.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "empty-content"), ..attributes], children)
}

// --- Variant Attributes ------------------------------------------------------

/// Borderless surface for empty states a surrounding card or panel already
/// frames. This is the default when no variant attribute is supplied.
pub fn ghost() -> Attribute(message) {
  attribute.data("variant", "ghost")
}

/// Frames the surface with a dashed border. Use when the empty state stands
/// on its own.
pub fn outline() -> Attribute(message) {
  attribute.data("variant", "outline")
}
