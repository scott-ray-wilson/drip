import docs/element_page.{type ElementPage, ElementPage, Section}
import docs/page/button/section/accessibility
import docs/page/button/section/api_reference
import docs/page/button/section/as_a_link
import docs/page/button/section/examples
import docs/page/button/section/installation
import docs/page/button/section/introduction
import docs/page/button/section/usage
import docs/page/button/section/variants
import drip/registry

// --- Page --------------------------------------------------------------------

pub fn page() -> ElementPage(message) {
  ElementPage(element: registry.button, sections: [
    Section(
      introduction.table_of_contents,
      introduction.view,
      introduction.markdown,
    ),
    Section(
      installation.table_of_contents,
      installation.view,
      installation.markdown,
    ),
    Section(usage.table_of_contents, usage.view, usage.markdown),
    Section(variants.table_of_contents, variants.view, variants.markdown),
    Section(examples.table_of_contents, examples.view, examples.markdown),
    Section(as_a_link.table_of_contents, as_a_link.view, as_a_link.markdown),
    Section(
      api_reference.table_of_contents,
      api_reference.view,
      api_reference.markdown,
    ),
    Section(
      accessibility.table_of_contents,
      accessibility.view,
      accessibility.markdown,
    ),
  ])
}
