import docs/content.{type Block}
import docs/generated/example/card
import docs/page/card/example/action
import docs/page/card/example/eyebrow
import docs/page/card/example/footer
import docs/page/card/example/form
import docs/page/card/example/image
import docs/page/card/example/sizes
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const image_anchor = Anchor(id: "image", label: "Image")

const eyebrow_anchor = Anchor(id: "eyebrow", label: "Eyebrow")

const action_anchor = Anchor(id: "action", label: "Action")

const footer_anchor = Anchor(id: "footer", label: "Footer")

const sizes_anchor = Anchor(id: "sizes", label: "Sizes")

const form_anchor = Anchor(id: "form", label: "Form")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      image_anchor,
      eyebrow_anchor,
      action_anchor,
      footer_anchor,
      sizes_anchor,
      form_anchor,
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
        "Extend a card with an image, eyebrow, action, or footer, size it for
        dense or hero layouts, or compose a form.",
      ),
    ]),

    // --- Image ---------------------------------------------------------------
    content.SectionExample(
      anchor: image_anchor,
      description: [
        content.Text(
          "Set an image as the card's first or last child to render it
          edge-to-edge, flush with the card's corners.",
        ),
      ],
      code: card.image_html,
      body: [image.view()],
    ),

    // --- Eyebrow -------------------------------------------------------------
    content.SectionExample(
      anchor: eyebrow_anchor,
      description: [
        content.Text(
          "Add an eyebrow above the title to categorize the card or signal
          context.",
        ),
      ],
      code: card.eyebrow_html,
      body: [eyebrow.view()],
    ),

    // --- Action --------------------------------------------------------------
    content.SectionExample(
      anchor: action_anchor,
      description: [
        content.Text(
          "Anchor a control to the top-right of the header with the action
          slot.",
        ),
      ],
      code: card.action_html,
      body: [action.view()],
    ),

    // --- Footer --------------------------------------------------------------
    content.SectionExample(
      anchor: footer_anchor,
      description: [
        content.Text(
          "Add a footer flush against the bottom edge, with a muted tint and a
          dividing top border.",
        ),
      ],
      code: card.footer_html,
      body: [footer.view()],
    ),

    // --- Sizes ---------------------------------------------------------------
    content.SectionExample(
      anchor: sizes_anchor,
      description: [
        content.Text(
          "Size a card to fit dense lists, standard layouts, or hero blocks
          using the size attributes.",
        ),
      ],
      code: card.sizes_html,
      body: [sizes.view()],
    ),

    // --- Form ----------------------------------------------------------------
    content.SectionExample(
      anchor: form_anchor,
      description: [
        content.Text(
          "Compose the header, content, and footer with field and input elements
          to build a self-contained form.",
        ),
      ],
      code: card.form_html,
      body: [form.view()],
    ),
  ])
}
