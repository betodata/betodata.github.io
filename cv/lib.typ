// Shared CV styling. Verdigris accent, Spectral throughout — matches the site.

#let accent = rgb("#3F5E56")
#let ink    = rgb("#141A18")
#let muted  = rgb("#5F6B67")

#let sect(title, tight: false) = {
  v(if tight { 0.95em } else { 1.5em }, weak: true)
  block(
    width: 100%,
    stroke: (bottom: 0.5pt + accent),
    inset: (bottom: 4.5pt),
    text(size: 8pt, weight: "medium", tracking: 0.15em, fill: accent, upper(title)),
  )
  v(if tight { 0.55em } else { 0.85em }, weak: true)
}

// A dated row: year in a fixed left column, body hanging beside it.
#let row(year, body) = {
  block(below: 0.62em, width: 100%,
    grid(columns: (4.1em, 1fr), column-gutter: 0.7em,
      text(fill: muted, size: 8.2pt)[#year],
      par(hanging-indent: 1.1em, body)))
}

#let plain(body) = block(below: 0.62em, width: 100%,
  par(hanging-indent: 1.4em, body))

// A flat list entry: {year, text}. Items with no year still align their body
// with everything else, and get a little air so they read as separate notes.
#let listitem(it) = {
  if it.year == "" {
    v(0.35em, weak: true)
    block(below: 0.62em, width: 100%,
      grid(columns: (4.1em, 1fr), column-gutter: 0.7em,
        [], par(hanging-indent: 1.1em, it.text)))
  } else {
    row(it.year, it.text)
  }
}

#let pubitem(it) = {
  row(if it.year == none { "" } else { str(it.year) }, {
    if it.pre != "" [#it.pre ]
    if it.ital != "" { emph(it.ital) }
    if it.vol != "" [ #it.vol]
    if it.post != "" {
      if it.ital != "" or it.vol != "" [, ]
      it.post
    }
    "."
    if it.note != none {
      linebreak()
      text(size: 8.2pt, style: "italic", fill: muted, it.note)
    }
    if it.former != none {
      linebreak()
      text(size: 8.2pt, style: "italic", fill: muted,
        "Previously circulated as \u{201C}" + it.former + ".\u{201D}")
    }
  })
}

// A left-flush institution heading, at body size, with space beneath it.
#let orghead(name, sub: none) = {
  // Must exceed the following items' `above` (0.70em) or Typst takes the
  // larger of the two and the gap never appears.
  block(below: 1.15em, {
    text(weight: "medium", name)
    if sub != none { text(fill: muted, ", " + sub) }
  })
}
