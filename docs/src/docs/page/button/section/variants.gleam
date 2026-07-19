import docs/content.{type Block}
import docs/generated/example/button
import docs/page/button/example/accent
import docs/page/button/example/destructive
import docs/page/button/example/ghost
import docs/page/button/example/outline
import docs/page/button/example/primary
import docs/page/button/example/secondary
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "variants", label: "Variants")

const primary_anchor = Anchor(id: "primary", label: "Primary")

const secondary_anchor = Anchor(id: "secondary", label: "Secondary")

const accent_anchor = Anchor(id: "accent", label: "Accent")

const outline_anchor = Anchor(id: "outline", label: "Outline")

const ghost_anchor = Anchor(id: "ghost", label: "Ghost")

const destructive_anchor = Anchor(id: "destructive", label: "Destructive")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      primary_anchor,
      secondary_anchor,
      accent_anchor,
      outline_anchor,
      ghost_anchor,
      destructive_anchor,
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
        "Six visual styles to cover anything from primary CTAs to ghost-style
        toolbar controls.",
      ),
    ]),

    // --- Primary -------------------------------------------------------------
    content.SectionExample(
      anchor: primary_anchor,
      description: [
        content.Text(
          "The standard high-contrast variant for primary page actions.",
        ),
      ],
      code: button.primary_html,
      body: [primary.view()],
    ),

    // --- Secondary -----------------------------------------------------------
    content.SectionExample(
      anchor: secondary_anchor,
      description: [
        content.Text(
          "Lower-emphasis filled button for supporting actions that sit beside a
          primary.",
        ),
      ],
      code: button.secondary_html,
      body: [secondary.view()],
    ),

    // --- Accent --------------------------------------------------------------
    content.SectionExample(
      anchor: accent_anchor,
      description: [
        content.Text(
          "Brand-aligned button for feature actions and high-visibility CTAs.",
        ),
      ],
      code: button.accent_html,
      body: [accent.view()],
    ),

    // --- Outline -------------------------------------------------------------
    content.SectionExample(
      anchor: outline_anchor,
      description: [
        content.Text(
          "Bordered, transparent button for low-emphasis actions that still need
          a visible affordance.",
        ),
      ],
      code: button.outline_html,
      body: [outline.view()],
    ),

    // --- Ghost ---------------------------------------------------------------
    content.SectionExample(
      anchor: ghost_anchor,
      description: [
        content.Text(
          "Borderless, transparent button for the lowest-emphasis actions and
          toolbar controls.",
        ),
      ],
      code: button.ghost_html,
      body: [ghost.view()],
    ),

    // --- Destructive ---------------------------------------------------------
    content.SectionExample(
      anchor: destructive_anchor,
      description: [
        content.Text(
          "Filled button for irreversible or dangerous actions like delete,
          remove, or revoke.",
        ),
      ],
      code: button.destructive_html,
      body: [destructive.view()],
    ),
  ])
}
