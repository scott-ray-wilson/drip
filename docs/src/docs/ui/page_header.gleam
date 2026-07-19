import docs/route.{type Route}
import gleam/uri
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import ui/button
import ui/button_group
import ui/dropdown_menu
import ui/icon
import ui/typography

/// Wire up the delegated copy-page behavior: the `data-markdown` button
/// copies its payload, flashes the copied state, and feeds the live region.
/// See `page_header.ffi.mjs` for the implementation.
@external(javascript, "./page_header.ffi.mjs", "init")
pub fn init() -> Nil

// --- View --------------------------------------------------------------------

const content_id: String = "copy-page-menu"

/// The header at the top of every docs page. `markdown` feeds the copy-page
/// button; `prompt` is the ask the Open in Claude / ChatGPT items splice into
/// "Read <page url> and <prompt>. Be ready to ...", so pass a lowercase
/// clause with no trailing period.
pub fn view(
  route route: Route,
  eyebrow eyebrow: String,
  title title: String,
  lede lede: String,
  markdown markdown: String,
  prompt prompt: String,
) -> Element(message) {
  let markdown_path = route.path(route) <> ".md"
  let encoded =
    uri.percent_encode(
      "Read "
      <> route.public_origin
      <> markdown_path
      <> " and "
      <> prompt
      <> ". Be ready to answer questions, share example code, and help me troubleshoot.",
    )
  let claude_url = "https://claude.ai/new?q=" <> encoded
  let chatgpt_url = "https://chatgpt.com/?hints=search&q=" <> encoded

  element.fragment([
    html.div([attribute.class("flex items-start justify-between gap-4")], [
      html.div([attribute.class("min-w-0")], [
        typography.eyebrow([attribute.class("text-accent")], [
          html.text(eyebrow),
        ]),
        typography.page_title([], [html.text(title)]),
      ]),
      dropdown_menu.root([
        button_group.root(
          [button_group.horizontal(), attribute.class("shrink-0")],
          [
            // copy page button
            button.button(
              [
                button.outline(),
                button.sm(),
                attribute.class("group/copy"),
                // Payload and FFI hook in one: a data-slot would lose to the
                // wrapped button's own.
                attribute.data("markdown", markdown),
              ],
              [
                html.span(
                  [
                    attribute.class("inline-flex items-center gap-1.5"),
                  ],
                  [
                    icon.copy([
                      attribute.class("group-data-[copied=true]/copy:hidden"),
                    ]),
                    icon.check([
                      attribute.class(
                        "hidden group-data-[copied=true]/copy:inline-flex",
                      ),
                    ]),
                    html.text("Copy Page"),
                  ],
                ),

                // The copied state above swaps via CSS only; this live region
                // is what screen readers hear.
                html.span(
                  [
                    attribute.class("sr-only"),
                    attribute.attribute("aria-live", "polite"),
                    attribute.data("copy-status", ""),
                  ],
                  [],
                ),
              ],
            ),

            // --- Copy Options ---
            button.button(
              [
                button.outline(),
                button.sm(),
                button.icon_only(),
                attribute.attribute("aria-label", "More copy options"),
                ..dropdown_menu.trigger_attributes(content_id)
              ],
              [icon.chevron_down([])],
            ),
          ],
        ),
        dropdown_menu.content(
          [
            attribute.id(content_id),
            dropdown_menu.bottom(),
            dropdown_menu.align_end(),
            dropdown_menu.collision_padding_top(72),
          ],
          [
            external_item(markdown_path, icon.file_text([]), "View as Markdown"),
            external_item(claude_url, icon.claude([]), "Open in Claude"),
            external_item(chatgpt_url, icon.chat_gpt([]), "Open in ChatGPT"),
          ],
        ),
      ]),
    ]),
    typography.lede([], [html.text(lede)]),
  ])
}

fn external_item(
  href: String,
  icon: Element(message),
  label: String,
) -> Element(message) {
  dropdown_menu.link_item(
    [
      attribute.href(href),
      attribute.target("_blank"),
      attribute.rel("noopener noreferrer"),
    ],
    [icon, html.text(label)],
  )
}
