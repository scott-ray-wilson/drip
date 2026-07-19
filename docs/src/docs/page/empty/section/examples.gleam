import docs/content.{type Block}
import docs/generated/example/empty
import docs/page/empty/example/actions
import docs/page/empty/example/icon
import docs/page/empty/example/media
import docs/page/empty/example/rich_content
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const icon_anchor = Anchor(id: "icon", label: "Icon")

const media_anchor = Anchor(id: "media", label: "Media")

const actions_anchor = Anchor(id: "actions", label: "Actions")

const rich_content_anchor = Anchor(id: "rich-content", label: "Rich Content")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      icon_anchor,
      media_anchor,
      actions_anchor,
      rich_content_anchor,
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
        "Compose an empty state from header and content slots, varying media and
        actions to suit.",
      ),
    ]),
    // --- Icon ----------------------------------------------------------------
    content.SectionExample(
      anchor: icon_anchor,
      description: [
        content.Text(
          "Render a tinted square tile sized for a single icon child using the
          icon element.",
        ),
      ],
      code: empty.icon_html,
      body: [icon.view()],
    ),
    // --- Media ---------------------------------------------------------------
    content.SectionExample(
      anchor: media_anchor,
      description: [
        content.Text(
          "Place an image inside a media element for an avatar or illustration.",
        ),
      ],
      code: empty.media_html,
      body: [media.view()],
    ),
    // --- Actions -------------------------------------------------------------
    content.SectionExample(
      anchor: actions_anchor,
      description: [
        content.Text(
          "Drop an action into the content element to point the user at the next
          step.",
        ),
      ],
      code: empty.actions_html,
      body: [actions.view()],
    ),
    // --- Rich Content --------------------------------------------------------
    content.SectionExample(
      anchor: rich_content_anchor,
      description: [
        content.Text(
          "Stack multiple actions inside the content element and pair them with
          helper text or links.",
        ),
      ],
      code: empty.rich_content_html,
      body: [rich_content.view()],
    ),
  ])
}
