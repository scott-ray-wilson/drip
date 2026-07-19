import docs/content.{type Block, type Inline}
import docs/generated/example/introduction as example
import docs/route.{type Route}
import docs/ui/code_block
import docs/ui/page_header
import docs/ui/prose.{Anchor}
import docs/ui/table_of_contents
import drip/registry
import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/accordion
import ui/button
import ui/card
import ui/icon
import ui/icon_tile
import ui/typography

// --- Page Metadata -----------------------------------------------------------

const title = "Introduction"

const lede = "Elements for Lustre that land in your project as source. Built on
native HTML, accessible by default, themeable through CSS variables, and yours
to edit. Add what you need and ship."

const quick_start_blurb = "Get your environment configured in seconds. One
package, one import. No toolchain dance, no surprises."

const install_commands = "# install drip as a dev dependency
gleam add drip --dev

# scaffold the stylesheets
gleam run -m drip -- init

# add elements
gleam run -m drip -- add button"

const footer_note = "The own-your-source approach follows the trail shadcn/ui
blazed. Lustre and Gleam make the rest possible."

// --- Anchors -----------------------------------------------------------------

const philosophy_anchor = Anchor(id: "why-source", label: "Why Source")

const composition_anchor = Anchor(id: "one-api-shape", label: "One API Shape")

const how_it_works_anchor = Anchor(id: "how-it-works", label: "How It Works")

const whats_included_anchor = Anchor(
  id: "whats-included",
  label: "What's Included",
)

const design_language_anchor = Anchor(
  id: "design-language",
  label: "Design Language",
)

const faq_anchor = Anchor(id: "faq", label: "FAQ")

const next_anchor = Anchor(id: "next-steps", label: "Next Steps")

// --- View --------------------------------------------------------------------

pub fn view() -> Element(message) {
  element.fragment([
    page_header.view(
      route: route.Introduction,
      eyebrow: "Documentation",
      title:,
      lede:,
      markdown: markdown(),
      prompt: "help me understand what drip is and how it works",
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
    table_of_contents.entry(philosophy_anchor),
    table_of_contents.entry(composition_anchor),
    table_of_contents.entry(how_it_works_anchor),
    table_of_contents.entry(whats_included_anchor),
    table_of_contents.entry(design_language_anchor),
    table_of_contents.entry(faq_anchor),
    table_of_contents.entry(next_anchor),
  ])
}

// --- Content -----------------------------------------------------------------

fn content() -> Block(message) {
  let count =
    registry.all
    |> list.length
    |> int.to_string

  content.Group([
    hero_section(),

    // --- Philosophy ----------------------------------------------------------
    content.Heading(philosophy_anchor),
    content.Paragraph([
      content.Text(
        "Most component libraries arrive as a dependency, someone else's API
        wrapped around someone else's markup, with a theming layer to bridge
        the gaps. It works until the design asks for something the API never
        anticipated. Then come the wrapper components, the style overrides,
        and the evenings spent reading source you can't change.",
      ),
    ]),
    content.Paragraph([
      content.Text("Drip takes the other road. "),
      content.Code("drip add"),
      content.Text(
        " copies an element's source into your project, where it compiles
        alongside the code you wrote. Restyle it, extend it, rip half of it
        out. There is no version to pin and nothing to fork. The element in
        your tree is already the fork.",
      ),
    ]),
    content.Paragraph([
      content.Text(
        "The trade is deliberate. You give up automatic updates and gain a
        UI layer with no black boxes in it. The FAQ below covers taking
        updates on your terms.",
      ),
    ]),

    // --- Composition ---------------------------------------------------------
    content.Heading(composition_anchor),
    content.Paragraph([
      content.Text(
        "Every element uses the same grammar. A root function renders
        the markup, and typed attribute functions set variants, sizes, and
        states. Learn it once and you have learned the library. The same ",
      ),
      content.Code("outline()"),
      content.Text(
        " you reach for on a button works on an accordion, and a misspelled
        variant is a compile error, not a silent default.",
      ),
    ]),
    content.CodeFile("app.gleam", example.composition_html),
    content.Paragraph([
      content.Text(
        "Composite elements keep the grammar. The accordion above is ",
      ),
      content.Code("accordion.root"),
      content.Text(" wrapping "),
      content.Code("accordion.item"),
      content.Text(", "),
      content.Code("accordion.trigger"),
      content.Text(", and "),
      content.Code("accordion.content"),
      content.Text(
        ". They are named parts you compose, not a config record you fill in.",
      ),
    ]),

    // --- How It Works --------------------------------------------------------
    content.Heading(how_it_works_anchor),
    content.Paragraph([
      content.Text(
        "Underneath the CLI sits a registry, one catalog declaring every
        element's source files and the elements and packages it depends on. ",
      ),
      content.Code("gleam run -m drip -- add field"),
      content.Text(" resolves that graph and vendors the closure into "),
      content.Code("src/ui"),
      content.Text(", including the separator the field leans on."),
    ]),
    content.Paragraph([
      content.Text(
        "An element is a Gleam module and a stylesheet, nothing else. Styles
        are Tailwind utilities reading the theme's tokens, so a vendored
        element matches your theme the moment it lands, and at runtime
        everything renders to plain Lustre elements. Your view stays a pure
        function of state.",
      ),
    ]),
    section_link(route.Cli, "Read the CLI reference"),

    // --- What's Included -----------------------------------------------------
    content.Heading(whats_included_anchor),
    content.Paragraph([
      content.Text(
        count <> " elements and counting: buttons and cards, fields and the form
        scaffolding around them, tables and accordions, down to the empty,
        pending, and error states. Each is typed Gleam over native HTML, an
        ordinary Lustre element that drops into any view.",
      ),
    ]),
    section_link(route.Elements, "Browse the catalog"),

    // --- Design Language -----------------------------------------------------
    content.Heading(design_language_anchor),
    content.Paragraph([
      content.Text(
        "It's tokens all the way down. Every color, radius, and typeface
        routes through CSS variables in ",
      ),
      content.Code("theme.css"),
      content.Text(
        ", and Tailwind reads the same set, so one change re-skins every
        element at once. On top of that we ship a deliberate default: sharp,
        near-square radii, hairline borders, mono details, a single brand pink,
        light and dark as equals. Opinionated, never mandatory; if it is not
        your product, retheme it until it is.",
      ),
    ]),
    section_link(route.Theming, "Read the Theming Guide"),

    // --- FAQ -----------------------------------------------------------------
    content.Heading(faq_anchor),
    content.Custom(view: faq_accordion(), markdown: faq_markdown()),

    // --- Next Steps ----------------------------------------------------------
    content.Heading(next_anchor),
    // The buttons are navigation; no need to include in markdown.
    content.Custom(view: footer_actions(), markdown: ""),
    content.Custom(
      view: typography.body_small([attribute.class("mt-10")], [
        html.text(footer_note),
      ]),
      markdown: footer_note,
    ),
  ])
}

// --- Hero --------------------------------------------------------------------

// only including quick start content in markdown as the other cards are
// just highlights of the below sections

fn hero_section() -> Block(message) {
  content.Custom(
    view: element.fragment([
      hero_actions(),
      html.div(
        [attribute.class("grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-4 mt-6")],
        [quick_start_card(), theme_card()],
      ),
      html.div([attribute.class("grid grid-cols-1 lg:grid-cols-2 gap-4 mt-4")], [
        source_code_card(),
        accessibility_card(),
      ]),
    ]),
    markdown: quick_start_blurb <> "\n\n```sh\n" <> install_commands <> "\n```",
  )
}

fn hero_actions() -> Element(message) {
  html.div([attribute.class("flex flex-wrap items-center gap-3")], [
    button.link(
      [
        button.accent(),
        button.lg(),
        route.href(route.GettingStarted),
      ],
      [
        html.text("Get Started"),
        icon.arrow_right([button.icon_end()]),
      ],
    ),
    button.link(
      [
        button.outline(),
        button.lg(),
        attribute.href("https://github.com/scott-ray-wilson/drip"),
        attribute.target("_blank"),
        attribute.rel("noopener noreferrer"),
      ],
      [
        icon.github([button.icon_start()]),
        html.text("View on GitHub"),
      ],
    ),
    html.span([attribute.class("inline-flex items-center gap-2 ml-2")], [
      html.span(
        [
          attribute.class("inline-block w-1.5 h-1.5 rounded-full bg-info"),
        ],
        [],
      ),
      html.span([attribute.class("text-xs text-muted-foreground")], [
        html.text("Preview Release"),
      ]),
    ]),
  ])
}

fn quick_start_card() -> Element(message) {
  card.root(
    [
      card.lg(),
      attribute.class("bg-[var(--glass-bg)]! border-[var(--glass-border)]!"),
      attribute.class("shadow-[var(--glass-shadow)]! backdrop-blur-md"),
    ],
    [
      card.header([], [
        icon_tile.root([icon_tile.accent(), icon_tile.lg()], [icon.rocket([])]),
        card.title([], [html.text("Quick Start")]),
        card.description([], [html.text(quick_start_blurb)]),
      ]),
      card.content([], [code_block.shell("shell", install_commands)]),
    ],
  )
}

fn theme_card() -> Element(message) {
  card.root(
    [
      card.lg(),
      attribute.data("variant", "glass-pink"),
      attribute.class("backdrop-blur-md [background:var(--glass-pink-bg)]!"),
      attribute.class(
        "border-[var(--glass-pink-border)]! shadow-[var(--glass-shadow)]!",
      ),
    ],
    [
      card.header([], [
        icon_tile.root([icon_tile.accent(), icon_tile.lg()], [icon.palette([])]),
        card.title([], [html.text("Customizable Themes")]),
        card.description([], [
          html.text(
            "Every element draws from one set of CSS variables, so the whole
            system changes from a single file. Recolor the palette, dial in
            radii and typography, and swap dark for light without touching an
            element. Edit the tokens like any other code you own.",
          ),
        ]),
      ]),
      card.content([attribute.class("mt-auto")], [
        prose.arrow_link("Read the Theming Guide", [
          attribute.data("slot", "card-link"),
          route.href(route.Theming),
        ]),
      ]),
    ],
  )
}

fn source_code_card() -> Element(message) {
  card.root(
    [
      card.lg(),
      attribute.class(
        "min-w-0 bg-[var(--glass-bg)]! border-[var(--glass-border)]!",
      ),
      attribute.class("shadow-[var(--glass-shadow)]! backdrop-blur-md"),
    ],
    [
      card.header([], [
        icon_tile.root([icon_tile.info(), icon_tile.lg()], [
          icon.package_open([]),
        ]),
        card.title([], [html.text("Own Your Elements")]),
        card.description([], [
          html.text(
            "Drip adds real source code into your project, not a black-box
            dependency. Read it, edit it, delete half of it. The elements are
            yours to keep.",
          ),
        ]),
      ]),
    ],
  )
}

fn accessibility_card() -> Element(message) {
  card.root(
    [
      card.lg(),
      attribute.class(
        "min-w-0 bg-[var(--glass-bg)]! border-[var(--glass-border)]!",
      ),
      attribute.class("shadow-[var(--glass-shadow)]! backdrop-blur-md"),
    ],
    [
      card.header([], [
        icon_tile.root([icon_tile.success(), icon_tile.lg()], [
          icon.person_standing([]),
        ]),
        card.title([], [html.text("Accessible by Default")]),
        card.description([], [
          html.text(
            "Composed from semantic HTML. Keyboard navigation and screen-reader
            support are part of every element, not an afterthought.",
          ),
        ]),
      ]),
    ],
  )
}

// --- FAQ ---------------------------------------------------------------------

fn faq_items() -> List(#(String, List(Inline))) {
  [
    #("Why copy source code?", [
      content.Text(
        "Because UI is where requirements get specific. A package can only
        expose what its API anticipated; source code can become anything your
        design needs. Owning the element means any change is one edit away,
        and a dependency bump can never restyle your product overnight.",
      ),
    ]),
    #("How do I get updates?", [
      content.Text("On your terms. On a branch, re-run "),
      content.Code("drip add"),
      content.Text(" with the "),
      content.Code("--force"),
      content.Text(
        " flag to overwrite an element with a fresh copy, then read the diff
        and keep what you like. Elements are deliberately small, one module
        and one stylesheet, so reviewing what changed takes minutes. Nothing
        updates unless you ask.",
      ),
    ]),
    #("What do I need to use it?", [
      content.Text(
        "A Lustre project with Tailwind v4 in the build. Elements are plain
        Gleam and CSS. Drip itself is a dev dependency: it writes files and
        never ships in your bundle.",
      ),
    ]),
    #("Do I have to take the whole kit?", [
      content.Text(
        "No. Add elements one at a time; each pulls in only what it actually
        depends on. When you change your mind, ",
      ),
      content.Code("drip remove"),
      content.Text(" deletes an element as cleanly as "),
      content.Code("drip add"),
      content.Text(" vendored it."),
    ]),
    #("Is it production ready?", [
      content.Text(
        "The CLI is stable, but the elements and default theme are pre-1.0:
        the catalog is still filling out, elements are being hardened, and
        theme token names may change before then. Because elements are
        vendored as source, nothing you have already added changes under you;
        you take updates deliberately by re-adding an element with ",
      ),
      content.Code("--force"),
      content.Text("."),
    ]),
    #("Can I use it in commercial work?", [
      content.Text(
        "Yes. Drip is MIT licensed: the elements, the CLI, and these docs.
        Once an element is vendored it is simply part of your codebase.",
      ),
    ]),
  ]
}

fn faq_accordion() -> Element(message) {
  accordion.root(
    [accordion.ghost()],
    list.map(faq_items(), fn(item) {
      let #(question, answer) = item
      accordion.item([attribute.name("faq")], [
        accordion.trigger([], [html.h3([], [html.text(question)])]),
        accordion.content([], [
          html.p(
            [attribute.class("text-muted-foreground")],
            content.inlines_to_lustre(answer),
          ),
        ]),
      ])
    }),
  )
}

fn faq_markdown() -> String {
  faq_items()
  |> list.map(fn(item) {
    let #(question, answer) = item
    "### "
    <> question
    <> "\n\n"
    <> content.to_markdown(content.Paragraph(answer))
  })
  |> string.join("\n\n")
}

// --- Footer ------------------------------------------------------------------

fn footer_actions() -> Element(message) {
  html.div([attribute.class("flex flex-wrap items-center gap-3 mt-2")], [
    button.link([button.outline(), route.href(route.GettingStarted)], [
      html.text("Get Started"),
      icon.arrow_right([button.icon_end()]),
    ]),
    button.link([button.outline(), route.href(route.Elements)], [
      icon.box([button.icon_start()]),
      html.text("Browse Elements"),
    ]),
  ])
}

// --- Section Helpers ---------------------------------------------------------

fn section_link(target: Route, label: String) -> Block(message) {
  content.Custom(
    prose.arrow_link(label, [route.href(target)]),
    // no need to render markdown links
    markdown: "",
  )
}
