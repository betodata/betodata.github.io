#import "lib.typ": *
#let d = json("data.json")

// Face and body size are overridable so alternatives can be rendered without
// editing this file:  typst compile ... --input font="EB Garamond" --input size=10.5
#let FONT = sys.inputs.at("font", default: "Libertinus Serif")
#let SIZE = eval(sys.inputs.at("size", default: "10.3") + "pt")

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
#set text(font: FONT, size: SIZE, fill: ink, lang: "en")
#set par(leading: 0.5em, spacing: 0.62em)

// ------------------------------- header -------------------------------------
#block(below: 1.45em, grid(columns: (1fr, auto), column-gutter: 2em,
  {
    block(below: 0.9em, text(size: SIZE * 2.45, weight: "light", tracking: -0.015em, d.profile.name))
    block(below: 0pt, text(size: SIZE * 0.88, fill: accent, tracking: 0.13em,
      upper("Professor of Political Science · ITAM")))
  },
  align(right, {
    set text(size: 8.3pt, fill: muted)
    set par(leading: 0.55em)
    for l in d.profile.address { l; linebreak() }
    link("mailto:" + d.profile.email, d.profile.email); linebreak()
    link("https://" + d.profile.homepage, d.profile.homepage)
  }),
))

#sect("Academic Positions")
#for p in d.positions {
  block(below: 1.2em, {
    orghead(p.institution, sub: if "location" in p and p.location != none { p.location } else { none })
    for r in p.roles {
      let span = if "start" in r and r.start != none {
        " (" + str(r.start) + "–" + (if "end" in r and r.end != none { str(r.end) } else { "" }) + ")"
      } else { "" }
      let unit = if "unit" in r and r.unit != none { ", " + r.unit } else { "" }
      block(below: 0.4em, pad(left: 1em, text(top-edge: "cap-height", bottom-edge: "baseline", r.title + unit + span)))
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
#for g in d.grants { listitem(g) }

#sect("Fellowships, Affiliations, and Awards")
#for a in d.awards { listitem(a) }

#sect("Professional Service to the Discipline")
#for s in d.service { listitem(s) }

#sect("Other Professional Service")
#for (org, items) in d.institutional {
  block(below: 1.5em, {
    orghead(org)
    for i in items { plain(i, indent: 1.2em) }
  })
}

#sect("Invited Presentations")
#for t in d.talks { listitem(t) }

#sect("Presentations at Disciplinary Conferences")
#for c in d.conferences { listitem(c) }

#sect("Teaching")
#for inst in d.teaching {
  block(below: 1.5em, {
    orghead(inst.name, sub: inst.years)
    for c in inst.courses { plain(c, indent: 1.2em) }
  })
}

#sect("PhD Student Advising")
#for g in d.advising {
  block(below: 0.9em, {
    if g.group != none { orghead(g.group) }
    for a in g.items { plain(a, indent: if g.group != none { 1.2em } else { 0em }) }
  })
}

#sect("Selected Media Coverage of Research")
#for m in d.media { listitem(m) }

#sect("Professional Memberships")
#for m in d.memberships { plain(m) }

#sect("Other Experience")
#for e in d.experience {
  block(below: 0.7em, {
    block(below: 0.32em, {
      text(weight: "medium", e.role + ", " + e.organization)
      text(fill: muted, ", " + e.years)
    })
    block(below: 0.45em, pad(left: 1.2em, text(e.detail)))
    if "note" in e and e.note != none {
      block(below: 0.1em, pad(left: 1.2em, text(style: "italic", fill: muted, e.note)))
    }
  })
}

#sect("Languages")
#plain(d.languages)
