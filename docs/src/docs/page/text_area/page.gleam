import docs/element_page.{type ElementPage, ElementPage, Section}
import docs/page/text_area/section/accessibility
import docs/page/text_area/section/api_reference
import docs/page/text_area/section/examples
import docs/page/text_area/section/installation
import docs/page/text_area/section/introduction
import docs/page/text_area/section/usage
import drip/registry

// --- Page --------------------------------------------------------------------

pub fn page() -> ElementPage(message) {
  ElementPage(element: registry.text_area, sections: [
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
