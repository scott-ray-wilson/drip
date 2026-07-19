import docs/content.{type Block}
import docs/generated/example/alert
import docs/page/alert/example/actions
import docs/page/alert/example/banner
import docs/page/alert/example/dismissible
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const actions_anchor = Anchor(id: "actions", label: "Actions")

const dismissible_anchor = Anchor(id: "dismissible", label: "Dismissible")

const banner_anchor = Anchor(id: "banner", label: "Banner")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      actions_anchor,
      dismissible_anchor,
      banner_anchor,
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
        "Extend an alert with inline actions, a close button, or a full-width
        banner.",
      ),
    ]),

    // --- Actions -------------------------------------------------------------
    content.SectionExample(
      anchor: actions_anchor,
      description: [
        content.Text(
          "Anchor inline buttons under the description with the actions slot.",
        ),
      ],
      code: alert.actions_html,
      body: [actions.view()],
    ),

    // --- Dismissible ---------------------------------------------------------
    content.SectionExample(
      anchor: dismissible_anchor,
      description: [content.Text("Add a close button via the close slot.")],
      code: alert.dismissible_html,
      body: [dismissible.view()],
    ),

    // --- Banner --------------------------------------------------------------
    content.SectionExample(
      anchor: banner_anchor,
      description: [
        content.Text("Use the banner attribute for app-level system messages."),
      ],
      code: alert.banner_html,
      body: [banner.view()],
    ),
  ])
}
