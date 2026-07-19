// Lucide icons consolidated into one module so usage is `icon.<name>([..])`.
// Drip's elements and the docs examples both import this, so a copied snippet
// and a vendored element resolve against the same icons. Drip never ships it:
// codegen's emit_dist copies only per-element files, and consumers regenerate
// `ui/icon` with lucide_lustre (see the getting-started "Icons" section).
// Geometry is from Lucide (https://lucide.dev), ISC-licensed (some icons via
// Feather, MIT); see the repo NOTICE. `chat_gpt`, `claude`, and `github` are
// brand marks, not from Lucide (Lucide dropped brand icons).

import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/svg

fn base(
  attributes: List(Attribute(message)),
  children: List(Element(message)),
) -> Element(message) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "none"),
      attribute.attribute("stroke", "currentColor"),
      attribute.attribute("stroke-width", "1.75"),
      attribute.attribute("stroke-linecap", "round"),
      attribute.attribute("stroke-linejoin", "round"),
      attribute.aria_hidden(True),
      ..attributes
    ],
    children,
  )
}

pub fn arrow_left(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m12 19-7-7 7-7")]),
    svg.path([attribute.attribute("d", "M19 12H5")]),
  ])
}

pub fn arrow_right(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M5 12h14")]),
    svg.path([attribute.attribute("d", "m12 5 7 7-7 7")]),
  ])
}

pub fn audio_lines(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M2 10v3")]),
    svg.path([attribute.attribute("d", "M6 6v11")]),
    svg.path([attribute.attribute("d", "M10 3v18")]),
    svg.path([attribute.attribute("d", "M14 8v7")]),
    svg.path([attribute.attribute("d", "M18 5v13")]),
    svg.path([attribute.attribute("d", "M22 10v3")]),
  ])
}

pub fn blocks(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M10 22V7a1 1 0 0 0-1-1H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5a1 1 0 0 0-1-1H2",
      ),
    ]),
    svg.rect([
      attribute.attribute("x", "14"),
      attribute.attribute("y", "2"),
      attribute.attribute("width", "8"),
      attribute.attribute("height", "8"),
      attribute.attribute("rx", "1"),
    ]),
  ])
}

pub fn book(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20",
      ),
    ]),
  ])
}

pub fn book_open_text(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M12 7v14")]),
    svg.path([attribute.attribute("d", "M16 12h2")]),
    svg.path([attribute.attribute("d", "M16 8h2")]),
    svg.path([
      attribute.attribute(
        "d",
        "M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z",
      ),
    ]),
    svg.path([attribute.attribute("d", "M6 12h2")]),
    svg.path([attribute.attribute("d", "M6 8h2")]),
  ])
}

pub fn box(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z",
      ),
    ]),
    svg.path([attribute.attribute("d", "m3.3 7 8.7 5 8.7-5")]),
    svg.path([attribute.attribute("d", "M12 22V12")]),
  ])
}

pub fn brush(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m11 10 3 3")]),
    svg.path([
      attribute.attribute(
        "d",
        "M6.5 21A3.5 3.5 0 1 0 3 17.5a2.62 2.62 0 0 1-.708 1.792A1 1 0 0 0 3 21z",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M9.969 17.031 21.378 5.624a1 1 0 0 0-3.002-3.002L6.967 14.031",
      ),
    ]),
  ])
}

pub fn chat_gpt(attributes: List(Attribute(message))) -> Element(message) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "currentColor"),
      ..attributes
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M22.282 9.821a5.985 5.985 0 0 0-.516-4.91 6.046 6.046 0 0 0-6.51-2.9A6.065 6.065 0 0 0 4.981 4.18a5.985 5.985 0 0 0-3.998 2.9 6.046 6.046 0 0 0 .743 7.097 5.98 5.98 0 0 0 .51 4.911 6.051 6.051 0 0 0 6.515 2.9A5.985 5.985 0 0 0 13.26 24a6.056 6.056 0 0 0 5.772-4.206 5.99 5.99 0 0 0 3.997-2.9 6.056 6.056 0 0 0-.747-7.073zM13.26 22.43a4.476 4.476 0 0 1-2.876-1.04l.141-.081 4.779-2.758a.795.795 0 0 0 .392-.681v-6.737l2.02 1.168a.071.071 0 0 1 .038.052v5.583a4.504 4.504 0 0 1-4.494 4.494zM3.6 18.304a4.47 4.47 0 0 1-.535-3.014l.142.085 4.783 2.759a.771.771 0 0 0 .78 0l5.843-3.369v2.332a.08.08 0 0 1-.033.062L9.74 19.95a4.5 4.5 0 0 1-6.14-1.646zM2.34 7.896a4.485 4.485 0 0 1 2.366-1.973V11.6a.766.766 0 0 0 .388.676l5.815 3.355-2.02 1.168a.076.076 0 0 1-.071 0l-4.83-2.786A4.504 4.504 0 0 1 2.34 7.872zm16.597 3.855-5.833-3.387L15.119 7.2a.076.076 0 0 1 .071 0l4.83 2.791a4.494 4.494 0 0 1-.676 8.105v-5.678a.79.79 0 0 0-.407-.667zm2.01-3.023-.141-.085-4.774-2.782a.776.776 0 0 0-.785 0L9.409 9.23V6.897a.066.066 0 0 1 .028-.061l4.83-2.787a4.5 4.5 0 0 1 6.68 4.66zm-12.64 4.135-2.02-1.164a.08.08 0 0 1-.038-.057V6.075a4.5 4.5 0 0 1 7.375-3.453l-.142.08-4.778 2.758a.795.795 0 0 0-.393.681zm1.097-2.365 2.602-1.5 2.607 1.5v2.999l-2.597 1.5-2.607-1.5Z",
        ),
      ]),
    ],
  )
}

pub fn check(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M20 6 9 17l-5-5")]),
  ])
}

pub fn chevron_down(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m6 9 6 6 6-6")]),
  ])
}

pub fn circle_check(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "10"),
    ]),
    svg.path([attribute.attribute("d", "m9 12 2 2 4-4")]),
  ])
}

pub fn circle_x(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "10"),
    ]),
    svg.path([attribute.attribute("d", "m15 9-6 6")]),
    svg.path([attribute.attribute("d", "m9 9 6 6")]),
  ])
}

pub fn claude(attributes: List(Attribute(message))) -> Element(message) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "currentColor"),
      ..attributes
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "m4.714 15.956 4.718-2.648.079-.23-.08-.128h-.23l-.79-.048-2.695-.073-2.337-.097-2.265-.122-.57-.121-.535-.704.055-.353.48-.321.685.06 1.518.104 2.277.157 1.651.098 2.447.255h.389l.054-.158-.133-.097-.103-.098-2.356-1.596-2.55-1.688-1.336-.972-.722-.491L2 6.223l-.158-1.008.655-.722.88.06.225.061.893.686 1.906 1.476 2.49 1.833.364.304.146-.104.018-.072-.164-.274-1.354-2.446-1.445-2.49-.644-1.032-.17-.619a2.972 2.972 0 0 1-.103-.729L6.287.133 6.7 0l.995.134.42.364.619 1.415L9.735 4.14l1.555 3.03.455.898.243.832.09.255h.159V9.01l.127-1.706.237-2.095.23-2.695.08-.76.376-.91.747-.492.583.28.48.685-.067.444-.286 1.851-.558 2.903-.365 1.942h.213l.243-.242.983-1.306 1.652-2.064.728-.82.85-.904.547-.431h1.032l.759 1.129-.34 1.166-1.063 1.347-.88 1.142-1.263 1.7-.79 1.36.074.11.188-.02 2.853-.606 1.542-.28 1.84-.315.832.388.09.395-.327.807-1.967.486-2.307.462-3.436.813-.043.03.049.061 1.548.146.662.036h1.62l3.018.225.79.522.473.638-.08.485-1.213.62-1.64-.389-3.825-.91-1.31-.329h-.183v.11l1.093 1.068 2.003 1.81 2.508 2.33.127.578-.321.455-.34-.049-2.204-1.657-.85-.747-1.925-1.62h-.127v.17l.443.649 2.343 3.521.122 1.08-.17.353-.607.213-.668-.122-1.372-1.924-1.415-2.168-1.141-1.943-.14.08-.674 7.254-.316.37-.728.28-.607-.461-.322-.747.322-1.476.388-1.924.316-1.53.285-1.9.17-.632-.012-.042-.14.018-1.432 1.967-2.18 2.945-1.724 1.845-.413.164-.716-.37.066-.662.401-.589 2.386-3.036 1.439-1.882.929-1.086-.006-.158h-.055l-4.776 2.69-.027.025Z",
        ),
      ]),
    ],
  )
}

pub fn clipboard_paste(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M11 14h10")]),
    svg.path([attribute.attribute("d", "M16 4h2a2 2 0 0 1 2 2v1.344")]),
    svg.path([attribute.attribute("d", "m17 18 4-4-4-4")]),
    svg.path([
      attribute.attribute(
        "d",
        "M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 1.793-1.113",
      ),
    ]),
    svg.rect([
      attribute.attribute("x", "8"),
      attribute.attribute("y", "2"),
      attribute.attribute("width", "8"),
      attribute.attribute("height", "4"),
      attribute.attribute("rx", "1"),
    ]),
  ])
}

pub fn construction(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("x", "2"),
      attribute.attribute("y", "6"),
      attribute.attribute("width", "20"),
      attribute.attribute("height", "8"),
      attribute.attribute("rx", "1"),
    ]),
    svg.path([attribute.attribute("d", "M17 14v7")]),
    svg.path([attribute.attribute("d", "M7 14v7")]),
    svg.path([attribute.attribute("d", "M17 3v3")]),
    svg.path([attribute.attribute("d", "M7 3v3")]),
    svg.path([attribute.attribute("d", "M10 14 2.3 6.3")]),
    svg.path([attribute.attribute("d", "m14 6 7.7 7.7")]),
    svg.path([attribute.attribute("d", "m8 6 8 8")]),
  ])
}

pub fn copy(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("width", "14"),
      attribute.attribute("height", "14"),
      attribute.attribute("x", "8"),
      attribute.attribute("y", "8"),
      attribute.attribute("rx", "2"),
      attribute.attribute("ry", "2"),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2",
      ),
    ]),
  ])
}

pub fn download(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M12 15V3")]),
    svg.path([
      attribute.attribute("d", "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"),
    ]),
    svg.path([attribute.attribute("d", "m7 10 5 5 5-5")]),
  ])
}

pub fn droplets(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M7 16.3c2.2 0 4-1.83 4-4.05 0-1.16-.57-2.26-1.71-3.19S7.29 6.75 7 5.3c-.29 1.45-1.14 2.84-2.29 3.76S3 11.1 3 12.25c0 2.22 1.8 4.05 4 4.05z",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M12.56 6.6A10.97 10.97 0 0 0 14 3.02c.5 2.5 2 4.9 4 6.5s3 3.5 3 5.5a6.98 6.98 0 0 1-11.91 4.97",
      ),
    ]),
  ])
}

pub fn file_text(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z",
      ),
    ]),
    svg.path([attribute.attribute("d", "M14 2v5a1 1 0 0 0 1 1h5")]),
    svg.path([attribute.attribute("d", "M10 9H8")]),
    svg.path([attribute.attribute("d", "M16 13H8")]),
    svg.path([attribute.attribute("d", "M16 17H8")]),
  ])
}

pub fn github(attributes: List(Attribute(message))) -> Element(message) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("fill", "currentColor"),
      ..attributes
    ],
    [
      svg.path([
        attribute.attribute(
          "d",
          "M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12",
        ),
      ]),
    ],
  )
}

pub fn home(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute("d", "M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z",
      ),
    ]),
  ])
}

pub fn image(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("width", "18"),
      attribute.attribute("height", "18"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "2"),
      attribute.attribute("ry", "2"),
    ]),
    svg.circle([
      attribute.attribute("cx", "9"),
      attribute.attribute("cy", "9"),
      attribute.attribute("r", "2"),
    ]),
    svg.path([
      attribute.attribute("d", "m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"),
    ]),
  ])
}

pub fn info(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "10"),
    ]),
    svg.path([attribute.attribute("d", "M12 16v-4")]),
    svg.path([attribute.attribute("d", "M12 8h.01")]),
  ])
}

pub fn keyboard(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M10 8h.01")]),
    svg.path([attribute.attribute("d", "M12 12h.01")]),
    svg.path([attribute.attribute("d", "M14 8h.01")]),
    svg.path([attribute.attribute("d", "M16 12h.01")]),
    svg.path([attribute.attribute("d", "M18 8h.01")]),
    svg.path([attribute.attribute("d", "M6 8h.01")]),
    svg.path([attribute.attribute("d", "M7 16h10")]),
    svg.path([attribute.attribute("d", "M8 12h.01")]),
    svg.rect([
      attribute.attribute("width", "20"),
      attribute.attribute("height", "16"),
      attribute.attribute("x", "2"),
      attribute.attribute("y", "4"),
      attribute.attribute("rx", "2"),
    ]),
  ])
}

pub fn layout_template(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("width", "18"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "1"),
    ]),
    svg.rect([
      attribute.attribute("width", "9"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "14"),
      attribute.attribute("rx", "1"),
    ]),
    svg.rect([
      attribute.attribute("width", "5"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "16"),
      attribute.attribute("y", "14"),
      attribute.attribute("rx", "1"),
    ]),
  ])
}

pub fn layout_grid(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("width", "7"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "1"),
    ]),
    svg.rect([
      attribute.attribute("width", "7"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "14"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "1"),
    ]),
    svg.rect([
      attribute.attribute("width", "7"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "14"),
      attribute.attribute("y", "14"),
      attribute.attribute("rx", "1"),
    ]),
    svg.rect([
      attribute.attribute("width", "7"),
      attribute.attribute("height", "7"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "14"),
      attribute.attribute("rx", "1"),
    ]),
  ])
}

pub fn loader_circle(attrs: List(Attribute(message))) -> Element(message) {
  base(attrs, [
    svg.path([attribute.attribute("d", "M21 12a9 9 0 1 1-6.219-8.56")]),
  ])
}

pub fn log_out(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m16 17 5-5-5-5")]),
    svg.path([attribute.attribute("d", "M21 12H9")]),
    svg.path([
      attribute.attribute("d", "M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"),
    ]),
  ])
}

pub fn menu(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M4 5h16")]),
    svg.path([attribute.attribute("d", "M4 12h16")]),
    svg.path([attribute.attribute("d", "M4 19h16")]),
  ])
}

pub fn minus(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [svg.path([attribute.attribute("d", "M5 12h14")])])
}

pub fn moon(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401",
      ),
    ]),
  ])
}

pub fn ellipsis(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "1"),
    ]),
    svg.circle([
      attribute.attribute("cx", "19"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "1"),
    ]),
    svg.circle([
      attribute.attribute("cx", "5"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "1"),
    ]),
  ])
}

pub fn mouse_pointer_click(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M14 4.1 12 6")]),
    svg.path([attribute.attribute("d", "m5.1 8-2.9-.8")]),
    svg.path([attribute.attribute("d", "m6 12-1.9 2")]),
    svg.path([attribute.attribute("d", "M7.2 2.2 8 5.1")]),
    svg.path([
      attribute.attribute(
        "d",
        "M9.037 9.69a.498.498 0 0 1 .653-.653l11 4.5a.5.5 0 0 1-.074.949l-4.349 1.041a1 1 0 0 0-.74.739l-1.04 4.35a.5.5 0 0 1-.95.074z",
      ),
    ]),
  ])
}

pub fn package_open(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M12 22v-9")]),
    svg.path([
      attribute.attribute(
        "d",
        "M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z",
      ),
    ]),
  ])
}

pub fn palette(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M12 22a1 1 0 0 1 0-20 10 9 0 0 1 10 9 5 5 0 0 1-5 5h-2.25a1.75 1.75 0 0 0-1.4 2.8l.3.4a1.75 1.75 0 0 1-1.4 2.8z",
      ),
    ]),
    svg.circle([
      attribute.attribute("cx", "13.5"),
      attribute.attribute("cy", "6.5"),
      attribute.attribute("r", ".5"),
      attribute.attribute("fill", "currentColor"),
    ]),
    svg.circle([
      attribute.attribute("cx", "17.5"),
      attribute.attribute("cy", "10.5"),
      attribute.attribute("r", ".5"),
      attribute.attribute("fill", "currentColor"),
    ]),
    svg.circle([
      attribute.attribute("cx", "6.5"),
      attribute.attribute("cy", "12.5"),
      attribute.attribute("r", ".5"),
      attribute.attribute("fill", "currentColor"),
    ]),
    svg.circle([
      attribute.attribute("cx", "8.5"),
      attribute.attribute("cy", "7.5"),
      attribute.attribute("r", ".5"),
      attribute.attribute("fill", "currentColor"),
    ]),
  ])
}

pub fn panel_left(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.rect([
      attribute.attribute("width", "18"),
      attribute.attribute("height", "18"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "2"),
    ]),
    svg.path([attribute.attribute("d", "M9 3v18")]),
  ])
}

pub fn person_standing(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "5"),
      attribute.attribute("r", "1"),
    ]),
    svg.path([attribute.attribute("d", "m9 20 3-6 3 6")]),
    svg.path([attribute.attribute("d", "m6 8 6 2 6-2")]),
    svg.path([attribute.attribute("d", "M12 10v4")]),
  ])
}

pub fn plus(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M5 12h14")]),
    svg.path([attribute.attribute("d", "M12 5v14")]),
  ])
}

pub fn rocket(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute("d", "M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M9 12a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.4 22.4 0 0 1-4 2z",
      ),
    ]),
    svg.path([
      attribute.attribute("d", "M9 12H4s.55-3.03 2-4c1.62-1.08 5 .05 5 .05"),
    ]),
  ])
}

pub fn rotate_ccw(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8",
      ),
    ]),
    svg.path([attribute.attribute("d", "M3 3v5h5")]),
  ])
}

pub fn search(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m21 21-4.34-4.34")]),
    svg.circle([
      attribute.attribute("cx", "11"),
      attribute.attribute("cy", "11"),
      attribute.attribute("r", "8"),
    ]),
  ])
}

pub fn settings(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915",
      ),
    ]),
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "3"),
    ]),
  ])
}

pub fn shield(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z",
      ),
    ]),
  ])
}

pub fn shuffle(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "m18 14 4 4-4 4")]),
    svg.path([attribute.attribute("d", "m18 2 4 4-4 4")]),
    svg.path([
      attribute.attribute(
        "d",
        "M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22",
      ),
    ]),
    svg.path([attribute.attribute("d", "M2 6h1.972a4 4 0 0 1 3.6 2.2")]),
    svg.path([
      attribute.attribute("d", "M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45"),
    ]),
  ])
}

pub fn sparkles(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z",
      ),
    ]),
    svg.path([attribute.attribute("d", "M20 2v4")]),
    svg.path([attribute.attribute("d", "M22 4h-4")]),
    svg.circle([
      attribute.attribute("cx", "4"),
      attribute.attribute("cy", "20"),
      attribute.attribute("r", "2"),
    ]),
  ])
}

pub fn square_stack(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M4 10c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2",
      ),
    ]),
    svg.path([
      attribute.attribute(
        "d",
        "M10 16c-1.1 0-2-.9-2-2v-4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2",
      ),
    ]),
    svg.rect([
      attribute.attribute("width", "8"),
      attribute.attribute("height", "8"),
      attribute.attribute("x", "14"),
      attribute.attribute("y", "14"),
      attribute.attribute("rx", "2"),
    ]),
  ])
}

pub fn sun(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "12"),
      attribute.attribute("r", "4"),
    ]),
    svg.path([attribute.attribute("d", "M12 2v2")]),
    svg.path([attribute.attribute("d", "M12 20v2")]),
    svg.path([attribute.attribute("d", "m4.93 4.93 1.41 1.41")]),
    svg.path([attribute.attribute("d", "m17.66 17.66 1.41 1.41")]),
    svg.path([attribute.attribute("d", "M2 12h2")]),
    svg.path([attribute.attribute("d", "M20 12h2")]),
    svg.path([attribute.attribute("d", "m6.34 17.66-1.41 1.41")]),
    svg.path([attribute.attribute("d", "m19.07 4.93-1.41 1.41")]),
  ])
}

pub fn table(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M12 3v18")]),
    svg.rect([
      attribute.attribute("width", "18"),
      attribute.attribute("height", "18"),
      attribute.attribute("x", "3"),
      attribute.attribute("y", "3"),
      attribute.attribute("rx", "2"),
    ]),
    svg.path([attribute.attribute("d", "M3 9h18")]),
    svg.path([attribute.attribute("d", "M3 15h18")]),
  ])
}

pub fn terminal(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M12 19h8")]),
    svg.path([attribute.attribute("d", "m4 17 6-6-6-6")]),
  ])
}

pub fn text_cursor_input(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute("d", "M12 20h-1a2 2 0 0 1-2-2 2 2 0 0 1-2 2H6"),
    ]),
    svg.path([
      attribute.attribute("d", "M13 8h7a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-7"),
    ]),
    svg.path([
      attribute.attribute("d", "M5 16H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h1"),
    ]),
    svg.path([attribute.attribute("d", "M6 4h1a2 2 0 0 1 2 2 2 2 0 0 1 2-2h1")]),
    svg.path([attribute.attribute("d", "M9 6v12")]),
  ])
}

pub fn trash(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute("d", "M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"),
    ]),
    svg.path([attribute.attribute("d", "M3 6h18")]),
    svg.path([
      attribute.attribute("d", "M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"),
    ]),
  ])
}

pub fn triangle_alert(
  attributes: List(Attribute(message)),
) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3",
      ),
    ]),
    svg.path([attribute.attribute("d", "M12 9v4")]),
    svg.path([attribute.attribute("d", "M12 17h.01")]),
  ])
}

pub fn user(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute("d", "M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"),
    ]),
    svg.circle([
      attribute.attribute("cx", "12"),
      attribute.attribute("cy", "7"),
      attribute.attribute("r", "4"),
    ]),
  ])
}

pub fn wand(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M15 4V2")]),
    svg.path([attribute.attribute("d", "M15 16v-2")]),
    svg.path([attribute.attribute("d", "M8 9h2")]),
    svg.path([attribute.attribute("d", "M20 9h2")]),
    svg.path([attribute.attribute("d", "M17.8 11.8 19 13")]),
    svg.path([attribute.attribute("d", "M15 9h.01")]),
    svg.path([attribute.attribute("d", "M17.8 6.2 19 5")]),
    svg.path([attribute.attribute("d", "m3 21 9-9")]),
    svg.path([attribute.attribute("d", "M12.2 6.2 11 5")]),
  ])
}

pub fn x(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([attribute.attribute("d", "M18 6 6 18")]),
    svg.path([attribute.attribute("d", "m6 6 12 12")]),
  ])
}

pub fn zap(attributes: List(Attribute(message))) -> Element(message) {
  base(attributes, [
    svg.path([
      attribute.attribute(
        "d",
        "M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z",
      ),
    ]),
  ])
}
