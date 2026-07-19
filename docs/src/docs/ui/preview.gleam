import docs/ui/code_block
import docs/ui/prose.{type Anchor}
import docs/ui/toggle_pill
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// Preview container for the docs' live component demos.

// --- Root --------------------------------------------------------------------

// No overflow clip: the focused code ring paints over and past the root's
// border, and at this small radius the square child corners stay visually
// inside the curve (the same trade code_block's root makes).
fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "preview"),
      attribute.class("group/preview mb-2 rounded-md"),
      attribute.class("border border-border bg-background"),
      ..attributes
    ],
    children,
  )
}

// --- Header ------------------------------------------------------------------

fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "preview-header"),
      attribute.class("py-3.5 px-5 border-b border-border"),
      ..attributes
    ],
    children,
  )
}

// --- Title -------------------------------------------------------------------

// An `h3` so examples join the page's heading outline and screen readers can
// jump between them.
fn title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h3(
    [
      attribute.data("slot", "preview-title"),
      attribute.class("text-2xs tracking-wider uppercase"),
      attribute.class("font-medium text-foreground-subtle"),
      ..attributes
    ],
    children,
  )
}

// --- Description -------------------------------------------------------------

fn description(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "preview-description"),
      attribute.class("text-sm text-muted-foreground mt-1"),
      ..attributes
    ],
    children,
  )
}

// --- Body --------------------------------------------------------------------

fn body(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "preview-body"),
      attribute.class("px-6 py-14"),
      attribute.class("flex flex-wrap items-center justify-center gap-4"),
      attribute.class("group-has-[[data-slot=preview-header]]/preview:py-9"),
      attribute.class("[--preview-glow:2%] [--preview-dot:10%]"),
      attribute.class("dark:[--preview-glow:4%] dark:[--preview-dot:6%]"),
      dot_grid(),
      ..attributes
    ],
    children,
  )
}

// Pink glow over a dot grid.
fn dot_grid() -> Attribute(message) {
  attribute.styles([
    #(
      "background",
      "radial-gradient(circle at 50% 50%, color-mix(in srgb, var(--glow-pink) var(--preview-glow), transparent), transparent 60%), "
        <> "repeating-radial-gradient(circle at 0 0, color-mix(in srgb, var(--glow-pink) var(--preview-dot), transparent) 0 1px, transparent 1px 10px)",
    ),
  ])
}

// --- Composed Previews -------------------------------------------------------

/// Header-less hero preview for the top of a page. `code` is the prerendered,
/// syntax-highlighted HTML from `docs/generated/example/<page>` (the
/// `<example>_html` constants).
pub fn with_code(
  body body_children: List(Element(message)),
  code source_html: String,
) -> Element(message) {
  root([], [
    card_layer([
      body(
        [attribute.class("relative")],
        list.append(body_children, [code_toggle()]),
      ),
    ]),
    code_section(source_html),
  ])
}

/// Titled, anchor-linked preview section with a collapsible code panel.
/// `code` is the prerendered HTML constant.
pub fn section_with_code(
  anchor anchor: Anchor,
  description description_children: List(Element(message)),
  body body_children: List(Element(message)),
  code source_html: String,
) -> Element(message) {
  root([attribute.class("mt-4")], [
    card_layer([
      header([], [
        title([attribute.id(anchor.id)], [
          prose.anchor_link(anchor, [attribute.class("underline-offset-2")]),
        ]),
        description([], description_children),
      ]),
      body(
        [attribute.class("relative")],
        list.append(body_children, [code_toggle()]),
      ),
    ]),
    code_section(source_html),
  ])
}

// Paints the card gradient behind the header/body only, never the code panel
// so expanding doesn't extend gradient.
fn card_layer(children: List(Element(message))) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "preview-card"),
      attribute.class("bg-linear-to-b from-muted/25 to-muted/5"),
    ],
    children,
  )
}

// Open-only: expanding hides this pill, so focus hands off to the sticky
// "Hide code" pill to keep keyboard users anchored.
fn code_toggle() -> Element(message) {
  toggle_pill.button(
    [
      attribute.data("slot", "code-toggle"),
      attribute.aria_expanded(False),
      attribute.class("absolute bottom-2.5 right-3 z-10 aria-expanded:hidden"),
    ],
    [html.text("Show code")],
  )
}

// Scopes the sticky bar's containing block to the code section alone, so it
// only appears once the user has scrolled into the code. The section also
// draws the focused-code ring: its transparent border rides -m-px over the
// root's border and the seam, so the recolor plus outline wrap the code
// area alone and glow past every edge. The overflow clip contains the
// block's own -m-px bleed in the root's stead; the ring, being the
// section's own border and outline, paints uncut.
fn code_section(source_html: String) -> Element(message) {
  html.div(
    [
      attribute.class("-m-px border border-transparent overflow-clip"),
      attribute.class(
        "has-[[data-slot=code-block-body]:focus-visible]:outline-2",
      ),
      attribute.class(
        "has-[[data-slot=code-block-body]:focus-visible]:outline-offset-0",
      ),
      attribute.class(
        "has-[[data-slot=code-block-body]:focus-visible]:border-outline",
      ),
    ],
    [code_panel(source_html), sticky_hide_code_button()],
  )
}

fn code_panel(source_html: String) -> Element(message) {
  html.div(
    [
      attribute.data("slot", "code-panel"),
      attribute.class("grid grid-rows-[0fr]"),
      attribute.class("transition-[grid-template-rows] duration-300 ease-out"),
      attribute.class("motion-reduce:transition-none"),
      attribute.class(
        "group-has-[[data-slot=code-toggle][aria-expanded=true]]/preview:grid-rows-[1fr]",
      ),
    ],
    [
      html.div(
        [
          attribute.data("slot", "code-panel-inner"),
          attribute.class("overflow-hidden"),
          attribute.class(
            "invisible transition-[visibility] duration-0 delay-300",
          ),
          attribute.class("motion-reduce:delay-0"),
          attribute.class(
            "group-has-[[data-slot=code-toggle][aria-expanded=true]]/preview:visible",
          ),
          attribute.class(
            "group-has-[[data-slot=code-toggle][aria-expanded=true]]/preview:delay-0",
          ),
        ],
        [
          // Strip `code_block.code`'s rounding (the section clips anyway)
          // and x/bottom borders (they would double the root's own). On
          // focus the seam border yields too, so the section's ring stands
          // alone.
          code_block.code(
            [
              attribute.class("rounded-none! border-0! border-t!"),
              attribute.class(
                "has-[[data-slot=code-block-body]:focus-visible]:border-transparent",
              ),
            ],
            source_html,
          ),
        ],
      ),
    ],
  )
}

// Sticky bar pinned to the viewport bottom while the expanded code is in
// view: `-mt-11` docks it inside the dark panel by its own height, `-mb-px`
// folds its border into the preview root's.
fn sticky_hide_code_button() -> Element(message) {
  html.div(
    [
      attribute.data("slot", "code-hide-bar"),
      attribute.class("sticky bottom-0 -mt-11 -mb-px z-10"),
      attribute.class("hidden items-center justify-end py-2.5 px-3"),
      attribute.class("pointer-events-none bg-transparent"),
      attribute.class("border-b border-border"),
      // The bar stacks above the pre, so while the code is focused its
      // border yields to the ring's bottom edge.
      attribute.class(
        "group-has-[[data-slot=code-block-body]:focus-visible]/preview:border-transparent",
      ),
      attribute.class(
        "group-has-[[data-slot=code-toggle][aria-expanded=true]]/preview:flex",
      ),
    ],
    [
      toggle_pill.button(
        [
          attribute.data("slot", "code-hide"),
          attribute.class("pointer-events-auto"),
        ],
        [html.text("Hide code")],
      ),
    ],
  )
}

// --- FFI ---------------------------------------------------------------------

/// Wire up the delegated show/hide behavior for every preview's code panel.
@external(javascript, "./preview.ffi.mjs", "init")
pub fn init() -> Nil
