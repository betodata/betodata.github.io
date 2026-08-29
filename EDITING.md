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

## Add a publication

**File:** `data/publications.yml`. Add a block at the top of the right list.

```yaml
  - year: 2026
    title: The title exactly as published
    coauthors: [Ada Lovelace, Alan Turing]     # omit the line if solo
    venue: American Political Science Review
    volume: "119(2): 415-433"
    links:
      - {type: journal,     url: "https://doi.org/..."}
      - {type: preprint,    url: "https://papers.ssrn.com/..."}
      - {type: replication, url: "https://doi.org/10.7910/DVN/..."}
```

Link types: `journal preprint pdf replication data code appendix
preregistration media toc order review`.

Optional: `note:` for an award line, `former_title:` if it circulated under a
different name (renders as "Previously circulated as …").

---

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
