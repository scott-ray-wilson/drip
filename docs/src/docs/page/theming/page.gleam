import docs/content.{type Block}
import docs/generated/example/theming as example
import docs/generated/theme
import docs/route
import docs/ui/page_header
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents
import gleam/list
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/icon

// --- Page Metadata -----------------------------------------------------------

const title = "Theming"

const lede = "Every element draws its colors, corners, and type from one set of
design tokens: CSS variables you own. Change a value and every element follows,
in light and dark."

// --- Anchors -----------------------------------------------------------------

const how_anchor = Anchor(id: "how-it-works", label: "How It Works")

const tokens_anchor = Anchor(id: "tokens", label: "Tokens")

const dark_anchor = Anchor(id: "dark-mode", label: "Dark Mode")

const customize_anchor = Anchor(id: "customize", label: "Customize")

const radius_anchor = Anchor(id: "radius", label: "Radius")

const fonts_anchor = Anchor(id: "fonts", label: "Fonts")

const default_theme_anchor = Anchor(
  id: route.default_theme_id,
  label: "Default Theme",
)

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  element.fragment([
    page_header.view(
      route: route.Theming,
      eyebrow: "Documentation",
      title:,
      lede:,
      markdown: markdown(),
      prompt: "help me customize drip's theme",
    ),
    content.to_lustre(content()),
  ])
}

// --- Markdown ----------------------------------------------------------------

pub fn markdown() -> String {
  "# "
  <> title
  <> "\n\n"
  <> lede
  <> "\n\n"
  <> content.to_markdown(content())
  <> "\n"
}

// --- Table of Contents -------------------------------------------------------

pub fn table_of_contents() -> Element(message) {
  table_of_contents.view([
    table_of_contents.entry(how_anchor),
    table_of_contents.entry(tokens_anchor),
    table_of_contents.entry(dark_anchor),
    table_of_contents.entry(customize_anchor),
    table_of_contents.entry(radius_anchor),
    table_of_contents.entry(fonts_anchor),
    table_of_contents.entry(default_theme_anchor),
  ])
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  content.Group([
    // --- Preview Release -----------------------------------------------------
    content.Custom(
      view: alert.root([alert.info()], [
        alert.icon([], [icon.info([])]),
        alert.title([], [html.text("Preview Release")]),
        alert.description([], [
          html.text(
            "Token names and structure are still settling and may change before
            1.0. Pin the theme you ship on, and expect to reconcile tokens when
            you take element updates.",
          ),
        ]),
      ]),
      markdown: "> **Preview Release.** Token names and structure are "
        <> "still settling and may change before 1.0. Pin the theme you ship on, "
        <> "and expect to reconcile tokens when you take element updates.",
    ),

    // --- How It Works --------------------------------------------------------
    content.Heading(how_anchor),
    content.Paragraph([
      content.Text("Every color and radius in Drip routes through "),
      content.Code("src/ui/theme.css"),
      content.Text(
        ", the token file init writes. It is the one file you edit to reskin
        every element.",
      ),
    ]),
    content.Paragraph([
      content.Text("Each token is declared twice and mapped once:"),
    ]),
    content.CodeFile("src/ui/theme.css", example.tokens_css_html),
    content.Paragraph([
      content.Text("The "),
      content.Code(":root"),
      content.Text(" block holds the light value, the "),
      content.Code(".dark"),
      content.Text(" block the dark value, and the "),
      content.Code("@theme inline"),
      content.Text(
        " block hands the variable to Tailwind, so elements reach it as an
        ordinary utility: ",
      ),
      content.Code("bg-background"),
      content.Text(", "),
      content.Code("text-muted-foreground"),
      content.Text(", "),
      content.Code("border-border"),
      content.Text(". Because the mapping is "),
      content.Code("inline"),
      content.Text(", those utilities compile to a live "),
      content.Code("var()"),
      content.Text(
        " reference rather than a frozen value: one stylesheet serves both
        palettes, and editing a token reskins the page without a rebuild.",
      ),
    ]),
    content.Paragraph([
      content.Text(
        "Color tokens come in pairs named by role: a surface and the text that
        sits on it. ",
      ),
      content.Code("card"),
      content.Text(" is the card background, "),
      content.Code("card-foreground"),
      content.Text(
        " the text on it. Change one and check its partner still reads.",
      ),
    ]),

    // --- Tokens --------------------------------------------------------------
    content.Heading(tokens_anchor),
    content.Paragraph([
      content.Text("Every token the "),
      content.Code(":root"),
      content.Text(" block declares, grouped by role:"),
    ]),
    content.Table(headers: ["Token", "Description"], rows: [
      token_row(
        ["background", "foreground"],
        "The page surface and its default text.",
      ),
      token_row(
        ["foreground-subtle"],
        "Quieter supporting text: captions, hints, markers.",
      ),
      token_row(
        ["card", "card-foreground"],
        "Card surfaces and the text on them.",
      ),
      token_row(
        ["elevated", "elevated-foreground"],
        "Floating surfaces layered above the page.",
      ),
      token_row(
        ["muted", "muted-foreground"],
        "Tinted fills and secondary text.",
      ),
      token_row(["input"], "Form control backgrounds."),
      token_row(
        ["border", "border-strong"],
        "Hairline borders, with a heavier step for emphasis.",
      ),
      token_row(
        ["outline"],
        "The focus outline every element shares. Follows the accent until
        you set a color of its own.",
      ),
      token_row(
        ["primary", "primary-foreground"],
        "The solid call-to-action fill and its text.",
      ),
      token_row(
        ["secondary", "secondary-foreground"],
        "The quieter companion fill for secondary actions.",
      ),
      token_row(
        ["accent", "accent-foreground"],
        "The brand color and its text.",
      ),
      token_row(
        ["destructive", "destructive-foreground"],
        "Dangerous actions and their text.",
      ),
      token_row(
        [
          "primary-hover", "secondary-hover", "accent-hover", "accent-border",
          "accent-light", "destructive-hover", "destructive-border",
        ],
        "Shades mixed from the actions above; repaint a base and they follow.",
      ),
      token_row(
        ["info", "success", "warning", "error"],
        "Status colors for alerts and form validation.",
      ),
      token_row(
        ["radius"],
        "The base corner radius the whole scale derives from.",
      ),
      token_row(
        [
          "scrollbar-thumb", "scrollbar-track", "scrollbar-width",
          "scrollbar-radius",
        ],
        "The thin-scrollbar treatment scrolling elements share.",
      ),
    ]),
    content.Paragraph([
      content.Text("The derived shades are mixed from their base token with "),
      content.Code("color-mix()"),
      content.Text(
        ": repaint the base and the whole family moves with it. They are not
        mapped to utilities; elements reach them directly with ",
      ),
      content.Code("var()"),
      content.Text("."),
    ]),
    content.Paragraph([
      content.Text("Alongside the color mappings, the "),
      content.Code("@theme inline"),
      content.Text(" block extends Tailwind directly: "),
      content.Code("--ease-out-soft"),
      content.Text(", the easing curve element motion shares; "),
      content.Code("--text-2xs"),
      content.Text(", a type step below "),
      content.Code("text-xs"),
      content.Text(
        " for micro-labels; and the radius scale, which gets its own section
        below.",
      ),
    ]),

    // --- Dark Mode -----------------------------------------------------------
    content.Heading(dark_anchor),
    content.Paragraph([
      content.Text("Both palettes live in one file: the "),
      content.Code(".dark"),
      content.Text(" block re-declares each color for dark surfaces, and a "),
      content.Code("@custom-variant"),
      content.Text(" scopes Tailwind's "),
      content.Code("dark:"),
      content.Text(" variant to that class. Add "),
      content.Code("dark"),
      content.Text(
        " to the document root and every element re-resolves; remove it and
        the light values return.",
      ),
    ]),
    content.Paragraph([
      content.Text(
        "How the class gets there is up to you: this site toggles it from the
        header button and stores the choice in ",
      ),
      content.Code("localStorage"),
      content.Text(
        ". The variant follows the class rather than the OS, so honoring the
        system setting means adding the class from a ",
      ),
      content.Code("prefers-color-scheme"),
      content.Text(" listener."),
    ]),

    // --- Customize -----------------------------------------------------------
    content.Heading(customize_anchor),
    content.Paragraph([
      content.Text(
        "The theme is vendored source, so restyling is an edit, not an
        override: open the file and write new values. Repaint the accent and
        soften the corners:",
      ),
    ]),
    content.CodeFile("src/ui/theme.css", example.theme_css_html),
    content.Paragraph([
      content.Text(
        "Repainting the accent moves more than fills: the focus outline and its
        derived shades follow. Set a color in both blocks when the palettes
        differ; ",
      ),
      content.Code(".dark"),
      content.Text(" only overrides what it declares, which is why "),
      content.Code("radius"),
      content.Text(" is set once and shared."),
    ]),
    content.Paragraph([
      content.Text("New tokens slot in the same way: declare a variable in "),
      content.Code(":root"),
      content.Text(" and "),
      content.Code(".dark"),
      content.Text(", map it under "),
      content.Code("@theme inline"),
      content.Text(" as "),
      content.Code("--color-<name>"),
      content.Text(", and Tailwind mints the matching utilities: "),
      content.Code("bg-<name>"),
      content.Text(", "),
      content.Code("text-<name>"),
      content.Text(", and the rest."),
    ]),

    // --- Radius --------------------------------------------------------------
    content.Heading(radius_anchor),
    content.Paragraph([
      content.Text("Corners hang off the single "),
      content.Code("radius"),
      content.Text(" token. The theme multiplies it into a scale, "),
      content.Code("--radius-xs"),
      content.Text(" at 0.4× up through "),
      content.Code("--radius-4xl"),
      content.Text(
        " at 2.6×, and each element picks its step from that scale, so
        proportions hold at any base. The default ",
      ),
      content.Code("0.16rem"),
      content.Text(
        " keeps corners barely softened; raise it for a rounder feel, or set
        it to ",
      ),
      content.Code("0"),
      content.Text(" for sharp edges everywhere."),
    ]),

    // --- Fonts ---------------------------------------------------------------
    content.Heading(fonts_anchor),
    content.Paragraph([
      content.Text(
        "Elements never name a typeface. They set type with Tailwind's ",
      ),
      content.Code("font-sans"),
      content.Text(" and "),
      content.Code("font-mono"),
      content.Text(
        " utilities, so the faces come from Tailwind's own font tokens. Point
        those at your fonts from the entry stylesheet:",
      ),
    ]),
    content.CodeFile("src/my_app.css", example.entry_css_html),
    content.Paragraph([
      content.Text("Loading the font files is still your job: a "),
      content.Code("<link>"),
      content.Text(" tag in your HTML or an "),
      content.Code("@font-face"),
      content.Text(
        " block in the entry stylesheet, whichever fits how you ship.",
      ),
    ]),

    // --- Default Theme -------------------------------------------------------
    content.Heading(default_theme_anchor),
    content.Paragraph([
      content.Text("Past the token pairs, the file also carries the "),
      content.Code("@layer base"),
      content.Text(" defaults and the "),
      content.Code(".thin-scrollbar"),
      content.Text(
        " utility scrolling elements share. The whole theme, exactly as init
        writes it to ",
      ),
      content.Code("src/ui/theme.css"),
      content.Text(":"),
    ]),
    content.SourceFile("src/ui/theme.css", theme.source_html),
  ])
}

// --- Helpers -----------------------------------------------------------------

fn token_row(tokens: List(String), description: String) -> content.Row {
  [
    content.InlineCell(
      tokens
      |> list.map(content.Code)
      |> list.intersperse(content.Text(" ")),
    ),
    content.text_cell(description),
  ]
}
