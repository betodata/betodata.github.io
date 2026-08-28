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

// An entry parsed out of a flat "2019. Some text." string.
#let dated(s) = {
  let m = s.find(regex("^([0-9]{4}[–\-]?[0-9]*)[.,]?\\s+"))
  if m == none {
    plain(s)
  } else {
    row(m.trim().trim(".").trim(), s.slice(m.len()))
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
