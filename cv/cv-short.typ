#import "lib.typ": *
#let d = json("data.json")

#set page(
  paper: "us-letter",
  margin: (x: 0.95in, top: 0.85in, bottom: 0.8in),
  footer: context {
    set text(size: 7.5pt, fill: muted)
    grid(columns: (1fr, auto, 1fr),
      align(left)[#d.profile.name — Short CV],
      align(center)[#counter(page).display("1")],
      align(right)[Full CV: #d.profile.homepage/cv.pdf])
  },
)
#set text(font: "Spectral", size: 9.5pt, fill: ink, lang: "en")
#set par(leading: 0.58em, spacing: 0.58em)

#block(below: 1.1em, grid(columns: (1fr, auto), column-gutter: 2em,
  {
    text(size: 22pt, weight: "light", tracking: -0.01em, d.profile.name)
    v(0.35em, weak: true)
    text(size: 8.5pt, fill: accent, tracking: 0.1em, upper("Professor of Political Science · ITAM"))
  },
  align(right, {
    set text(size: 8.3pt, fill: muted)
    link("mailto:" + d.profile.email, d.profile.email); linebreak()
    link("https://" + d.profile.homepage, d.profile.homepage)
  }),
))

#sect("Academic Positions")
#for p in d.positions {
  block(below: 0.5em, {
    text(weight: "medium", p.institution)
    linebreak()
    for r in p.roles {
      let span = if "start" in r and r.start != none {
        " (" + str(r.start) + "–" + (if "end" in r and r.end != none { str(r.end) } else { "" }) + ")"
      } else { "" }
      block(below: 0.3em, pad(left: 1em, text(size: 9pt, top-edge: "cap-height", bottom-edge: "baseline", r.title + span)))
    }
  })
}

#sect("Education")
#for e in d.education { row(e.degree, e.text) }

#sect("Selected Publications")
#for it in d.short_articles { pubitem(it) }
#v(0.4em)
#text(size: 8.3pt, weight: "medium", tracking: 0.1em, fill: muted, upper("Books"))
#v(0.4em, weak: true)
#for it in d.short_books { pubitem(it) }

#sect("Selected Awards and Fellowships")
#for a in d.awards.slice(0, 8) { dated(a) }

#sect("Languages")
#plain(d.languages)
