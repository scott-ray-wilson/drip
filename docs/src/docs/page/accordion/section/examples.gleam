import docs/content.{type Block}
import docs/generated/example/accordion
import docs/page/accordion/example/default as default_example
import docs/page/accordion/example/disabled
import docs/page/accordion/example/exclusive
import docs/page/accordion/example/icon
import docs/page/accordion/example/open
import docs/page/accordion/example/rich_content
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const default_anchor = Anchor(id: "default", label: "Default")

const open_anchor = Anchor(id: "open", label: "Open")

const exclusive_anchor = Anchor(id: "exclusive", label: "Exclusive")

const disabled_anchor = Anchor(id: "disabled", label: "Disabled")

const rich_content_anchor = Anchor(id: "rich-content", label: "Rich Content")

const icon_anchor = Anchor(id: "icon", label: "Icon")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      default_anchor,
      open_anchor,
      exclusive_anchor,
      disabled_anchor,
      rich_content_anchor,
      icon_anchor,
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
        "Configure the open state, grouping, and contents of individual items.",
      ),
    ]),

    // --- Default -------------------------------------------------------------
    content.SectionExample(
      anchor: default_anchor,
      description: [
        content.Text(
          "Each item expands and collapses independently by default.",
        ),
      ],
      code: accordion.default_html,
      body: [default_example.view()],
    ),

    // --- Open ----------------------------------------------------------------
    content.SectionExample(
      anchor: open_anchor,
      description: [
        content.Text(
          "Use the open attribute to render an item expanded on first paint.",
        ),
      ],
      code: accordion.open_html,
      body: [open.view()],
    ),

    // --- Exclusive -----------------------------------------------------------
    content.SectionExample(
      anchor: exclusive_anchor,
      description: [
        content.Text(
          "Use a shared name attribute to make opening one item close the
          others.",
        ),
      ],
      code: accordion.exclusive_html,
      body: [exclusive.view()],
    ),

    // --- Disabled ------------------------------------------------------------
    content.SectionExample(
      anchor: disabled_anchor,
      description: [
        content.Text(
          "Use the inert attribute to disable an item, blocking interaction and
          muting it visually.",
        ),
      ],
      code: accordion.disabled_html,
      body: [disabled.view()],
    ),

    // --- Rich Content --------------------------------------------------------
    content.SectionExample(
      anchor: rich_content_anchor,
      description: [
        content.Text(
          "Paragraphs and links inside an item get sensible default styling.",
        ),
      ],
      code: accordion.rich_content_html,
      body: [rich_content.view()],
    ),

    // --- Icon ----------------------------------------------------------------
    content.SectionExample(
      anchor: icon_anchor,
      description: [
        content.Text(
          "Place an icon before the label and the trigger styles it
          automatically.",
        ),
      ],
      code: accordion.icon_html,
      body: [icon.view()],
    ),
  ])
}
