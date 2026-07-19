import docs/content.{type Block}
import docs/generated/example/table
import docs/page/table/example/caption
import docs/page/table/example/footer
import docs/page/table/example/selected
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "examples", label: "Examples")

const selected_anchor = Anchor(id: "selected", label: "Selected")

const footer_anchor = Anchor(id: "footer", label: "Footer")

const caption_anchor = Anchor(id: "caption", label: "Caption")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      selected_anchor,
      footer_anchor,
      caption_anchor,
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
        "Mark rows as selected, anchor totals in a footer, or summarize the table
        with a caption.",
      ),
    ]),

    // --- Selected ------------------------------------------------------------
    content.SectionExample(
      anchor: selected_anchor,
      description: [
        content.Text("Set data-state=\"selected\" to mark a row as selected."),
      ],
      code: table.selected_html,
      body: [selected.view()],
    ),

    // --- Footer --------------------------------------------------------------
    content.SectionExample(
      anchor: footer_anchor,
      description: [
        content.Text(
          "Add a footer to anchor totals or summary metadata beneath the body.",
        ),
      ],
      code: table.footer_html,
      body: [footer.view()],
    ),

    // --- Caption -------------------------------------------------------------
    content.SectionExample(
      anchor: caption_anchor,
      description: [
        content.Text(
          "Add a caption to summarize the table for screen readers and sighted
          users alike.",
        ),
      ],
      code: table.caption_html,
      body: [caption.view()],
    ),
  ])
}
