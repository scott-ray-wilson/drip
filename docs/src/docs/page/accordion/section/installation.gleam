import docs/content.{type Block}
import docs/ui/installation
import docs/ui/table_of_contents.{type Entry}
import drip/registry
import lustre/element.{type Element}

// --- Table of Contents -------------------------------------------------------

pub fn table_of_contents() -> List(Entry) {
  installation.table_of_contents()
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
  content.Installation(registry.accordion)
}
