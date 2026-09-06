# How to change what's on your website

Everything you would ever want to change lives in one folder, called **`data`**.
You never touch the design, and you never edit the CV by hand — the PDF is
rebuilt from these same files, so one change updates the website *and* both
CVs.

To open everything in VS Code, paste this into Terminal:

```bash
code "/Users/alberto/claudecodefolder/my website/albertosimpser.com"
```

---

## First, the one rule that matters

The files in `data` end in `.yml`. They have no brackets, tags or codes in
them — **the blank spaces at the start of each line are what says which thing
belongs to which**, like an indented outline. Two spaces means one thing, four
spaces means something belonging to it.

Two consequences:

- **Use the space bar, never the Tab key.** A tab looks identical on screen but
  the file will stop working.
- **Don't type a new entry from scratch.** Copy one that's already there, paste
  it, and change the words. The spacing comes along for free. This is by far
  the easiest way to avoid trouble.

And the reassuring part: **if you do get the spacing wrong, your website does
not go down.** The rebuild simply stops and the current version keeps serving
until you fix it. There is no way to break the live site with a bad edit.

---

## The two paragraphs under your name

**File:** `data/profile.yml`, near the top, under `landing:`

```yaml
landing:
  lede: >-
    First paragraph goes here. It can run over
    as many lines as you like.

  secondary: >-
    Second, smaller paragraph.
```

Three things to keep in mind:

1. **Leave the `>-` where it is.** It's a marker meaning "the paragraph starts
   on the next line." Delete it and the file stops working.
2. **Indent every line of your text by four spaces.**
3. **Where you break the lines doesn't matter.** The `>-` glues them back into
   one flowing paragraph, so press Return wherever it's comfortable to read.

To put a phrase in italics and tint it verdigris, wrap it in asterisks:
`how *social norms* shape political behavior`.

---

## Adding or changing a paper

**File:** `data/publications.yml`. This one file feeds the research page *and*
both CVs.

### The file is in four sections

Scroll through and you'll see four headings sitting at the far-left margin:

```
articles:              line  27   articles and book chapters
books:                 line 270   your two books
working_papers:        line 295   work in progress
other_publications:    line 352   reviews, encyclopedia entries
```

Put your new paper under the right heading. Within each section, papers appear
on the website in the same order they appear in the file — **newest at the
top** — so a new paper goes directly under its heading.

### How the spacing works

```
  - year: 2026                            <- 2 spaces, then a dash and a space
    title: The paper title                <- 4 spaces
    venue: Journal Name                   <- 4 spaces
    links:                                <- 4 spaces
      - {type: journal, url: "https://…"} <- 6 spaces, then a dash and a space
```

**2 spaces** to begin a new paper, **4 spaces** for each fact about it,
**6 spaces** for each link.

### A complete paper you can copy

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

### What each line means

| Line | Do you need it? | Notes |
|---|---|---|
| `year` | yes, except for work in progress | just the number, no quote marks |
| `title` | yes | exactly as published. Put it in quote marks if it contains a colon |
| `coauthors` | no | `[Name, Name]`. **Leave the line out entirely if you wrote it alone** — your own name is added for you |
| `venue` | no | the journal name, or the book title for a chapter |
| `volume` | no | **always in quote marks** — `"119(2): 415-433"` |
| `publisher` | no | for chapters and books |
| `editors` | no | for chapters: `Ménard and Shirley, eds.` |
| `links` | no | see just below |
| `note` | no | award text; appears in small italics under the paper |
| `former_title` | no | appears as "Previously circulated as …" |
| `tags` | no | not shown on the site at the moment |

### The links under each paper

```yaml
    links:
      - {type: journal, url: "https://doi.org/..."}
      - {type: pdf, url: "/files/papers/mypaper.pdf", label: "Accepted version"}
```

The `type` decides what the little button says:

| Type | Button says | | Type | Button says |
|---|---|---|---|---|
| `journal` | Journal | | `appendix` | Appendix |
| `preprint` | Preprint | | `preregistration` | Pre-registration |
| `pdf` | PDF | | `media` | Coverage |
| `replication` | Replication | | `toc` | Contents |
| `data` | Data | | `order` | Order |
| `code` | Code | | `review` | Review |

To make a button say something else, add `label:` — as in the second example
above, which shows *Accepted version* rather than *PDF*.

A web address starting with `/` means a file of your own rather than somewhere
on the internet. Put the PDF in `public/files/papers/` first, then refer to it
as `/files/papers/whatever.pdf`.

**If a paper has no links at all,** write `links: []` — the two square brackets
mean "nothing here."

### Changing a paper that's already listed

Press ⌘F, search a few words of the title, change what you need, and save. To
add one more link, add a line to its `links:` list, indented **6 spaces**.

### Removing a paper

Delete every line of it, from its `- year:` line down to the line just before
the next `- year:`. Don't leave half an entry behind.

---

## Posting a syllabus

1. Put the PDF in the folder `public/files/syllabi/`
2. Add a line under that course's `materials:` in `data/teaching.yml`:

```yaml
        materials:
          - {label: "Syllabus (Spring 2026)", url: "/files/syllabi/your-file.pdf"}
```

**To take one down without losing the file,** put a `#` at the start of its
line. Anything after a `#` is ignored, so the line is still there to bring
back later. Your seven older syllabi are switched off this way right now — the
PDFs are still on disk, and restoring one means deleting a single `#`.

The teaching page opens with the sentence *"Syllabi and course materials are
linked where available."* That sentence shows up only while at least one
syllabus is switched on, and disappears by itself when none are, so the page
never promises links it hasn't got.

---

## Looking at it before you publish (optional)

`npm` is the command that runs the site on your own laptop. In Terminal, from
the website folder:

```bash
npm run dev
```

Then open <http://localhost:4321> in your browser. That address is your own
computer, not the internet — nobody else can see it. It updates every time you
save. Press `Ctrl-C` in the Terminal window to stop it.

To check the links you've added actually work:

```bash
npm run check
```

It reports anything dead or misspelled. Worth running whenever you've pasted a
new web address, because it catches a typo before a reader does.

To rebuild just the CV and look at it: `npm run cv`, then open
`public/cv.pdf`.

---

## Publishing — the step that actually puts it on the web

There are **two copies** of your website: one on your laptop, and one on
GitHub's computers, which is the one the public sees. Saving a file changes
only the copy on your laptop. Publishing means **sending the change to
GitHub**, which then rebuilds the public site.

There are two ways. **The second one needs no Terminal at all**, and for adding
a paper or fixing a typo it's the one to reach for.

### Way A — from your laptop

Open Terminal and type these four lines, one at a time, pressing Return after
each:

```bash
cd "/Users/alberto/claudecodefolder/my website/albertosimpser.com"
git add -A
git commit -m "Added a new paper"
git push
```

In plain words, those four lines say: *go to the website folder* / *gather up
everything I changed* / *give the change a name* / *send it to GitHub*. The
words in quote marks on the third line are just a note to yourself — write
whatever you like, it only has to mean something to you.

### Way B — in a web browser

1. Open the file on GitHub, for example
   [publications.yml](https://github.com/betodata/betodata.github.io/blob/main/data/publications.yml)
2. Click the **pencil** icon at the top right
3. Make your change
4. Scroll down and click the green **Commit changes** button

Sending is included — there's no second step. This works from any computer, or
an iPad.

### Either way

The website and both PDF CVs rebuild themselves in about a minute.

To confirm it worked, open
[the activity page](https://github.com/betodata/betodata.github.io/actions).
A **green tick** means it published. A **red cross** means the file had a
mistake in it, nearly always the spacing.

**A red cross does not take your website down.** The version that's already
published stays up, untouched, until you fix the file and publish again. You
have as long as you need.

---

## If you get a red cross

It is almost always the spaces at the start of a line.

1. Open the file in VS Code. It underlines the offending line in red, and
   hovering over it explains what it expected.
2. Check you used the space bar and not the Tab key.
3. Check the counts: 2 spaces before `- year:`, 4 before each fact, 6 before
   each link, 4 before each line of a landing-page paragraph.

If it still won't go, the fastest fix is to undo your change, publish the
working version, and ask me — nothing is lost while the old version is still
serving.
