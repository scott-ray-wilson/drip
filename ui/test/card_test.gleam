import gleam/string
import lustre/attribute
import lustre/element
import ui/card

pub fn root_stamps_slot_and_size_test() {
  let html = element.to_string(card.root([card.lg()], [element.text("body")]))
  assert string.starts_with(html, "<div")
  assert string.contains(html, "data-slot=\"card\"")
  assert string.contains(html, "data-size=\"lg\"")
  assert string.contains(html, "body")
}

// Each header part stamps its own slot so the CSS can lay them out.
pub fn header_parts_stamp_their_slots_test() {
  let html =
    element.to_string(
      card.header([], [
        card.eyebrow([], [element.text("New")]),
        card.title([], [element.text("Title")]),
        card.description([], [element.text("Desc")]),
        card.action([], []),
      ]),
    )
  assert string.contains(html, "data-slot=\"card-header\"")
  assert string.contains(html, "data-slot=\"card-eyebrow\"")
  assert string.contains(html, "data-slot=\"card-title\"")
  assert string.contains(html, "data-slot=\"card-description\"")
  assert string.contains(html, "data-slot=\"card-action\"")
}

pub fn attributes_pass_through_test() {
  let html = element.to_string(card.content([attribute.id("c")], []))
  assert string.contains(html, "data-slot=\"card-content\"")
  assert string.contains(html, "id=\"c\"")
}
