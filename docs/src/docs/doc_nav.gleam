import docs/route.{type Route}
import lustre/element.{type Element}
import ui/icon

// --- Documentation Navigation ------------------------------------------------

// The top-level documentation nav, shared by the sidebar and the search
// palette.

pub fn items() -> List(#(Route, Element(message), String, String)) {
  [
    #(
      route.Introduction,
      icon.sparkles([]),
      "Introduction",
      "Elements for Lustre that land in your project as source.",
    ),
    #(
      route.GettingStarted,
      icon.book([]),
      "Getting Started",
      "From an empty directory to a themed, rendering element.",
    ),
    #(
      route.Cli,
      icon.terminal([]),
      "CLI",
      "Commands that vendor elements into your project and keep the stylesheet wired.",
    ),
    #(
      route.Theming,
      icon.palette([]),
      "Theming",
      "One set of design tokens: CSS variables in a stylesheet you own.",
    ),
    #(
      route.Elements,
      icon.box([]),
      "Elements",
      "The element catalog: pick one to read its docs.",
    ),
  ]
}
