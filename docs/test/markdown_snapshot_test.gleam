//// Birdie snapshots of the Markdown every page ships: `/elements/<slug>.md` and
//// the copy-page button both come from `page.markdown_files()`, capturing the
//// exact bytes readers copy and download. One test drives every page, so a new
//// registry element is snapshotted automatically; `birdie.snap` panics on the
//// first changed page, review and accept with `gleam run -m birdie`. Needs the
//// DOM preload (see docs_test.gleam).

import birdie
import docs/page
import gleam/list

pub fn page_markdown_snapshots_test() {
  list.each(page.markdown_files(), fn(file) {
    let #(path, markdown) = file
    birdie.snap(markdown, title: path)
  })
}
