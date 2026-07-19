import docs/content.{type Block}
import docs/route
import docs/ui/page_header
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon

// --- Page Metadata -----------------------------------------------------------

const title = "CLI"

const lede = "Commands that vendor elements into your project and keep the
stylesheet wired. No watcher, no lockfile, no magic. The CLI writes files you
can read, then gets out of the way."

// --- Anchors -----------------------------------------------------------------

const invocation_anchor = Anchor(id: "invocation", label: "Invocation")

const commands_anchor = Anchor(id: "commands", label: "Commands")

const init_anchor = Anchor(id: "init", label: "init")

const add_anchor = Anchor(id: "add", label: "add")

const list_anchor = Anchor(id: "list", label: "list")

const remove_anchor = Anchor(id: "remove", label: "remove")

const config_anchor = Anchor(id: "configuration", label: "Configuration")

const prefix_anchor = Anchor(id: "prefix", label: "prefix")

const source_anchor = Anchor(id: "source", label: "source")

const next_anchor = Anchor(id: "next-steps", label: "Next Steps")

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  element.fragment([
    page_header.view(
      route: route.Cli,
      eyebrow: "Documentation",
      title:,
      lede:,
      markdown: markdown(),
      prompt: "help me use the drip CLI",
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
    table_of_contents.entry(invocation_anchor),
    table_of_contents.group(commands_anchor, children: [
      init_anchor,
      add_anchor,
      list_anchor,
      remove_anchor,
    ]),
    table_of_contents.group(config_anchor, children: [
      prefix_anchor,
      source_anchor,
    ]),
    table_of_contents.entry(next_anchor),
  ])
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  content.Group([
    // --- Invocation ----------------------------------------------------------
    content.Heading(invocation_anchor),
    content.Paragraph([
      content.Text(
        "Adding Drip as a dev dependency brings the CLI with it, so there is
        nothing extra to install. Every command runs through ",
      ),
      content.Code("gleam"),
      content.Text(" and takes the form "),
      content.Code("gleam run -m drip -- <command>"),
      content.Text(". For example:"),
    ]),
    content.Shell("shell", "gleam run -m drip -- add button"),

    // --- Commands ------------------------------------------------------------
    content.Heading(commands_anchor),
    content.Paragraph([
      content.Text(
        "init sets up a project, add brings elements in, list shows what is
        vendored, and remove takes them out.",
      ),
    ]),

    // --- Init ----------------------------------------------------------------
    content.Subheading(init_anchor),
    content.Paragraph([
      content.Text("Prepares a project for vendoring. It writes three files:"),
    ]),
    content.BulletList([
      [
        content.Code("src/ui/theme.css"),
        content.Text(
          " holds the design tokens, every CSS variable the elements draw from.",
        ),
      ],
      [
        content.Code("src/ui/index.css"),
        content.Text(
          " imports the theme and every element stylesheet.
          add and remove regenerate this file from the elements on disk, never
          your entry.",
        ),
      ],
      [
        content.Code("src/<app>.css"),
        content.Text(
          " is your entry stylesheet, named after your package. It pulls in
          Tailwind and the index, then stays put.",
        ),
      ],
    ]),
    content.Shell("shell", "gleam run -m drip -- init"),
    content.Paragraph([content.Text("init takes three flags.")]),
    content.Table(headers: ["Flag", "Default", "Description"], rows: [
      [
        content.flag_cell("--prefix=<name>"),
        content.text_cell("ui"),
        content.text_cell(
          "Directory under src that elements vendor into, recorded in
          gleam.toml.",
        ),
      ],
      [
        content.flag_cell("--source=<url-or-path>"),
        content.nowrap_cell("latest release"),
        content.text_cell(
          "Registry to vendor from, a URL or local path, recorded in
          gleam.toml.",
        ),
      ],
      [
        content.flag_cell("--force"),
        content.text_cell("off"),
        content.text_cell("Overwrites an existing theme and index."),
      ],
    ]),
    content.Paragraph([
      content.Text("Without "),
      content.Code("--force"),
      content.Text(
        ", init refuses to overwrite an existing theme or index. An entry
        stylesheet that already exists is edited in place, so adopting Drip in
        a real app never overwrites your styles.",
      ),
    ]),

    // --- Add -----------------------------------------------------------------
    content.Subheading(add_anchor),
    content.Paragraph([
      content.Text("Vendors each element into "),
      content.Code("src/ui"),
      content.Text(
        ": the module and its stylesheet. The index is regenerated to import
        them. Dependencies resolve automatically, so ",
      ),
      content.Code("add field"),
      content.Text(" also vendors separator."),
    ]),
    content.Shell(
      "shell",
      "gleam run -m drip -- add button\n\n# several at once\n"
        <> "gleam run -m drip -- add card table radio_group",
    ),
    content.Paragraph([content.Text("add takes one flag.")]),
    content.Table(headers: ["Flag", "Default", "Description"], rows: [
      [
        content.flag_cell("--force"),
        content.text_cell("off"),
        content.text_cell(
          "Re-vendors the named elements and their dependencies, overwriting
          copies already on disk.",
        ),
      ],
    ]),
    content.Paragraph([
      content.Text(
        "By default, elements already on disk are skipped, so your edits are
        safe from accidental overwrites. Pass ",
      ),
      content.Code("--force"),
      content.Text(
        " to override this behavior and re-vendor the element and everything
        it pulls in, dependencies included, overwriting the copies on disk. That
        is how you take updates; do it on a branch and review the result with ",
      ),
      content.Code("git diff"),
      content.Text("."),
    ]),

    // --- List ----------------------------------------------------------------
    content.Subheading(list_anchor),
    content.Paragraph([
      content.Text(
        "Prints every element the registry offers and marks the ones already
        vendored, based on which element modules exist on disk. Takes no
        arguments.",
      ),
    ]),
    content.Shell("shell", "gleam run -m drip -- list"),

    // --- Remove --------------------------------------------------------------
    content.Subheading(remove_anchor),
    content.Paragraph([
      content.Text(
        "Deletes the element's module and stylesheet, then regenerates the
        index without it.",
      ),
    ]),
    content.Shell("shell", "gleam run -m drip -- remove button"),
    content.Paragraph([
      content.Text(
        "Removal never cascades: only the elements you name are deleted, since a
        dependency may still be shared by others on disk. Removing ",
      ),
      content.Code("field"),
      content.Text(" leaves separator in place; drop it too with "),
      content.Code("gleam run -m drip -- remove field separator"),
      content.Text(" once nothing else needs it."),
    ]),

    // --- Configuration -------------------------------------------------------
    content.Heading(config_anchor),
    content.Paragraph([
      content.Text(
        "Drip has two settings, prefix and source. Both live in your ",
      ),
      content.Code("gleam.toml"),
      content.Text(", in the "),
      content.Code("[tools.drip]"),
      content.Text(
        " table. init writes them when you pass the matching flags, adding
        them by hand works just as well, and most projects need neither.",
      ),
    ]),

    // --- Prefix --------------------------------------------------------------
    content.Subheading(prefix_anchor),
    content.Paragraph([
      content.Text(
        "The directory under src that elements vendor into. It defaults to ",
      ),
      content.Code("ui"),
      content.Text(":"),
    ]),
    content.Shell("gleam.toml", "[tools.drip]\nprefix = \"ui\""),
    content.Paragraph([
      content.Text(
        "Set it before your first add, since the CLI does not migrate files
        you have already vendored.",
      ),
    ]),

    // --- Source --------------------------------------------------------------
    content.Subheading(source_anchor),
    content.Paragraph([
      content.Text(
        "Where the index and element files are fetched from. It takes an
        alternate http(s) base or a local directory in the same flat layout,
        such as a registry checkout's ",
      ),
      content.Code("dist/"),
      content.Text(
        ". With no source set, Drip uses its latest GitHub release; override
        it for offline work, forks, and mirrors:",
      ),
    ]),
    content.Shell(
      "gleam.toml",
      "[tools.drip]\nsource = \"https://example.com/registry\"",
    ),

    // --- Next Steps ----------------------------------------------------------
    content.Heading(next_anchor),
    content.Paragraph([
      content.Text(
        "New to Drip? The getting started guide walks through the whole flow
        once, and the introduction covers the what and why. Otherwise the
        catalog is where you'll find what to add.",
      ),
    ]),
    // The buttons are navigation; the prose above already names where they go,
    // so they stay out of the Markdown.
    content.Custom(
      view: html.div(
        [attribute.class("flex flex-wrap items-center gap-3 mt-6")],
        [
          button.link([button.outline(), route.href(route.GettingStarted)], [
            html.text("Get Started"),
            icon.arrow_right([button.icon_end()]),
          ]),
          button.link([button.outline(), route.href(route.Introduction)], [
            icon.sparkles([button.icon_start()]),
            html.text("Read Introduction"),
          ]),
          button.link([button.outline(), route.href(route.Elements)], [
            icon.box([button.icon_start()]),
            html.text("Browse Elements"),
          ]),
        ],
      ),
      markdown: "",
    ),
  ])
}
