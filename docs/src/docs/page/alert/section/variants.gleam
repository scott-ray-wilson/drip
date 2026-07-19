import docs/content.{type Block}
import docs/generated/example/alert
import docs/page/alert/example/accent
import docs/page/alert/example/error
import docs/page/alert/example/info
import docs/page/alert/example/neutral
import docs/page/alert/example/success
import docs/page/alert/example/warning
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents.{type Entry}
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

const heading_anchor = Anchor(id: "variants", label: "Variants")

const info_anchor = Anchor(id: "info", label: "Info")

const success_anchor = Anchor(id: "success", label: "Success")

const warning_anchor = Anchor(id: "warning", label: "Warning")

const error_anchor = Anchor(id: "error", label: "Error")

const accent_anchor = Anchor(id: "accent", label: "Accent")

const neutral_anchor = Anchor(id: "neutral", label: "Neutral")

pub fn table_of_contents() -> List(Entry) {
  [
    table_of_contents.group(heading_anchor, children: [
      info_anchor,
      success_anchor,
      warning_anchor,
      error_anchor,
      accent_anchor,
      neutral_anchor,
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
        "Six semantic variants, each pairing an accent color with an icon slot to
        convey intent at a glance.",
      ),
    ]),

    // --- Info ----------------------------------------------------------------
    content.SectionExample(
      anchor: info_anchor,
      description: [
        content.Text("Informative. The lowest-urgency signal in the set."),
      ],
      code: alert.info_html,
      body: [info.view()],
    ),

    // --- Success -------------------------------------------------------------
    content.SectionExample(
      anchor: success_anchor,
      description: [
        content.Text("Affirmative. Signals that something completed."),
      ],
      code: alert.success_html,
      body: [success.view()],
    ),

    // --- Warning -------------------------------------------------------------
    content.SectionExample(
      anchor: warning_anchor,
      description: [
        content.Text(
          "Cautionary. Heightened priority, one step short of failure.",
        ),
      ],
      code: alert.warning_html,
      body: [warning.view()],
    ),

    // --- Error ---------------------------------------------------------------
    content.SectionExample(
      anchor: error_anchor,
      description: [
        content.Text("Failure. The highest-urgency signal in the set."),
      ],
      code: alert.error_html,
      body: [error.view()],
    ),

    // --- Accent --------------------------------------------------------------
    content.SectionExample(
      anchor: accent_anchor,
      description: [content.Text("Promotional. The brand-forward variant.")],
      code: alert.accent_html,
      body: [accent.view()],
    ),

    // --- Neutral -------------------------------------------------------------
    content.SectionExample(
      anchor: neutral_anchor,
      description: [
        content.Text("Subdued. Carries a message without coloring its intent."),
      ],
      code: alert.neutral_html,
      body: [neutral.view()],
    ),
  ])
}
