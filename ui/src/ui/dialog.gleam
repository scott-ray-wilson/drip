import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/icon

// --- Setup -------------------------------------------------------------------

/// Wires the click listeners that open a dialog from its trigger, close it from
/// a close button, and dismiss it on a backdrop click. Call once on app start.
@external(javascript, "./dialog.ffi.mjs", "init")
pub fn init() -> Nil

// --- Elements ----------------------------------------------------------------

/// The dialog surface. Renders a native `<dialog>` opened by `showModal()`, so
/// it inherits the platform's focus trap, top-layer stacking, and Escape-to-
/// close for free. Give it the same `id` you pass to `trigger_attributes`, then
/// place a `header`, the body content, and a `footer` inside.
pub fn root(
  id: String,
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.dialog(
    [attribute.id(id), attribute.data("slot", "dialog"), ..attrs],
    children,
  )
}

/// Groups the title and description at the top of the dialog.
pub fn header(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "dialog-header"), ..attrs], children)
}

/// Row of action buttons at the base of the dialog. Stacks on mobile and aligns
/// to the end on `sm` and up.
pub fn footer(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "dialog-footer"), ..attrs], children)
}

/// Renders as `<h2>` so the title participates in heading navigation. The
/// `init` handler wires the dialog's `aria-labelledby` to it on open, so its
/// text becomes the dialog's accessible name.
pub fn title(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h2([attribute.data("slot", "dialog-title"), ..attrs], children)
}

/// Supporting text under the title. The `init` handler wires the dialog's
/// `aria-describedby` to it on open, so it becomes the dialog's accessible
/// description.
pub fn description(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "dialog-description"), ..attrs], children)
}

// --- Trigger Attributes ------------------------------------------------------

/// The attributes any clickable element needs to act as a trigger for the
/// dialog with the given id. Spread these onto a custom button (e.g. a
/// `button.button(..)`) to use it as the trigger.
pub fn trigger_attributes(target_id: String) -> List(Attribute(message)) {
  [attribute.data("dialog-target", target_id)]
}

// --- Close -------------------------------------------------------------------

/// A text button that closes its enclosing dialog on click.
pub fn close(
  attrs: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.button(
    [attribute.data("slot", "dialog-close"), attribute.type_("button"), ..attrs],
    children,
  )
}

/// The close affordance (an X) pinned to the dialog's top-right corner. Carries
/// an `aria-label` of "Close".
pub fn close_button(attrs: List(Attribute(message))) -> Element(message) {
  html.button(
    [
      attribute.data("slot", "dialog-close"),
      attribute.data("variant", "icon"),
      attribute.type_("button"),
      attribute.attribute("aria-label", "Close"),
      ..attrs
    ],
    [icon.x([])],
  )
}

/// The marker any clickable element needs to close its enclosing dialog on
/// click. Spread these onto a custom button (e.g. a `button.primary(..)`) to
/// dismiss the dialog alongside its own action. Lives on its own
/// `data-dialog-close` attribute rather than `data-slot` so it can ride on a
/// `button.*`, which already owns that slot.
pub fn close_attributes() -> List(Attribute(message)) {
  [attribute.data("dialog-close", "")]
}
