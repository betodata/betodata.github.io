# How to edit the site

Everything you'd want to change lives in **`data/`**. You never edit HTML, and
you never edit the CV PDF — it is regenerated from the same files.

Open the project in VS Code:

```bash
code "/Users/alberto/claudecodefolder/my website/albertosimpser.com"
```

---

## The two paragraphs under your name

**File:** `data/profile.yml` — look for `landing:` near the top.

```yaml
landing:
  lede: >-
    First paragraph goes here. It can run over
    as many lines as you like.

  secondary: >-
    Second, smaller paragraph.
```

Three rules:

1. Keep the `>-` after `lede:` and `secondary:`.
2. Indent every line of text by **four spaces**. YAML uses indentation for
   structure — a tab, or three spaces, breaks the build.
3. Line breaks inside a paragraph don't matter. `>-` folds them into one
   flowing paragraph, so wrap wherever is comfortable.

To italicise a phrase and tint it verdigris, wrap it in asterisks:
`how *social norms* shape political behavior`.

---

## The research page — adding and editing papers

**File:** `data/publications.yml`. Everything on the research page comes from
here, and so does the CV. One edit updates both.

### The file has four lists

Open the file and you'll see four headings at the far left margin:

```
articles:              line  27   articles and book chapters
books:                 line 267   your two books
working_papers:        line 295   work in progress
other_publications:    line 352   reviews, encyclopedia entries
```

Put a new item under the right heading. Within each list, entries appear on the
site in the order they appear in the file — **newest first**, so a new paper
goes at the top of its list.

### Indentation is the whole game

YAML has no brackets; the structure *is* the indentation. Exactly:

```
  - year: 2026                    <- 2 spaces, then "- "
    title: The paper title        <- 4 spaces
    links:                        <- 4 spaces
      - {type: journal, url: "…"} <- 6 spaces, then "- "
```

Spaces only, never tabs. If VS Code shows a red squiggle, this is why.

### A complete entry, to copy

```yaml
  - year: 2026
    title: The title exactly as published
    coauthors: [Ada Lovelace, Alan Turing]
    venue: American Political Science Review
    volume: "119(2): 415-433"
    links:
      - {type: journal,     url: "https://doi.org/10.1017/..."}
      - {type: preprint,    url: "https://papers.ssrn.com/..."}
      - {type: replication, url: "https://doi.org/10.7910/DVN/..."}
    tags: [elections, experiments]
```

### The fields

| Field | Required? | Notes |
|---|---|---|
| `year` | yes (not for working papers) | just the number, no quotes |
| `title` | yes | as published. Quote it if it contains a colon |
| `coauthors` | no | `[Name, Name]`. **Omit the line if solo** — your own name is added automatically |
| `venue` | no | journal name, or the book title for a chapter |
| `volume` | no | **always in quotes** — `"119(2): 415-433"` |
| `publisher` | no | for chapters and books |
| `editors` | no | for chapters: `Ménard and Shirley, eds.` |
| `links` | no | see below |
| `note` | no | award text; renders in small italics |
| `former_title` | no | renders as "Previously circulated as …" |
| `tags` | no | not yet used on the site |

### Links

```yaml
    links:
      - {type: journal, url: "https://doi.org/..."}
      - {type: pdf, url: "/files/papers/mypaper.pdf", label: "Accepted version"}
```

Types, which set the button text: `journal` `preprint` `pdf` `replication`
`data` `code` `appendix` `preregistration` `media` `toc` `order` `review`.

Add `label:` to override the button text. A `url` starting with `/` means a file
in `public/` — put the PDF in `public/files/papers/` first.

**A paper with no links:** write `links: []`.

### Editing an existing paper

Find it (⌘F for a few words of the title), change what you need, save. To add
one more link, add a line to its `links:` block at **6 spaces**.

### Deleting a paper

Delete every line of the entry, from its `- year:` line down to the line before
the next `- year:`. Leave no partial entry behind.

### Always check before publishing

```bash
npm run check      # reports any dead or missing link
npm run dev        # look at the page at localhost:4321
```

`npm run check` is worth running every time you touch a URL — it catches typos
before a reader finds them.

## Post a syllabus

1. Put the PDF in `public/files/syllabi/`
2. Add a line under that course's `materials:` in `data/teaching.yml`:

```yaml
        materials:
          - {label: "Syllabus (Spring 2026)", url: "/files/syllabi/your-file.pdf"}
```

---

## Preview before publishing (optional)

```bash
npm run dev
```

Open <http://localhost:4321>. It updates as you save. `Ctrl-C` to stop.

To check just the CV: `npm run cv`, then open `public/cv.pdf`.

---

## Publish — THE STEP THAT MAKES IT LIVE

Saving the file changes nothing on the web. You must also do this:

```bash
cd "/Users/alberto/claudecodefolder/my website/albertosimpser.com"
git add -A
git commit -m "Update landing text"
git push
```

GitHub rebuilds the site and both PDFs, and it is live in about a minute.

**Check it worked:** <https://github.com/betodata/betodata.github.io/actions> —
a green tick means deployed, a red cross means the build failed (almost always
a YAML indentation slip).

### Or skip the terminal entirely

Edit the file at
<https://github.com/betodata/betodata.github.io/blob/main/data/profile.yml>,
click the pencil, make your change, then **Commit changes**. That publishes
itself. Works from any machine, including an iPad.

---

## If the build fails

It's nearly always indentation. Open the file in VS Code — the YAML extension
underlines the offending line in red. Check that you used spaces, not tabs, and
that every line of a paragraph is indented by four spaces.
