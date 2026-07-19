import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/button

// --- Setup -------------------------------------------------------------------

/// Wires the click listeners that open a dialog from its trigger and close it
/// from an action or cancel button. Call once on app start.
@external(javascript, "./alert_dialog.ffi.mjs", "init")
pub fn init() -> Nil

// --- Elements ----------------------------------------------------------------

/// Wrapper that scopes a trigger to its dialog. Place a `trigger_attributes`-
/// tagged element and an `alert_dialog.default` (or `.compact`) as siblings
/// inside. Renders with `display: contents`, so it adds no layout box of its
/// own.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "alert-dialog-root"), ..attributes],
    children,
  )
}

/// The alert dialog surface at its default size. Renders a native `<dialog>`
/// (role `alertdialog`) opened by `showModal()`; place a `header` and a
/// `footer` of actions inside. Widens to a larger measure on `sm` and up.
pub fn default(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  dialog("default", attributes, children)
}

/// The alert dialog surface at a compact size for short prompts. Keeps a
/// narrow measure with a centered, icon-above-title layout and an even two-up
/// footer; otherwise identical to `default`.
pub fn compact(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  dialog("compact", attributes, children)
}

/// Groups the eyebrow, media, title, and description at the top of the dialog.
pub fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "alert-dialog-header"), ..attributes],
    children,
  )
}

/// Row of action buttons at the base of the dialog. Stacks on mobile and
/// aligns to the end on `sm` and up.
pub fn footer(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "alert-dialog-footer"), ..attributes],
    children,
  )
}

/// Optional leading icon tile shown in the header alongside the title.
pub fn media(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [attribute.data("slot", "alert-dialog-media"), ..attributes],
    children,
  )
}

/// Small uppercase tracked label that sits above the title to cue the
/// dialog's intent at a glance ("CONFIRM", "DESTRUCTIVE", "INFO"). Defaults
/// to the brand accent color; pass an `attribute.class("text-destructive")`
/// (or similar) to retint per call site. Decorative: not part of the
/// accessible name.
pub fn eyebrow(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p(
    [
      attribute.data("slot", "alert-dialog-eyebrow"),
      attribute.attribute("aria-hidden", "true"),
      ..attributes
    ],
    children,
  )
}

/// Renders as `<h2>` so the dialog title participates in heading navigation.
/// The FFI assigns it an `id` and wires the dialog's `aria-labelledby` to it
/// on open, so the title's text becomes the dialog's accessible name.
pub fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h2(
    [attribute.data("slot", "alert-dialog-title"), ..attributes],
    children,
  )
}

/// Supporting text under the title. The FFI wires the dialog's
/// `aria-describedby` to it on open, so it becomes the dialog's accessible
/// description.
pub fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p(
    [attribute.data("slot", "alert-dialog-description"), ..attributes],
    children,
  )
}

// --- Trigger Attributes ------------------------------------------------------

/// The attributes any clickable element needs to act as a trigger for the
/// alert dialog rendered as its sibling inside the surrounding `root`. Spread
/// these onto a custom button (e.g. a `button.destructive(..)`) to use it as
/// the trigger instead of the default. Lives on its own `data-alert-dialog-
/// trigger` attribute rather than `data-slot` so it doesn't collide with the
/// `data-slot` already set by elements like `button.outline`.
pub fn trigger_attributes() -> List(Attribute(message)) {
  [attribute.data("alert-dialog-trigger", "")]
}

// --- Actions -----------------------------------------------------------------

/// Primary confirm button. Renders a `button.primary` carrying the
/// close-on-click marker. Use for non-destructive confirmations; prefer
/// `destructive_action` for irreversible actions.
pub fn action(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  button.button([button.primary(), closer_attribute(), ..attributes], children)
}

/// Destructive confirm button for irreversible actions like delete or discard.
/// Renders a `button.destructive` carrying the close-on-click marker.
pub fn destructive_action(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  button.button(
    [button.destructive(), closer_attribute(), ..attributes],
    children,
  )
}

/// Outline cancel button. Renders a `button.outline` carrying the close-on-
/// click marker and `autofocus` so `showModal()` lands focus here on open;
/// the APG recommends focusing the least-destructive option in alert dialogs
/// guarding an irreversible action. Override by placing `autofocus` on a
/// different element earlier in the dialog's DOM order.
pub fn cancel(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  button.button(
    [
      button.outline(),
      closer_attribute(),
      attribute.attribute("autofocus", ""),
      ..attributes
    ],
    children,
  )
}

// --- Dialog Base -------------------------------------------------------------

fn dialog(
  size: String,
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.dialog(
    [
      attribute.data("slot", "alert-dialog"),
      attribute.data("size", size),
      // `role="alertdialog"` upgrades the native <dialog>'s implicit role so
      // assistive tech can distinguish this from a regular dialog (APG). The
      // `aria-labelledby`/`aria-describedby` IDs are wired up by the FFI right
      // before `showModal()`; see `alert_dialog.ffi.mjs`.
      attribute.attribute("role", "alertdialog"),
      attribute.attribute("aria-modal", "true"),
      ..attributes
    ],
    children,
  )
}

// --- Close Marker ------------------------------------------------------------

// The marker the FFI watches for to close the dialog on click. Sits on its
// own attribute namespace rather than `data-slot` because `button.*` already
// owns that slot; duplicate attributes keep the first occurrence, so
// stacking would silently drop one of them.
fn closer_attribute() -> Attribute(message) {
  attribute.data("alert-dialog-close", "")
}
