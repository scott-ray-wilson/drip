import docs/ui/syntax_highlight
import docs/ui/toggle_pill
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/icon

// Dark, syntax-highlighted code surfaces in four variants (`code`, `shell`,
// `toml`, `file`) sharing one root/bar/body-cell skeleton.

// --- Variants ----------------------------------------------------------------

/// Plain block of prerendered, syntax-highlighted HTML plus an overlay
/// copy button.
pub fn code(
  attributes: List(Attribute(message)),
  source_html: String,
) -> Element(message) {
  root(attributes, [body_cell(prerendered(source_html), None, True)])
}

/// Filename header plus a body highlighted at render time: shell snippets can
/// be assembled dynamically (`gleam run … add <names>`).
pub fn shell(filename: String, source: String) -> Element(message) {
  root([], [
    bar([], [filename_label(filename)]),
    body_cell([html.code([], syntax_highlight.shell(source))], None, True),
  ])
}

/// Filename header plus a body highlighted at render time as TOML;
/// `gleam.toml` snippets are authored inline in page modules rather than
/// prerendered.
pub fn toml(filename: String, source: String) -> Element(message) {
  root([], [
    bar([], [filename_label(filename)]),
    body_cell([html.code([], syntax_highlight.toml(source))], None, True),
  ])
}

/// Tabbed multi-file block: each entry is `(filename, prerendered_html)` and
/// the first tab starts active. A single entry renders a static filename bar
/// instead of a one-tab tablist, so keyboard users never land on a tab that
/// switches nothing. `expand: True` starts the block collapsed behind an
/// "Expand code" pill.
pub fn file(
  files: List(#(String, String)),
  expand expand: Bool,
) -> Element(message) {
  let #(root_attributes, extras) = case expand {
    False -> #([], [])
    True -> #([attribute.data("expanded", "false")], [
      // --- Fade Overlay ---
      html.div(
        [
          attribute.data("slot", "code-block-fade"),
          attribute.class("absolute inset-x-0 bottom-0 h-32 z-0"),
          attribute.class("pointer-events-none"),
          attribute.class(
            "bg-linear-to-t from-card/80 via-card/40 to-transparent",
          ),
          attribute.class("transition-opacity duration-300"),
          attribute.class("group-data-[expanded=true]/code-block:opacity-0"),
        ],
        [],
      ),

      // --- Expand Button ---
      // Open-only: expanding hides this pill, so focus hands off to the sticky
      // collapse pill to keep keyboard users anchored.
      toggle_pill.button(
        [
          attribute.data("slot", "expand-toggle"),
          attribute.class("absolute bottom-2.5 right-3 z-10"),
          attribute.class("group-data-[expanded=true]/code-block:hidden"),
        ],
        [html.text("Expand code")],
      ),

      // --- Collapse Button ---
      // Sticky bar pinned to the viewport bottom while the expanded block is in
      // view: `-mt-10` docks it against the block's bottom edge by its own height,
      // `-mb-px` folds its border into the root's.
      html.div(
        [
          attribute.data("slot", "code-block-collapse-bar"),
          attribute.class("sticky bottom-0 -mt-10 -mb-px z-10"),
          attribute.class("hidden items-center justify-end py-2.5 px-3"),
          attribute.class("pointer-events-none bg-transparent"),
          attribute.class("border-b border-border"),
          attribute.class("group-data-[expanded=true]/code-block:flex"),
        ],
        [
          toggle_pill.button(
            [
              attribute.data("slot", "collapse-toggle"),
              attribute.class("pointer-events-auto"),
            ],
            [html.text("Collapse code")],
          ),
        ],
      ),
    ])
  }
  case files {
    [#(name, html_source)] ->
      root(root_attributes, [
        bar([], [filename_label(name)]),
        panel_region([body_cell(prerendered(html_source), None, True), ..extras]),
      ])
    _ -> {
      let tab_buttons =
        list.index_map(files, fn(pair, i) { tab_button(pair.0, i) })
      let bodies =
        list.index_map(files, fn(pair, i) {
          let #(name, html_source) = pair
          body_cell(prerendered(html_source), Some(#(name, i)), i == 0)
        })
      root(root_attributes, [
        tab_bar(tab_buttons),
        panel_region(list.append(bodies, extras)),
      ])
    }
  }
}

// --- Root --------------------------------------------------------------------

// Shared root; the literal `dark` class keeps the surface dark in both
// themes. No overflow clip: it would cut the tab focus rings at the flush
// edges, and at this small radius the square child corners stay visually
// inside the border curve. The sibling `mt-6` variants match prose's `mb-6`
// for whatever follows the block, keyed on adjacency so heading-to-content
// hugs stay tight.
fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "code-block"),
      attribute.class("dark group/code-block rounded-md bg-background"),
      attribute.class("border border-border"),
      attribute.class("[&+[data-slot=body]]:mt-6"),
      attribute.class("[&+[data-slot=table-container]]:mt-6"),
      ..attributes
    ],
    children,
  )
}

// --- Filename / Tab Bar ------------------------------------------------------

fn bar(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "code-block-bar"),
      attribute.class("flex items-stretch border-b border-border bg-muted/30"),
      ..attributes
    ],
    children,
  )
}

fn filename_label(name: String) -> Element(message) {
  html.span(
    [
      attribute.data("slot", "code-block-filename"),
      attribute.class("pl-4 pr-2 py-2 select-none"),
      attribute.class("font-mono text-[12px] tracking-[0.04em]"),
      attribute.class("text-muted-foreground"),
    ],
    [html.text(name)],
  )
}

// --- Body Cell ---------------------------------------------------------------

// One `<pre>` surface plus its overlay copy button.
fn body_cell(
  code: List(Element(message)),
  tab: Option(#(String, Int)),
  active: Bool,
) -> Element(message) {
  let attrs = case tab {
    None -> [attribute.data("slot", "code-block-cell")]
    Some(#(name, index)) -> {
      let tagged = [
        attribute.data("slot", "code-block-panel"),
        attribute.data("tab", int.to_string(index)),
        attribute.attribute("role", "tabpanel"),
        attribute.aria_label(name),
      ]
      case active {
        True -> tagged
        False -> [
          attribute.attribute("hidden", ""),
          attribute.attribute("inert", ""),
          ..tagged
        ]
      }
    }
  }
  html.div([attribute.class("relative"), ..attrs], [
    // The pre is the single tab stop: focus on the scroller keeps
    // arrow-key scrolling and avoids the second implicit stop browsers
    // give scrollable regions. Its transparent border rides -m-px over
    // the surrounding chrome, so the focus border recolors the block
    // edge while the resting surface stays flush.
    html.pre(
      [
        attribute.data("slot", "code-block-body"),
        attribute.attribute("tabindex", "0"),
        attribute.class("thin-scrollbar -m-px border border-transparent"),
        attribute.class("focus-visible:outline-2"),
        attribute.class("focus-visible:outline-offset-0"),
        attribute.class("focus-visible:border-outline!"),
        // Inside a preview the section draws the ring; standing down here
        // keeps the seam from doubling.
        attribute.class(
          "[[data-slot=code-panel]_&]:focus-visible:border-transparent!",
        ),
        attribute.class("px-6 py-5"),
        attribute.class("font-mono text-[13px] leading-[22px]"),
        attribute.class("tracking-[0.04em] text-foreground bg-muted/30"),
        attribute.class("overflow-x-auto overflow-y-hidden"),
        attribute.class("[interpolate-size:allow-keywords]"),
        attribute.class("transition-[max-height] duration-300"),
        attribute.class("ease-out-soft motion-reduce:transition-none"),
        attribute.class("group-data-[expanded=false]/code-block:max-h-72"),
        attribute.class("group-data-[expanded=true]/code-block:max-h-max"),
        // Pink glow over a neutral dot grid. An inline style keeps the gradient stack
        // readable; only dark values exist because the root is always `dark`.
        attribute.styles([
          #(
            "background-image",
            "radial-gradient(ellipse 100% 50% at 55% top, rgba(255, 175, 243, 0.055), transparent 60%), "
              <> "radial-gradient(ellipse 85% 45% at 40% bottom, rgba(255, 175, 243, 0.045), transparent 65%), "
              <> "radial-gradient(circle, rgba(255, 255, 255, 0.2) 0.5px, transparent 1px)",
          ),
          #("background-size", "auto, auto, 20px 20px"),
        ]),
      ],
      code,
    ),

    // --- Copy Button ---
    // Invisible while a wrapping preview keeps its code panel collapsed; the
    // `code-toggle` contract lives in `preview.gleam`.
    button.button(
      [
        button.ghost(),
        button.icon_only(),
        button.sm(),
        attribute.aria_label("Copy code"),
        attribute.class("group/copy absolute top-2 right-2 z-10"),
        attribute.class("text-foreground-subtle"),
        attribute.class(
          "[[data-slot=preview]:has([data-slot=code-toggle][aria-expanded=false])_&]:invisible",
        ),
        // FFI hook: a second data-slot would lose to the wrapped button's own.
        attribute.data("copy-button", ""),
      ],
      [
        icon.copy([attribute.class("group-data-[copied=true]/copy:hidden")]),
        icon.check([
          attribute.class("hidden group-data-[copied=true]/copy:block"),
        ]),
      ],
    ),
  ])
}

// Prerendered by codegen's `highlight` module; injected raw so no per-render
// tokenization happens.
fn prerendered(source_html: String) -> List(Element(message)) {
  [element.unsafe_raw_html("", "code", [], source_html)]
}

// --- Panels / Tabs -----------------------------------------------------------

// The expand affordances attach here rather than the outer chrome so the
// sticky pill's containing block is the panel region alone.
fn panel_region(children: List(Element(message))) -> Element(message) {
  html.div(
    [attribute.data("slot", "code-block-panels"), attribute.class("relative")],
    children,
  )
}

// Keyboard navigation and tab activation live in `code_block.ffi.mjs`.
fn tab_bar(tab_buttons: List(Element(message))) -> Element(message) {
  bar([attribute.attribute("role", "tablist")], tab_buttons)
}

// Roving tabindex per the ARIA tabs pattern: one tab sits in the Tab order,
// initially the active one and thereafter the last focused. The FFI's keydown
// moves focus without selecting; Enter or Space activates.
fn tab_button(name: String, index: Int) -> Element(message) {
  let #(selected, tab_index) = case index {
    0 -> #("true", "0")
    _ -> #("false", "-1")
  }
  html.button(
    [
      attribute.type_("button"),
      attribute.attribute("role", "tab"),
      attribute.attribute("aria-selected", selected),
      attribute.attribute("tabindex", tab_index),
      attribute.data("slot", "code-block-tab"),
      attribute.data("tab", int.to_string(index)),
      attribute.class("px-4 py-2 cursor-pointer bg-transparent select-none"),
      attribute.class("font-mono text-xs tracking-wide"),
      attribute.class("border-r border-r-border"),
      attribute.class("text-muted-foreground transition-colors"),
      attribute.class("hover:text-foreground"),
      // Button's focus recipe. The padding shaves absorb the focus border so
      // nothing shifts; the root deliberately has no overflow clip, so the
      // ring renders whole at the flush top and left edges.
      attribute.class("focus-visible:outline-2 focus-visible:outline-offset-0"),
      attribute.class("focus-visible:border focus-visible:border-outline!"),
      attribute.class("focus-visible:pl-[15px] focus-visible:py-[7px]"),
      attribute.class("aria-selected:bg-muted/20"),
      attribute.class("aria-selected:text-foreground"),
    ],
    [html.text(name)],
  )
}

// --- FFI ---------------------------------------------------------------------

/// Wire up the delegated behaviors shared by every block: tab switching,
/// copy-to-clipboard, and the expand/collapse focus handoff.
@external(javascript, "./code_block.ffi.mjs", "init")
pub fn init() -> Nil
