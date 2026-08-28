#import "lib.typ": *
#let d = json("data.json")

#set page(
  paper: "us-letter",
  margin: (x: 0.95in, top: 0.8in, bottom: 0.7in),
  footer: context {
    set text(size: 7.5pt, fill: muted)
    grid(columns: (1fr, auto, 1fr),
      align(left)[#d.profile.name — Short CV],
      align(center)[#counter(page).display("1")],
      align(right)[Full CV: #d.profile.homepage/cv.pdf])
  },
)
#set text(font: "Spectral", size: 9.6pt, fill: ink, lang: "en")
#set par(leading: 0.70em, spacing: 0.70em)

#block(below: 1.45em, grid(columns: (1fr, auto), column-gutter: 2em,
  {
    block(below: 0.9em, text(size: 23pt, weight: "light", tracking: -0.015em, d.profile.name))
    block(below: 0pt, text(size: 8.3pt, fill: accent, tracking: 0.13em,
      upper("Professor of Political Science · ITAM")))
  },
  align(right, {
    set text(size: 8.3pt, fill: muted)
    set par(leading: 0.55em)
    link("mailto:" + d.profile.email, d.profile.email); linebreak()
    link("https://" + d.profile.homepage, d.profile.homepage)
  }),
))

#sect("Academic Positions", tight: true)
#for p in d.positions {
  block(below: 0.5em, {
    text(weight: "medium", p.institution)
    linebreak()
    for r in p.roles {
      let span = if "start" in r and r.start != none {
        " (" + str(r.start) + "–" + (if "end" in r and r.end != none { str(r.end) } else { "" }) + ")"
      } else { "" }
      let unit = if "unit" in r and r.unit != none { ", " + r.unit } else { "" }
      block(below: 0.46em, pad(left: 1em, text(size: 9pt, top-edge: "cap-height", bottom-edge: "baseline", r.title + unit + span)))
    }
  })
}

#sect("Education", tight: true)
#for e in d.education { row(e.degree, e.text) }

#sect("Selected Publications", tight: true)
#for it in d.short_articles { pubitem(it) }
#v(0.4em)
#text(size: 8.3pt, weight: "medium", tracking: 0.1em, fill: muted, upper("Books"))
#v(0.4em, weak: true)
#for it in d.short_books { pubitem(it) }

#sect("Selected Awards and Fellowships", tight: true)
#for a in d.awards.slice(0, 5) { dated(a) }

#sect("Languages", tight: true)
#plain(d.languages)
