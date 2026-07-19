import docs/content.{type Block}
import docs/generated/example/button
import docs/page/button/example/disabled
import docs/page/button/example/full_width
import docs/page/button/example/icon_only
import docs/page/button/example/inline_icon
import docs/page/button/example/invalid
import docs/page/button/example/pending
import docs/page/button/example/sizes
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const inline_icon_anchor = Anchor(id: "inline-icon", label: "Inline Icon")

const icon_only_anchor = Anchor(id: "icon-only", label: "Icon Only")

const sizes_anchor = Anchor(id: "sizes", label: "Sizes")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

const pending_anchor = Anchor(id: "pending", label: "Pending")

const invalid_anchor = Anchor(id: "invalid", label: "Invalid")

const full_width_anchor = Anchor(id: "full-width", label: "Full Width")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      inline_icon_anchor,
      icon_only_anchor,
      sizes_anchor,
      disabled_anchor,
      pending_anchor,
      invalid_anchor,
      full_width_anchor,
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
    content.Paragraph([
      content.Text(
        "Adjust the size, state, or layout of a button with modifier
        attributes.",
      ),
    ]),

    // --- Inline Icon ---------------------------------------------------------
    content.SectionExample(
      anchor: inline_icon_anchor,
      description: [
        content.Text(
          "Include leading or trailing icons in your buttons using the inline
          slots.",
        ),
      ],
      code: button.inline_icon_html,
      body: [inline_icon.view()],
    ),

    // --- Icon Only -----------------------------------------------------------
    content.SectionExample(
      anchor: icon_only_anchor,
      description: [
        content.Text(
          "Render a square button sized for a single icon child using the icon
          only attribute.",
        ),
      ],
      code: button.icon_only_html,
      body: [icon_only.view()],
    ),

    // --- Sizes ---------------------------------------------------------------
    content.SectionExample(
      anchor: sizes_anchor,
      description: [
        content.Text(
          "Scale a button from extra small to large using the various size
          attributes.",
        ),
      ],
      code: button.sizes_html,
      body: [sizes.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Block interactivity and reduce opacity using the disabled attribute.",
        ),
      ],
      code: button.disabled_html,
      body: [disabled.view()],
    ),

    // --- Pending -------------------------------------------------------------
    content.SectionExample(
      anchor: pending_anchor,
      description: [
        content.Text(
          "Mark a button as busy by setting aria-busy, revealing a spinner child
          if present. Pair with disabled.",
        ),
      ],
      code: button.pending_html,
      body: [pending.view()],
    ),

    // --- Invalid -------------------------------------------------------------
    content.SectionExample(
      anchor: invalid_anchor,
      description: [
        content.Text(
          "Surface an error ring when a button is the visible trigger for an
          invalid form control by setting aria-invalid.",
        ),
      ],
      code: button.invalid_html,
      body: [invalid.view()],
    ),

    // --- Full Width ----------------------------------------------------------
    content.SectionExample(
      anchor: full_width_anchor,
      description: [
        content.Text(
          "Use the full width attribute to stretch a button to fill its parent's
          width.",
        ),
      ],
      code: button.full_width_html,
      body: [full_width.view()],
    ),
  ])
}
