import gleam/string
import lustre/element
import ui/field

// A field is a semantic group so its label, control, and description announce
// together.
pub fn root_is_a_group_test() {
  let html = element.to_string(field.root([], []))
  assert string.contains(html, "data-slot=\"field\"")
  assert string.contains(html, "role=\"group\"")
}

// label() appends a required indicator, hidden from assistive tech since the
// label text carries the meaning. Pin it so the marker cannot silently vanish.
pub fn label_appends_hidden_required_marker_test() {
  let html = element.to_string(field.label([], [element.text("Email")]))
  assert string.starts_with(html, "<label")
  assert string.contains(html, "data-slot=\"field-label\"")
  assert string.contains(html, "data-slot=\"field-required\"")
  assert string.contains(html, "aria-hidden=\"true\"")
  assert string.contains(html, "Email")
}

// error() is announced via role="alert".
pub fn error_is_announced_test() {
  let html = element.to_string(field.error([], [element.text("Required")]))
  assert string.contains(html, "data-slot=\"field-error\"")
  assert string.contains(html, "role=\"alert\"")
}

// legend and legend_label share a slot, differing only by variant.
pub fn legends_share_slot_differ_by_variant_test() {
  let legend = element.to_string(field.legend([], []))
  assert string.starts_with(legend, "<legend")
  assert string.contains(legend, "data-slot=\"field-legend\"")
  assert string.contains(legend, "data-variant=\"legend\"")

  let labeled = element.to_string(field.legend_label([], []))
  assert string.contains(labeled, "data-variant=\"label\"")
}

// separator() delegates to the separator element with a field variant.
pub fn separator_delegates_with_field_variant_test() {
  let html = element.to_string(field.separator([], []))
  assert string.contains(html, "data-slot=\"separator\"")
  assert string.contains(html, "data-variant=\"field\"")
}
