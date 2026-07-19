import docs/element_page.{type ElementPage, ElementPage, Section}
import docs/page/accordion/section/accessibility
import docs/page/accordion/section/api_reference
import docs/page/accordion/section/examples
import docs/page/accordion/section/installation
import docs/page/accordion/section/introduction
import docs/page/accordion/section/usage
import docs/page/accordion/section/variants
import drip/registry

// --- Page --------------------------------------------------------------------

pub fn page() -> ElementPage(message) {
  ElementPage(element: registry.accordion, sections: [
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
