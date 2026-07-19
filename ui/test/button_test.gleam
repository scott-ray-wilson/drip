import gleam/list
import gleam/string
import lustre/attribute
import lustre/element
import lustre/element/html
import ui/button

// --- Helpers -----------------------------------------------------------------

fn occurrences(haystack: String, needle: String) -> Int {
  list.length(string.split(haystack, needle)) - 1
}

// --- Element and Type --------------------------------------------------------

// button() renders a native <button type="button"> carrying the button slot,
// so the CSS attaches and the control never submits a form by accident.
pub fn button_stamps_slot_and_type_test() {
  let html = element.to_string(button.button([], [element.text("Save")]))
  assert string.starts_with(html, "<button")
  assert string.contains(html, "data-slot=\"button\"")
  assert string.contains(html, "type=\"button\"")
  assert string.contains(html, "Save")
}

pub fn submit_uses_submit_type_test() {
  let html = element.to_string(button.submit([], []))
  assert string.contains(html, "type=\"submit\"")
}

pub fn reset_uses_reset_type_test() {
  let html = element.to_string(button.reset([], []))
  assert string.contains(html, "type=\"reset\"")
}

// link() is an anchor, not a button: it carries the button slot for styling
// but no type, so it navigates rather than acting.
pub fn link_is_anchor_with_button_slot_test() {
  let html =
    element.to_string(
      button.link([attribute.href("/docs")], [element.text("Go")]),
    )
  assert string.starts_with(html, "<a")
  assert string.contains(html, "data-slot=\"button\"")
  assert string.contains(html, "href=\"/docs\"")
  assert !string.contains(html, "type=")
}

// --- Variant and Size Attributes ---------------------------------------------

// The variant/size helpers set the data attributes the CSS keys off. One of
// each pins the contract without restating every helper.
pub fn primary_sets_variant_test() {
  let html = element.to_string(button.button([button.primary()], []))
  assert string.contains(html, "data-variant=\"primary\"")
}

pub fn destructive_sets_variant_test() {
  let html = element.to_string(button.button([button.destructive()], []))
  assert string.contains(html, "data-variant=\"destructive\"")
}

pub fn size_sets_data_size_test() {
  let html = element.to_string(button.button([button.sm()], []))
  assert string.contains(html, "data-size=\"sm\"")
}

// icon_start() decorates the icon child, not the button, so the slot lands on
// the child element.
pub fn icon_start_marks_the_child_test() {
  let html =
    element.to_string(button.button([], [html.span([button.icon_start()], [])]))
  assert string.contains(html, "data-icon=\"inline-start\"")
}

// --- Attribute Pass-Through --------------------------------------------------

pub fn attributes_pass_through_test() {
  let html =
    element.to_string(
      button.button([attribute.id("save"), attribute.disabled(True)], []),
    )
  assert string.contains(html, "id=\"save\"")
  assert string.contains(html, "disabled")
}

// --- Override Semantics ------------------------------------------------------

// base() prepends the slot and type, then spreads caller attributes after.
// Lustre serializes BOTH values of a duplicated attribute rather than deduping,
// so a caller who passes a competing slot or type gets two of each, not an
// override. Pin this so callers do not rely on overriding, and so a Lustre
// change to dedupe surfaces here rather than silently in the browser.
pub fn duplicate_attributes_are_both_emitted_test() {
  let html =
    element.to_string(
      button.button(
        [attribute.type_("submit"), attribute.data("slot", "custom")],
        [],
      ),
    )
  assert occurrences(html, "data-slot=\"") == 2
  assert occurrences(html, "type=\"") == 2
  assert string.contains(html, "data-slot=\"button\"")
  assert string.contains(html, "type=\"button\"")
}
