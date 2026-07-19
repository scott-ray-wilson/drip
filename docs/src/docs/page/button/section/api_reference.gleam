import docs/content.{type Block}
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "api-reference", label: "API Reference")

const constructors_anchor = Anchor(
  id: "constructors-api",
  label: "Constructors",
)

const variants_anchor = Anchor(id: "variants-api", label: "Variants")

const size_anchor = Anchor(id: "size-attributes-api", label: "Size Attributes")

const layout_anchor = Anchor(
  id: "layout-attributes-api",
  label: "Layout Attributes",
)

const state_anchor = Anchor(
  id: "state-attributes-api",
  label: "State Attributes",
)

const icon_slot_anchor = Anchor(
  id: "icon-slot-attributes-api",
  label: "Icon Slot Attributes",
)

const selectors_anchor = Anchor(id: "selectors-api", label: "Selectors")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      constructors_anchor,
      variants_anchor,
      size_anchor,
      layout_anchor,
      state_anchor,
      icon_slot_anchor,
      selectors_anchor,
    ]),
  ]
}

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  content.to_lustre(content())
}

// --- Markdown ----------------------------------------------------------------

pub fn markdown() -> String {
  content.to_markdown(content())
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  content.Group([
    content.Heading(heading_anchor),

    // --- Constructors --------------------------------------------------------
    content.Subheading(constructors_anchor),
    content.Paragraph([
      content.Text(
        "Four constructors, each one produces a different button behavior.",
      ),
    ]),
    content.Table(headers: ["Constructor", "Description"], rows: [
      [
        content.signature_cell("button.button(attrs, children)"),
        content.text_cell(
          "Runs an action without submitting a form; renders type=\"button\".",
        ),
      ],
      [
        content.signature_cell("button.submit(attrs, children)"),
        content.text_cell(
          "Submits its enclosing form; renders type=\"submit\".",
        ),
      ],
      [
        content.signature_cell("button.reset(attrs, children)"),
        content.text_cell(
          "Resets its enclosing form's fields; renders type=\"reset\".",
        ),
      ],
      [
        content.signature_cell("button.link(attrs, children)"),
        content.text_cell(
          "An anchor styled as a button, for navigation rather than actions.",
        ),
      ],
    ]),

    // --- Variants ------------------------------------------------------------
    content.Subheading(variants_anchor),
    content.Paragraph([
      content.Text("Sets the button's visual emphasis and intent."),
    ]),
    content.Table(headers: ["Variant", "Description"], rows: [
      [
        content.signature_cell("button.primary()"),
        content.text_cell(
          "The default high-contrast fill for the primary action, usually one per
          page or form.",
        ),
      ],
      [
        content.signature_cell("button.secondary()"),
        content.text_cell(
          "Lower-emphasis fill for supporting actions beside a primary.",
        ),
      ],
      [
        content.signature_cell("button.accent()"),
        content.text_cell(
          "Brand-aligned fill for feature actions and high-visibility CTAs.",
        ),
      ],
      [
        content.signature_cell("button.outline()"),
        content.text_cell(
          "Bordered and transparent, for low-emphasis actions that still need a
          visible affordance.",
        ),
      ],
      [
        content.signature_cell("button.ghost()"),
        content.text_cell(
          "Borderless and transparent, for the lowest-emphasis actions and
          toolbar controls.",
        ),
      ],
      [
        content.signature_cell("button.destructive()"),
        content.text_cell(
          "Filled, for irreversible or dangerous actions like delete or revoke.",
        ),
      ],
    ]),

    // --- Size Attributes -----------------------------------------------------
    content.Subheading(size_anchor),
    content.Paragraph([
      content.Text("Adjusts the button's height, padding, and font size."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("button.xs()"),
        content.text_cell(
          "Extra-small, for dense toolbars and inline controls.",
        ),
      ],
      [
        content.signature_cell("button.sm()"),
        content.text_cell("Small, a common choice for compact forms."),
      ],
      [
        content.signature_cell("button.md()"),
        content.text_cell(
          "Medium, the default; matches a button with no size attribute.",
        ),
      ],
      [
        content.signature_cell("button.lg()"),
        content.text_cell("Large, for hero CTAs."),
      ],
    ]),

    // --- Layout Attributes ---------------------------------------------------
    content.Subheading(layout_anchor),
    content.Paragraph([
      content.Text("Changes the button's shape or width within its container."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("button.icon_only()"),
        content.text_cell(
          "Renders a square button sized for a single icon child.",
        ),
      ],
      [
        content.signature_cell("button.full_width()"),
        content.text_cell("Stretches the button to fill its parent's width."),
      ],
    ]),

    // --- State Attributes ----------------------------------------------------
    content.Subheading(state_anchor),
    content.Paragraph([
      content.Text(
        "Signals the button's availability and any in-flight or error state.",
      ),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("attribute.disabled(True)"),
        content.text_cell(
          "Blocks pointer events, reduces opacity, and removes the button from
          the tab order.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_disabled(True)"),
        content.text_cell(
          "Same visual treatment as disabled but keeps the button focusable so
          screen readers can still announce it. Suited to toolbars and async
          actions.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_busy(True)"),
        content.text_cell(
          "Centers a spinner child over the content, if passed. Pair with
          disabled to block interaction.",
        ),
      ],
      [
        content.signature_cell("attribute.aria_invalid(\"true\")"),
        content.text_cell(
          "Adds a destructive error ring when the button is the visible trigger
          for an invalid form control.",
        ),
      ],
    ]),

    // --- Icon Slot Attributes ------------------------------------------------
    content.Subheading(icon_slot_anchor),
    content.Paragraph([
      content.Text("Apply these to the "),
      content.Strong("icon child element"),
      content.Text(", not the button itself."),
    ]),
    content.Table(headers: ["Attribute", "Description"], rows: [
      [
        content.signature_cell("button.icon_start()"),
        content.text_cell(
          "Marks an icon as the leading (inline-start) child. The button reduces
          its leading padding.",
        ),
      ],
      [
        content.signature_cell("button.icon_end()"),
        content.text_cell(
          "Marks an icon as the trailing (inline-end) child. The button reduces
          its trailing padding.",
        ),
      ],
    ]),

    // --- Selectors -----------------------------------------------------------
    content.Subheading(selectors_anchor),
    content.Paragraph([
      content.Text(
        "CSS selectors stamped on the button's markup, available for overriding
        or layering app-specific styles.",
      ),
    ]),
    content.Table(headers: ["Selector", "Matches"], rows: [
      [
        content.selector_cell("[data-slot=\"button\"]"),
        content.text_cell("The button or link element."),
      ],
      [
        content.selector_cell("[data-variant=\"primary|secondary|...\"]"),
        content.text_cell("The element, tagged with its active variant."),
      ],
      [
        content.selector_cell("[data-size=\"xs|sm|md|lg\"]"),
        content.text_cell("The element, tagged with its active size."),
      ],
      [
        content.selector_cell("[data-full-width=\"true\"]"),
        content.text_cell("A button stretched to fill its container."),
      ],
      [
        content.selector_cell("[data-icon-only=\"true\"]"),
        content.text_cell("A square button sized for a single icon child."),
      ],
      [
        content.selector_cell("[aria-busy=\"true\"]"),
        content.text_cell("A pending button."),
      ],
      [
        content.selector_cell("[disabled]"),
        content.text_cell("A disabled button, dropped from the tab order."),
      ],
      [
        content.selector_cell("[aria-disabled=\"true\"]"),
        content.text_cell("An inactive button, kept focusable."),
      ],
      [
        content.selector_cell("[aria-invalid=\"true\"]"),
        content.text_cell("A button flagged as an invalid form trigger."),
      ],
      [
        content.selector_cell("[data-icon=\"inline-start|inline-end\"]"),
        content.text_cell("A leading or trailing icon child."),
      ],
      [
        content.selector_cell("[data-slot=\"spinner\"]"),
        content.text_cell(
          "The spinner child centered over a pending button's label.",
        ),
      ],
    ]),
  ])
}
