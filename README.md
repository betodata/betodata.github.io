# albertosimpser.com

Personal academic site and PDF CV, both rendered from one set of YAML files.
Adding a publication is a single edit that updates the website *and* both PDFs.

Live at <https://betodata.github.io> — moving to albertosimpser.com.

> **To change content, read [`EDITING.md`](EDITING.md).** This file is for
> understanding or modifying the machinery.

---

## How it fits together

```
data/*.yml ──┬─> src/lib/data.js ──> Astro ──────────> dist/        (the website)
             └─> cv/build-cv.mjs ──> cv/data.json ──> Typst ──> public/cv.pdf
                                                                public/cv-short.pdf
```

`data/` is the single source of truth. The CV renderer ignores the web-only
fields (`links`, `abstract`, `tags`); the site uses them. That asymmetry is what
lets one edit drive both outputs without either carrying the other's baggage.

**Stack:** Astro 5 (static, ships no JavaScript), Typst 0.15, js-yaml.

---

## Layout

```
data/                  the only files you edit for content
  publications.yml       articles, books, working papers  <- the main one
  cv.yml                 grants, awards, service, talks, advising, media
  teaching.yml           courses and syllabi
  profile.yml            contact, landing-page paragraphs, profile links

src/
  pages/                 index / research / teaching
  components/            Nav, Entry (one publication or course)
  layouts/Base.astro     shell, <head>, footer
  lib/data.js            loads the YAML, formats authors and links
  styles/global.css      the whole design system

cv/
  cv.typ                 full CV
  cv-short.typ           one-page CV
  lib.typ                shared helpers and the spacing scale
  build-cv.mjs           YAML -> cv/data.json -> typst

scripts/check-links.mjs  link-rot report, runs in CI
public/                  static files served as-is: PDFs, headshot, CNAME
```

---

## Commands

```bash
npm install
npm run dev      # site at localhost:4321, live-reloads on save
npm run cv       # rebuild both PDFs only (~2s)
npm run build    # PDFs + site into dist/
npm run check    # report dead or missing links
```

Requires Node 20+ and [Typst](https://github.com/typst/typst)
(`brew install typst`). CI uses Node 22 and Typst 0.15.1.

`npm run dev` does **not** rebuild the CV — run `npm run cv` for that.

---

## Design notes

**Light and dark are per-container, not per-page.** The landing page is
`<body class="light">` but holds a dark band, so colours come from `--e-*`
tokens that the container declares: `:root` sets the light values, and
`body.dark, .band` override them. Never scope entry colours to `<body>` — that
paints near-black titles on the near-black band.

**`-webkit-font-smoothing: antialiased` is on `body.dark` only.** It thins
strokes, which helps light-on-dark and hurts dark-on-light.

**No portrait below 860px.** Text over a faded face is a visual convention that
isn't this site's, and the crop doesn't survive narrow widths.

**The CV has exactly two vertical spacings**, named in `cv/lib.typ`:
`sp-item` (0.62em) for a top-level entry, `sp-sub` (0.40em) for an item grouped
under an institution heading. Use them rather than new literals.

**Typst takes the larger of two adjacent block margins.** A heading whose
`below` is smaller than the next item's `above` produces no gap at all. If
spacing "won't apply", this is why.

**Fonts are not vendored.** The CV uses Libertinus Serif, embedded in Typst, and
the build passes `--ignore-system-fonts` so the PDF is identical everywhere. To
audition another face without editing the template:

```bash
typst compile cv/cv.typ out.pdf --root . --font-path <dir> \
  --input font="EB Garamond" --input size=10.5
```

---

## Deployment

Push to `main`. `.github/workflows/deploy.yml` installs Typst, runs
`npm run build`, reports link rot without failing the build, and publishes to
GitHub Pages. About a minute end to end.

Pages is configured for **GitHub Actions** as its source, not a branch.
`public/CNAME` carries the custom domain.

Watch a deploy at
<https://github.com/betodata/betodata.github.io/actions>.
