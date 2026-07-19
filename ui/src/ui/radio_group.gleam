import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// A `role="radiogroup"` wrapper around the radio items so assistive tech
/// announces them as one group. Give the group an accessible name with
/// `attribute.aria_label` or `attribute.aria_labelledby`.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "radio-group"),
      attribute.attribute("role", "radiogroup"),
      ..attributes
    ],
    children,
  )
}

/// A native `type="radio"` input layered with a dot indicator. Attributes
/// pass through to the native input: share one `name` across the group and
/// give each item its own `value`.
pub fn item(attributes: List(Attribute(message))) -> Element(message) {
  html.span([attribute.data("slot", "radio-group-item")], [
    html.input([attribute.type_("radio"), ..attributes]),
    html.span([attribute.data("slot", "radio-group-indicator")], []),
  ])
}
