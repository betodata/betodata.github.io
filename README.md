# albertosimpser.com

Static site + PDF CV, both rendered from the same YAML.

## Updating

Everything on the site and in the CV comes from four files in `data/`:

| File | What it holds |
|---|---|
| `publications.yml` | **articles, books, working papers** — the file you'll edit most |
| `teaching.yml` | courses and syllabi |
| `cv.yml` | grants, awards, service, talks, advising, media |
| `profile.yml` | name, contact, bio, profile links |

**To add a paper**, add a block at the top of the right list in `publications.yml`:

```yaml
  - year: 2026
    title: The title exactly as published
    coauthors: [Ada Lovelace, Alan Turing]     # omit if solo
    venue: American Political Science Review
    volume: "119(2): 415-433"
    links:
      - {type: journal,     url: "https://doi.org/..."}
      - {type: preprint,    url: "https://papers.ssrn.com/..."}
      - {type: replication, url: "https://doi.org/10.7910/DVN/..."}
```

Commit and push. GitHub rebuilds the site *and* both PDFs. Nothing else to touch.

Link types: `journal preprint pdf replication data code appendix preregistration
media toc order review`. `replication`, `data`, and `code` render as a filled
chip on the site, because those are the links most worth finding.

**To post a syllabus**, drop the PDF in `public/files/syllabi/` and add a line
under that course's `materials:` in `teaching.yml`.

## Running locally

```bash
npm install
npm run dev      # site at localhost:4321
npm run cv       # rebuild public/cv.pdf and public/cv-short.pdf only
npm run build    # CVs + site into dist/
npm run check    # report dead links (also runs in CI)
```

Requires Node 20+ and [Typst](https://github.com/typst/typst) (`brew install typst`).

## How it fits together

```
data/*.yml ──┬─> src/lib/data.js ──> Astro ──────────> dist/   (the website)
             └─> cv/build-cv.mjs ──> cv/data.json ──> Typst ──> public/cv.pdf
                                                              public/cv-short.pdf
```

The CV ignores the web-only fields (`links`, `abstract`, `tags`); the site uses
them. That is what lets one edit update both.

The CV is set in Libertinus Serif, which ships inside Typst. The build passes
`--ignore-system-fonts`, so the PDF is identical on any machine — no fonts to
vendor or pin. To try another face without editing the template:

```bash
typst compile cv/cv.typ out.pdf --root . --font-path <dir> \
  --input font="EB Garamond" --input size=10.5
```

## Deployment

Push to `main`. `.github/workflows/deploy.yml` builds and publishes to GitHub
Pages. The custom domain is set by `public/CNAME`.
