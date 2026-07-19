import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Display-Scale Headings --------------------------------------------------

/// Display heading for the top of an article / landing page.
pub fn page_title(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h1([attribute.data("slot", "page-title"), ..attributes], children)
}

/// Display heading.
pub fn h1(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h1([attribute.data("slot", "h1"), ..attributes], children)
}

/// Section heading. Uses flex so a `star()` decoration can sit inline
/// at the end.
pub fn h2(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h2([attribute.data("slot", "h2"), ..attributes], children)
}

/// Sub-section heading.
pub fn h3(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.h3([attribute.data("slot", "h3"), ..attributes], children)
}

// --- Body / Paragraph --------------------------------------------------------

/// Lead paragraph: the "lede" that introduces an article. Width-capped
/// with bottom spacing.
pub fn lede(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "lede"), ..attributes], children)
}

/// Slightly larger body copy.
pub fn body_large(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "body-large"), ..attributes], children)
}

/// The default paragraph size.
pub fn body(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "body"), ..attributes], children)
}

/// Smaller copy for hints / footnotes.
pub fn body_small(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.p([attribute.data("slot", "body-small"), ..attributes], children)
}

// --- Specialty ---------------------------------------------------------------

/// Uppercase tracked label: introduces a section, sits on top of a card,
/// etc.
pub fn eyebrow(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "eyebrow"), ..attributes], children)
}

/// Monospace text for file paths and other inline mono spans.
pub fn mono(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span([attribute.data("slot", "mono"), ..attributes], children)
}

/// Inline code identifiers (function names, props, attribute names).
/// Renders a `<code>` element tinted with the brand pink.
pub fn code(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.code([attribute.data("slot", "code"), ..attributes], children)
}

/// Small accent decoration: typically a `*` rendered in brand pink, sized
/// to sit beside an `h2`. Purely decorative, so hidden from assistive tech.
pub fn star(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.span(
    [attribute.data("slot", "star"), attribute.aria_hidden(True), ..attributes],
    children,
  )
}
