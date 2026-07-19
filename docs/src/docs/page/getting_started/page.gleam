import docs/content.{type Block}
import docs/generated/example/getting_started as example
import docs/route
import docs/ui/page_header
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/alert
import ui/button
import ui/icon

// --- Page Metadata -----------------------------------------------------------

const title = "Getting Started"

const lede = "From an empty directory to a themed, rendering element. Drip
vendors elements as source, so setup is a few files you can read rather than a
toolchain you configure."

// --- Anchors -----------------------------------------------------------------

const create_anchor = Anchor(
  id: "create-a-lustre-project",
  label: "Create a Lustre Project",
)

const install_anchor = Anchor(id: "install-drip", label: "Install Drip")

const init_anchor = Anchor(
  id: "initialize-the-project",
  label: "Initialize the Project",
)

const add_anchor = Anchor(
  id: "add-your-first-element",
  label: "Add Your First Element",
)

const render_anchor = Anchor(id: "render-it", label: "Render It")

const serve_anchor = Anchor(
  id: "start-the-dev-server",
  label: "Start the Dev Server",
)

const theme_anchor = Anchor(id: "make-it-yours", label: "Make It Yours")

const icons_anchor = Anchor(id: "icons", label: "Icons")

const manual_anchor = Anchor(id: route.manual_setup_id, label: "Manual Setup")

const next_anchor = Anchor(id: "next-steps", label: "Next Steps")

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  element.fragment([
    page_header.view(
      route: route.GettingStarted,
      eyebrow: "Documentation",
      title:,
      lede:,
      markdown: markdown(),
      prompt: "help me install drip and add my first element",
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
    table_of_contents.entry(create_anchor),
    table_of_contents.entry(install_anchor),
    table_of_contents.entry(init_anchor),
    table_of_contents.entry(add_anchor),
    table_of_contents.entry(render_anchor),
    table_of_contents.entry(serve_anchor),
    table_of_contents.entry(theme_anchor),
    table_of_contents.entry(icons_anchor),
    table_of_contents.entry(manual_anchor),
    table_of_contents.entry(next_anchor),
  ])
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  content.Group([
    // --- Preview Release -----------------------------------------------------
    content.Custom(
      view: alert.root([alert.info(), attribute.class("mb-4")], [
        alert.icon([], [icon.info([])]),
        alert.title([], [html.text("Preview Release")]),
        alert.description([], [
          html.text(
            "The elements and default theme are pre-1.0 and still settling;
            theme token names may change before then. Because elements are
            vendored as source, nothing you have already added moves under
            you.",
          ),
        ]),
      ]),
      markdown: "> **Preview Release.** The elements and default theme are "
        <> "pre-1.0 and still settling; theme token names may change before "
        <> "then. Because elements are vendored as source, nothing you have "
        <> "already added moves under you.",
    ),

    // --- Skip to Install -----------------------------------------------------
    // The alert is navigation; it just jumps ahead to the install section, so
    // it stays out of the Markdown.
    content.Custom(
      view: alert.root([alert.neutral()], [
        alert.icon([], [icon.zap([])]),
        alert.title([], [html.text("Already have a Lustre project?")]),
        alert.description([], [
          prose.arrow_link("Skip straight to installing Drip", [
            attribute.class("mt-1"),
            ..prose.anchor_href(install_anchor)
          ]),
        ]),
      ]),
      markdown: "",
    ),

    // --- Create --------------------------------------------------------------
    content.Heading(create_anchor),
    content.Paragraph([
      content.Text("Drip expects a Lustre project served by "),
      content.Code("lustre_dev_tools"),
      content.Text(". If you're starting fresh, scaffold one:"),
    ]),
    content.Shell(
      "shell",
      "gleam new my_app\ncd my_app\ngleam add lustre\n"
        <> "gleam add lustre_dev_tools --dev",
    ),

    // --- Install -------------------------------------------------------------
    content.Heading(install_anchor),
    content.Paragraph([
      content.Text(
        "Drip is a dev dependency that writes files into your project and stays
        out of your bundle.",
      ),
    ]),
    content.Shell("shell", "gleam add drip --dev"),

    // --- Init ----------------------------------------------------------------
    content.Heading(init_anchor),
    content.Paragraph([content.Text("From the project root:")]),
    content.Shell("shell", "gleam run -m drip -- init"),
    content.Paragraph([content.Text("init writes three files.")]),
    content.BulletList([
      [
        content.Code("src/ui/theme.css"),
        content.Text(
          " holds the design tokens, every CSS variable the elements draw
          from.",
        ),
      ],
      [
        content.Code("src/ui/index.css"),
        content.Text(
          " imports the theme and every element stylesheet.
          add and remove regenerate this file from the elements on disk.",
        ),
      ],
      [
        content.Code("src/my_app.css"),
        content.Text(" is the entry stylesheet, named after your package so "),
        content.Code("lustre_dev_tools"),
        content.Text(
          " discovers it. It pulls in Tailwind and the index, then stays put.",
        ),
      ],
    ]),
    content.Paragraph([
      content.Text(
        "The entry stylesheet is where the build hooks in. It stays two lines:",
      ),
    ]),
    content.CodeFile("src/my_app.css", example.entry_css_html),
    content.Paragraph([
      content.Text("The Tailwind import has to stay here: "),
      content.Code("lustre_dev_tools"),
      content.Text(
        " only looks for it in the entry stylesheet, not in the files it
        imports. If the file already exists, init adds whichever of the two
        imports is missing and leaves the rest of your styles alone.",
      ),
    ]),
    content.Paragraph([
      content.Text("Right after init the index just imports the theme:"),
    ]),
    content.CodeFile("src/ui/index.css", example.index_css_html),
    content.Paragraph([
      content.Text(
        "Drip generates this file from the elements on disk, so add and remove
        keep it in sync, one import per element. You never edit it by hand;
        your own styles belong in the entry stylesheet.",
      ),
    ]),
    content.Paragraph([
      content.Text("Pass "),
      content.Code("--prefix=<name>"),
      content.Text(
        " to vendor elements under a different directory name; init records it
        in the ",
      ),
      content.Code("[tools.drip]"),
      content.Text(" table of your "),
      content.Code("gleam.toml"),
      content.Text(" so every later command follows it."),
    ]),

    // --- Add -----------------------------------------------------------------
    content.Heading(add_anchor),
    content.Paragraph([content.Text("Vendor a button:")]),
    content.Shell("shell", "gleam run -m drip -- add button"),
    content.Paragraph([
      content.Text("The element's module and stylesheet land in "),
      content.Code("src/ui"),
      content.Text(
        ", and the index is regenerated to import the stylesheet. Dependencies
        come automatically: ",
      ),
      content.Code("add field"),
      content.Text(" brings separator with it."),
    ]),

    // --- Render --------------------------------------------------------------
    content.Heading(render_anchor),
    content.Paragraph([
      content.Text("Import the element and use it in a view."),
    ]),
    content.CodeFile("src/my_app.gleam", example.app_html),
    content.Paragraph([
      content.Text(
        "Every element renders to an ordinary Lustre element. No providers, no
        context, no wrapper to mount: your view stays a pure function of
        state.",
      ),
    ]),

    // --- Serve ---------------------------------------------------------------
    content.Heading(serve_anchor),
    content.Paragraph([
      content.Text("One command compiles and serves the app:"),
    ]),
    content.Shell("shell", "gleam run -m lustre/dev start"),
    content.Paragraph([
      content.Text(
        "Open the printed address and the button renders with its styles
        applied. There is no separate Tailwind step: ",
      ),
      content.Code("lustre_dev_tools"),
      content.Text(
        " picks up the import in the entry stylesheet and compiles the CSS as
        part of the build.",
      ),
    ]),

    // --- Theme ---------------------------------------------------------------
    content.Heading(theme_anchor),
    content.Paragraph([
      content.Text(
        "Every color, radius, and typeface the elements use routes through the
        variables in ",
      ),
      content.Code("src/ui/theme.css"),
      content.Text(
        ". Both palettes live there, light and dark. Edit the file like any
        other code you own. The theming guide walks through every token, dark
        mode, and the radius scale.",
      ),
    ]),
    // The links are navigation; the prose already names where they go, so
    // they stay out of the Markdown.
    content.Custom(
      view: html.div([attribute.class("mt-4 flex flex-wrap gap-x-6 gap-y-2")], [
        prose.arrow_link("Read the Theming Guide", [route.href(route.Theming)]),
      ]),
      markdown: "",
    ),

    // --- Icons ---------------------------------------------------------------
    content.Heading(icons_anchor),
    content.Paragraph([
      content.Text(
        "Drip ships no icon library. The examples on this site, and the few
        elements that carry an icon of their own (the accordion chevron, the
        checkbox check, and so on), all route through a single ",
      ),
      content.Code("ui/icon"),
      content.Text(" module, so their calls read "),
      content.Code("icon.arrow_right([])"),
      content.Text("."),
    ]),
    content.Paragraph([
      content.Text(
        "Recreate that module with any icon set you like: an icon is just a
        function that returns an element. The quickest route is ",
      ),
      content.Code("lucide_lustre"),
      content.Text(
        ", which ships the icons this site uses and writes the module for
        you:",
      ),
    ]),
    content.Shell(
      "shell",
      "gleam add lucide_lustre@2 --dev\n\n"
        <> "# every icon, written to src/ui/icon.gleam\n"
        <> "gleam run -m lucide_lustre/add_all ui/icon\n\n"
        <> "# or just the ones you use\n"
        <> "gleam run -m lucide_lustre/add arrow_right ui/icon",
    ),
    content.Paragraph([
      content.Text("Then "),
      content.Code("import ui/icon"),
      content.Text(" and call icons the way the examples do. "),
      content.Code("lucide_lustre"),
      content.Text(
        " draws Lucide's default stroke, a touch heavier than the one this site
        uses, so nudge ",
      ),
      content.Code("stroke-width"),
      content.Text(" if you want a pixel-perfect match."),
    ]),
    // The link is a pointer; the prose already names the package, so it stays
    // out of the Markdown.
    content.Custom(
      view: html.div([attribute.class("mt-4 flex flex-wrap gap-x-6 gap-y-2")], [
        prose.arrow_link("Browse lucide_lustre on Hex", [
          attribute.href("https://hex.pm/packages/lucide_lustre"),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
        ]),
      ]),
      markdown: "",
    ),

    // --- Manual Setup --------------------------------------------------------
    content.Heading(manual_anchor),
    content.Paragraph([
      content.Text(
        "The CLI is a convenience, not a requirement. Every element page
        prints its full source under the Manual tab of its Installation
        section, so you can vendor elements by hand and skip the dev
        dependency entirely. The scaffolding is the same three files init
        writes:",
      ),
    ]),
    content.BulletList([
      [
        content.Code("src/my_app.css"),
        content.Text(
          " is the two-line entry stylesheet shown under Initialize the
          Project, named after your package so ",
        ),
        content.Code("lustre_dev_tools"),
        content.Text(" discovers it."),
      ],
      [
        content.Code("src/ui/theme.css"),
        content.Text(
          " holds the design tokens. Copy the default theme from the theming
          guide, which prints the file in full.",
        ),
      ],
      [
        content.Code("src/ui/index.css"),
        content.Text(
          " imports the theme ahead of every element stylesheet. Without the
          CLI to regenerate it, the file is yours to maintain.",
        ),
      ],
    ]),
    content.Paragraph([
      content.Text("After vendoring a button, the index reads:"),
    ]),
    content.CodeFile("src/ui/index.css", example.manual_index_css_html),
    content.Paragraph([
      content.Text(
        "From there every element is the same two moves: drop the files from
        its Manual tab into ",
      ),
      content.Code("src/ui/"),
      content.Text(", and add the stylesheet's "),
      content.Code("@import"),
      content.Text(
        " line to the index. When an element builds on others, the Manual tab
        names them; vendor those the same way.",
      ),
    ]),
    // The link is navigation; the prose already names where it goes, so it
    // stays out of the Markdown.
    content.Custom(
      view: html.div([attribute.class("mt-4")], [
        prose.arrow_link("Copy the Default Theme", [
          route.section_href(route.Theming, route.default_theme_id),
        ]),
      ]),
      markdown: "",
    ),

    // --- Next Steps ----------------------------------------------------------
    content.Heading(next_anchor),
    content.Paragraph([
      content.Text(
        "The introduction makes the case for owning your elements; the
        catalog shows everything you can add; and the CLI reference covers
        every command.",
      ),
    ]),
    // The buttons are navigation; the prose above already names where they go,
    // so they stay out of the Markdown.
    content.Custom(view: next_links(), markdown: ""),
  ])
}

// --- Custom Blocks -----------------------------------------------------------

fn next_links() -> Element(message) {
  html.div([attribute.class("flex flex-wrap items-center gap-3 mt-6")], [
    button.link([button.outline(), route.href(route.Introduction)], [
      icon.sparkles([button.icon_start()]),
      html.text("Read Introduction"),
    ]),
    button.link([button.outline(), route.href(route.Elements)], [
      icon.box([button.icon_start()]),
      html.text("Browse Elements"),
    ]),
    button.link([button.outline(), route.href(route.Cli)], [
      icon.terminal([button.icon_start()]),
      html.text("CLI Reference"),
    ]),
  ])
}
