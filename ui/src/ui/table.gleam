import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

// --- Elements ----------------------------------------------------------------

/// Table wrapped in a horizontally scrollable container. Pair with the
/// sibling `header`, `body`, `footer`, `row`, `head`, `cell`, and `caption`
/// elements to compose a table.
pub fn root(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.div([attribute.data("slot", "table-container")], [
    html.table([attribute.data("slot", "table"), ..attributes], children),
  ])
}

/// Table header region grouping one or more header rows.
pub fn header(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.thead([attribute.data("slot", "table-header"), ..attributes], children)
}

/// Table body region grouping the data rows.
pub fn body(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.tbody([attribute.data("slot", "table-body"), ..attributes], children)
}

/// Table footer region, typically holding totals or summary rows.
pub fn footer(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.tfoot([attribute.data("slot", "table-footer"), ..attributes], children)
}

/// Table row. Add `attribute.data("state", "selected")` to mark a row as
/// selected.
pub fn row(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.tr([attribute.data("slot", "table-row"), ..attributes], children)
}

/// Header cell rendered inside a `header` row.
pub fn head(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.th([attribute.data("slot", "table-head"), ..attributes], children)
}

/// Body cell rendered inside a `body` or `footer` row.
pub fn cell(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.td([attribute.data("slot", "table-cell"), ..attributes], children)
}

/// Caption summarizing the table. Place it as the table's first child; it
/// renders beneath the table.
pub fn caption(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  html.caption(
    [attribute.data("slot", "table-caption"), ..attributes],
    children,
  )
}
