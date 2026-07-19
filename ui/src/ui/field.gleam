import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/separator

// --- Elements ----------------------------------------------------------------

/// A `fieldset` that groups related fields under a shared legend.
pub fn set(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.fieldset([attribute.data("slot", "field-set"), ..attributes], children)
}

/// A field set legend styled as a section heading.
pub fn legend(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.legend(
    [
      attribute.data("slot", "field-legend"),
      attribute.data("variant", "legend"),
      ..attributes
    ],
    children,
  )
}

/// A field set legend styled to match a field label rather than a heading.
pub fn legend_label(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.legend(
    [
      attribute.data("slot", "field-legend"),
      attribute.data("variant", "label"),
      ..attributes
    ],
    children,
  )
}

/// A container that stacks several related fields together.
pub fn group(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "field-group"), ..attributes], children)
}

/// A single field: a `role="group"` wrapper around a label, control, and
/// description.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.attribute("role", "group"),
      attribute.data("slot", "field"),
      ..attributes
    ],
    children,
  )
}

/// Wraps the content of a field, grouping it for layout alongside a control.
pub fn content(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "field-content"), ..attributes], children)
}

/// A `label` for a single control, with a trailing required indicator.
pub fn label(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.label(
    [attribute.data("slot", "field-label"), ..attributes],
    list.append(children, [required_indicator()]),
  )
}

/// A field heading, used in place of `label` where the field's wrapping
/// `label` already binds the control (as in a checkbox or radio card). Its
/// trailing required indicator surfaces when that control is `required`.
pub fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "field-label"), ..attributes],
    list.append(children, [required_indicator()]),
  )
}

/// Supporting helper text for a field.
pub fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "field-description"), ..attributes], children)
}

/// A separator between fields. Pass children to render centered content over
/// the line, or none for a plain divider.
pub fn separator(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  separator.root([attribute.data("variant", "field"), ..attributes], children)
}

/// An error message for a field, announced via `role="alert"`.
pub fn error(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.attribute("role", "alert"),
      attribute.data("slot", "field-error"),
      ..attributes
    ],
    children,
  )
}

// --- Orientation Attributes --------------------------------------------------

/// Lays the field out vertically, with the label above the control. This is
/// the default when no orientation attribute is supplied.
pub fn vertical() -> Attribute(message) {
  attribute.data("orientation", "vertical")
}

/// Lays the field out horizontally, with the label beside the control.
pub fn horizontal() -> Attribute(message) {
  attribute.data("orientation", "horizontal")
}

/// Switches between vertical and horizontal layout based on the width of the
/// surrounding `group`.
pub fn responsive() -> Attribute(message) {
  attribute.data("orientation", "responsive")
}

// --- Internals ---------------------------------------------------------------

fn required_indicator() -> Element(message) {
  html.span(
    [
      attribute.data("slot", "field-required"),
      attribute.aria_hidden(True),
    ],
    [html.text("*")],
  )
}
