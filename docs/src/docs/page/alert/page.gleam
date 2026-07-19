import docs/element_page.{type ElementPage, ElementPage, Section}
import docs/page/alert/section/accessibility
import docs/page/alert/section/api_reference
import docs/page/alert/section/examples
import docs/page/alert/section/installation
import docs/page/alert/section/introduction
import docs/page/alert/section/usage
import docs/page/alert/section/variants
import drip/registry

// --- Page --------------------------------------------------------------------

pub fn page() -> ElementPage(message) {
  ElementPage(element: registry.alert, sections: [
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
