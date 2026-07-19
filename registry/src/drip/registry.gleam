//// Drip element registry; the source of truth for what elements exist,
//// their dependencies, and metadata. `codegen` (Erlang) and `docs`
//// (JavaScript) both compile this module, so it must stay pure data with no
//// platform-specific code.
////
//// An element that is not ready to ship simply has no entry here: its
//// `<name>.*` sources can live in `ui/` and build in-repo without reaching the
//// emitted registry, the docs, or `drip add`. Add its `Element` const when it
//// is ready.

import gleam/list
import gleam/string

// --- Registry ----------------------------------------------------------------

pub type Registry =
  List(Element)

pub type ElementName {
  Accordion
  Alert
  Button
  ButtonGroup
  Card
  Checkbox
  Empty
  Field
  RadioGroup
  Separator
  Spinner
  Switch
  Table
  TextArea
  TextField
}

pub fn to_string(name: ElementName) -> String {
  case name {
    Accordion -> "accordion"
    Alert -> "alert"
    Button -> "button"
    ButtonGroup -> "button_group"
    Card -> "card"
    Checkbox -> "checkbox"
    Empty -> "empty"
    Field -> "field"
    RadioGroup -> "radio_group"
    Separator -> "separator"
    Spinner -> "spinner"
    Switch -> "switch"
    Table -> "table"
    TextArea -> "text_area"
    TextField -> "text_field"
  }
}

pub fn from_string(name: String) -> Result(ElementName, Nil) {
  case list.find(all, fn(element) { to_string(element.name) == name }) {
    Ok(element) -> Ok(element.name)
    Error(Nil) -> Error(Nil)
  }
}

/// The element's display title: its snake_case name title-cased.
/// `button_group` -> `Button Group`.
pub fn title(name: ElementName) -> String {
  to_string(name)
  |> string.split(on: "_")
  |> list.map(string.capitalise)
  |> string.join(with: " ")
}

pub type Element {
  Element(
    /// The element's identity; `to_string` gives its file stem and slug.
    name: ElementName,
    /// One-line summary shown in docs and `drip list`.
    description: String,
    /// Which catalog section the element belongs to.
    category: Category,
    /// Ships a `<name>.ffi.mjs` alongside the Gleam module.
    ffi: Bool,
    /// Other elements this one depends on.
    registry_dependencies: List(ElementName),
    /// Gleam packages this element depends on.
    dependencies: List(String),
  )
}

pub type Category {
  /// Controls that capture user input, plus their labels and layout.
  Forms
  /// Controls whose primary job is to trigger an action.
  Actions
  /// Move between views or sections: tabs, breadcrumbs, pagination.
  Navigation
  /// Float transient content above the page: dialogs, menus, popovers.
  Overlay
  /// Expand and collapse content in place.
  Disclosure
  /// Structure and surfaces that arrange other content.
  Layout
  /// Present structured or inline data.
  DataDisplay
  /// Communicate status or pending state to the user.
  Feedback
}

// --- Catalog -----------------------------------------------------------------

pub const accordion: Element = Element(
  name: Accordion,
  description: "A set of interactive headings that reveal or hide a section of content.",
  category: Disclosure,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const alert: Element = Element(
  name: Alert,
  description: "An inline callout that surfaces an important message.",
  category: Feedback,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const button: Element = Element(
  name: Button,
  description: "An interactive control that triggers an action, submits a form, or resets it.",
  category: Actions,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const button_group: Element = Element(
  name: ButtonGroup,
  description: "A row or column of related buttons joined into a single semantic unit.",
  category: Actions,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const card: Element = Element(
  name: Card,
  description: "A surface that groups related content and actions into a contained block.",
  category: Layout,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const checkbox: Element = Element(
  name: Checkbox,
  description: "A control that toggles a single option on or off.",
  category: Forms,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const empty: Element = Element(
  name: Empty,
  description: "A composable empty state for surfaces with nothing to show.",
  category: Layout,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const field: Element = Element(
  name: Field,
  description: "A layout that pairs a form control with its label, description, and message.",
  category: Forms,
  ffi: False,
  registry_dependencies: [Separator],
  dependencies: [],
)

pub const radio_group: Element = Element(
  name: RadioGroup,
  description: "A set of mutually exclusive options sharing a single name.",
  category: Forms,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const separator: Element = Element(
  name: Separator,
  description: "A thin divider for visually separating content.",
  category: Layout,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const spinner: Element = Element(
  name: Spinner,
  description: "An indeterminate loading indicator for pending states.",
  category: Feedback,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const switch: Element = Element(
  name: Switch,
  description: "A binary toggle for settings that take effect immediately.",
  category: Forms,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const table: Element = Element(
  name: Table,
  description: "A semantic data table for displaying rows of structured information.",
  category: DataDisplay,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const text_area: Element = Element(
  name: TextArea,
  description: "A multi-line text input that auto-grows with longer content.",
  category: Forms,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const text_field: Element = Element(
  name: TextField,
  description: "A single-line text input for short, free-form values.",
  category: Forms,
  ffi: False,
  registry_dependencies: [],
  dependencies: [],
)

pub const all: Registry = [
  accordion,
  alert,
  button,
  button_group,
  card,
  checkbox,
  empty,
  field,
  radio_group,
  separator,
  spinner,
  switch,
  table,
  text_area,
  text_field,
]

// --- Queries -----------------------------------------------------------------

pub fn find(registry: Registry, name: ElementName) -> Result(Element, Nil) {
  list.find(registry, fn(element) { element.name == name })
}
