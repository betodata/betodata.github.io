#import "lib.typ": *
#let d = json("data.json")

#set page(
  paper: "us-letter",
  margin: (x: 0.95in, top: 0.85in, bottom: 0.8in),
  numbering: "1",
  number-align: center,
  footer: context {
    set text(size: 7.5pt, fill: muted)
    grid(columns: (1fr, auto, 1fr),
      align(left)[#d.profile.name — Curriculum Vitae],
      align(center)[#counter(page).display("1")],
      align(right)[#d.generated])
  },
)
#set text(font: "Spectral", size: 9.3pt, fill: ink, lang: "en")
#set par(leading: 0.58em, spacing: 0.58em)

// ------------------------------- header -------------------------------------
#block(below: 1.1em, grid(columns: (1fr, auto), column-gutter: 2em,
  {
    text(size: 22pt, weight: "light", tracking: -0.01em, d.profile.name)
    v(0.35em, weak: true)
    text(size: 8.5pt, fill: accent, tracking: 0.1em, upper("Professor of Political Science · ITAM"))
  },
  align(right, {
    set text(size: 8.3pt, fill: muted)
    for l in d.profile.address { l; linebreak() }
    link("mailto:" + d.profile.email, d.profile.email); linebreak()
    link("https://" + d.profile.homepage, d.profile.homepage)
  }),
))

#sect("Academic Positions")
#for p in d.positions {
  block(below: 0.6em, {
    text(weight: "medium", p.institution)
    if "location" in p and p.location != none { text(fill: muted, ", " + p.location) }
    linebreak()
    for r in p.roles {
      let span = if "start" in r and r.start != none {
        " (" + str(r.start) + "–" + (if "end" in r and r.end != none { str(r.end) } else { "" }) + ")"
      } else { "" }
      let unit = if "unit" in r and r.unit != none { ", " + r.unit } else { "" }
      block(below: 0.3em, pad(left: 1em, text(size: 9pt, top-edge: "cap-height", bottom-edge: "baseline", r.title + unit + span)))
    }
  })
}

#sect("Education")
#for e in d.education { row(e.degree, e.text) }

#sect("Published Research")
#text(size: 8.3pt, weight: "medium", tracking: 0.1em, fill: muted, upper("Peer-reviewed articles and chapters"))
#v(0.45em, weak: true)
#for it in d.articles { pubitem(it) }

#v(0.5em)
#text(size: 8.3pt, weight: "medium", tracking: 0.1em, fill: muted, upper("Peer-reviewed books"))
#v(0.45em, weak: true)
#for it in d.books { pubitem(it) }

#sect("Research in Progress")
#for it in d.progress { pubitem(it) }

#sect("Other Academic Publications")
#for it in d.other { pubitem(it) }

#sect("Grants")
#for g in d.grants { dated(g) }

#sect("Fellowships, Affiliations, and Awards")
#for a in d.awards { dated(a) }

#sect("Professional Service to the Discipline")
#for s in d.service { dated(s) }

#sect("Other Professional Service")
#for (org, items) in d.institutional {
  block(below: 0.5em, {
    text(weight: "medium", size: 9pt, org)
    v(0.25em, weak: true)
    for i in items { plain(i) }
  })
}

#sect("Invited Presentations")
#for t in d.talks { dated(t) }

#sect("Presentations at Disciplinary Conferences")
#for c in d.conferences { dated(c) }

#sect("Teaching")
#for inst in d.teaching {
  block(below: 0.55em, {
    text(weight: "medium", size: 9pt, inst.name)
    if inst.years != none { text(fill: muted, size: 8.5pt, ", " + inst.years) }
    v(0.25em, weak: true)
    for c in inst.courses { plain(c) }
  })
}

#sect("PhD Student Advising")
#for a in d.advising { plain(a) }

#sect("Selected Media Coverage of Research")
#for m in d.media { dated(m) }

#sect("Professional Memberships")
#for m in d.memberships { plain(m) }

#sect("Other Experience")
#for e in d.experience {
  block(below: 0.4em, {
    text(weight: "medium", e.role + ", " + e.organization)
    text(fill: muted, ", " + e.years)
    linebreak()
    pad(left: 1em, text(size: 8.8pt, e.detail))
    if "note" in e and e.note != none {
      linebreak(); pad(left: 1em, text(size: 8.8pt, style: "italic", fill: muted, e.note))
    }
  })
}

#sect("Languages")
#plain(d.languages)
