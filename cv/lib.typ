// Shared CV styling. Verdigris accent, Spectral throughout — matches the site.

#let accent = rgb("#3F5E56")
#let ink    = rgb("#141A18")
#let muted  = rgb("#5F6B67")

// Two levels of vertical rhythm, and only two:
//   sp-item  a top-level entry under a section rule — each is a discrete
//            record, so it breathes.
//   sp-sub   an item grouped beneath an institution heading — these belong
//            to the heading above them, so they cluster.
#let sp-item = 0.62em
#let sp-sub  = 0.40em

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
  block(below: sp-item, width: 100%,
    grid(columns: (4.1em, 1fr), column-gutter: 0.7em,
      text(fill: muted, size: 8.2pt)[#year],
      { set par(hanging-indent: 1.1em); body }))
}

#let plain(body, indent: 0em, tight: false) = block(
  below: if tight { sp-sub } else { sp-item }, width: 100%,
  pad(left: indent, par(hanging-indent: 1.4em, body)))

// A flat list entry: {year, text}. Items with no year still align their body
// with everything else, and get a little air so they read as separate notes.
#let listitem(it) = {
  if it.year == "" {
    // No year to hang from, so this reads as a closing note: flush left,
    // full measure, and clearly separated from the dated entries above.
    v(0.9em, weak: true)
    block(below: sp-item, width: 100%, par(hanging-indent: 1.4em, it.text))
  } else {
    row(it.year, it.text)
  }
}

#let pubitem(it) = {
  row(if it.year == none { "" } else { str(it.year) }, {
    // The citation is one paragraph; the notes below it are their own blocks.
    // Joining them with linebreak() put 10.3pt and 8.2pt lines in a single
    // paragraph, and Typst derives leading from each line's own size, so the
    // spacing came out uneven.
    block(below: 0pt, {
      if it.pre != "" [#it.pre ]
      if it.ital != "" { emph(it.ital) }
      if it.vol != "" [ #it.vol]
      if it.post != "" {
        if it.ital != "" or it.vol != "" [, ]
        it.post
      }
      "."
    })
    if it.note != none {
      block(above: 0.42em, below: 0pt,
        text(size: 8.4pt, style: "italic", fill: muted, it.note))
    }
    if it.former != none {
      block(above: 0.42em, below: 0pt,
        text(size: 8.4pt, style: "italic", fill: muted,
          "Previously circulated as \u{201C}" + it.former + ".\u{201D}"))
    }
  })
}

// A left-flush institution heading, at body size, with space beneath it.
// The `below` must exceed the following items' `above` or Typst takes the
// larger of the two and the gap never appears.
#let orghead(name, sub: none) = {
  block(below: 1.15em, {
    text(weight: "medium", name)
    if sub != none { text(fill: muted, ", " + sub) }
  })
}

// A subsection label inside a section ("Peer-reviewed articles and chapters").
// `below` must exceed the following entries' `above` or Typst keeps the
// larger of the two and the gap never appears — the same trap as orghead.
#let subhead(title) = block(below: 1.0em,
  text(size: 8.3pt, weight: "medium", tracking: 0.1em, fill: muted, upper(title)))
