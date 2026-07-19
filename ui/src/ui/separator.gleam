import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A divider between sections of content. Pass children to render
/// centered content over the line, or none for a plain rule.
///
/// The rule is decorative (`role="none"`): assistive tech skips it but
/// still reads any centered content.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  let #(attributes, inner) = case children {
    [] -> #(attributes, [])
    _ -> #([attribute.data("content", "true"), ..attributes], [
      html.span([attribute.data("slot", "separator-content")], children),
    ])
  }
  html.div(
    [
      attribute.data("slot", "separator"),
      attribute.attribute("role", "none"),
      ..attributes
    ],
    inner,
  )
}

// --- Orientation Attributes --------------------------------------------------

/// Lays the rule along the inline axis, filling the parent's width. This is
/// the default when no orientation attribute is supplied.
pub fn horizontal() -> Attribute(message) {
  attribute.data("orientation", "horizontal")
}

/// Lays the rule along the block axis, stretching to fill the parent's
/// height. Drop inside a flex container so self-stretch can resolve.
pub fn vertical() -> Attribute(message) {
  attribute.data("orientation", "vertical")
}
