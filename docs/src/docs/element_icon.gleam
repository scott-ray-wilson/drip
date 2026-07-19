import drip/registry.{type Category}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import ui/icon

// --- Category Icon -----------------------------------------------------------

/// Icon for an element's registry category.
pub fn for_category(
  category: Category,
  attributes: List(Attribute(message)),
) -> Element(message) {
  case category {
    registry.Forms -> icon.text_cursor_input(attributes)
    registry.Actions -> icon.mouse_pointer_click(attributes)
    registry.Navigation -> icon.menu(attributes)
    registry.Overlay -> icon.square_stack(attributes)
    registry.Disclosure -> icon.chevron_down(attributes)
    registry.Layout -> icon.layout_template(attributes)
    registry.DataDisplay -> icon.table(attributes)
    registry.Feedback -> icon.info(attributes)
  }
}
