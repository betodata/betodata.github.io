#!/usr/bin/env node
/* ---------------------------------------------------------------------------
   Renders the PDF CV from the same YAML the website uses.

     data/*.yml  ->  cv/data.json  ->  typst  ->  public/cv.pdf
                                                  public/cv-short.pdf

   Nothing about the CV is edited by hand. Add a paper to publications.yml and
   both the website and both PDFs pick it up on the next build.
--------------------------------------------------------------------------- */
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import yaml from 'js-yaml';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const read = (f) => yaml.load(fs.readFileSync(path.join(ROOT, 'data', f), 'utf8'));

const profile = read('profile.yml');
const pubs    = read('publications.yml');
const teach   = read('teaching.yml');
const cv      = read('cv.yml');

// --- CV convention: "with X and Y" (the website uses full author lists) ------
// Word and hand-typed YAML mix straight and curly marks; normalise for print.
const smartQuotes = (s) => (s ?? '')
  .replace(/(\w)'(\w)/g, '$1\u2019$2')
  .replace(/'/g, '\u2019');

function withClause(item) {
  const co = item.coauthors || [];
  const verb = item.role ? `${item.role} with` : 'with';   // e.g. "coedited with"
  if (!co.length) return item.role || '';
  if (co.length === 1) return `${verb} ${co[0]}`;
  return `${verb} ${co.slice(0, -1).join(', ')} and ${co[co.length - 1]}`;
}

/* Citations are emitted in four parts rather than one string so that Typst can
   italicise the middle one. Which field lands in `ital` depends on the kind of
   work — the journal for an article, the containing book for a chapter, the
   work's own title for a book:

     article  “Title,” with X,      <Journal>          22(4): 1-20.
     chapter  “Title,” in Eds.,     <Book title>     , Publisher.
     book                            <Title>         , with X, Publisher, Series.
     wp       “Title,” with X.                                                  */
function citationParts(item) {
  const w = withClause(item);
  const isBook = !item.venue && !item.editors && !!item.publisher;

  if (isBook) {
    const post = [w, item.publisher, item.series].filter(Boolean).join(', ');
    return { pre: '', ital: item.title, vol: '', post };
  }

  let pre = `\u201C${item.title},\u201D`;
  if (w) pre += ` ${w},`;
  if (item.editors) pre += ` in ${item.editors},`;
  if (!item.venue) pre = pre.replace(/,$/, '');          // working paper: no venue

  const post = [];
  if (item.publisher && item.publisher !== item.venue) post.push(item.publisher);
  if (item.series) post.push(item.series);
  if (item.language) post.push(`in ${item.language}`);

  return {
    pre,
    ital: item.venue || '',
    vol: item.volume || '',
    post: post.join(', '),
  };
}

const fmt = (list) => list.map((i) => {
  const c = citationParts(i);
  return {
    year: i.year ?? null,
    pre:  smartQuotes(c.pre),
    ital: smartQuotes(c.ital),
    vol:  smartQuotes(c.vol),
    post: smartQuotes(c.post),
    note: i.note ?? null,
    former: i.former_title ?? null,
  };
});

// Short CV: items flagged `featured: true`, else the 6 most recent articles.
// Tuned to land on one page — add `featured: true` in publications.yml to pick
// your own, but keep the count to about six or it spills onto a second page.
const featured = pubs.articles.filter((a) => a.featured);
const shortArticles = featured.length ? featured : pubs.articles.slice(0, 6);

const courses = teach.institutions.map((inst) => ({
  name: inst.name + (inst.location ? ` (${inst.location})` : ''),
  years: inst.years ?? null,
  courses: inst.courses.map((c) => {
    const paren = [c.format, c.program, c.years].filter(Boolean).join(', ');
    return paren ? `${c.title} (${paren})` : c.title;
  }),
}));

const data = {
  profile: {
    name: profile.name,
    address: profile.address.lines,
    email: profile.email,
    homepage: profile.homepage.replace(/^https?:\/\//, ''),
  },
  positions: cv.positions,
  education: cv.education.map((e) => ({
    degree: e.degree, text: `${e.institution}, ${e.field}, ${e.year}`,
  })),
  articles:  fmt(pubs.articles),
  books:     fmt(pubs.books),
  progress:  fmt(pubs.working_papers),
  other:     fmt(pubs.other_publications),
  short_articles: fmt(shortArticles),
  short_books:    fmt(pubs.books),
  grants: cv.grants,
  awards: cv.fellowships_and_awards,
  service: cv.service_to_discipline.map((s) =>
    s.role ? `${s.year}. ${s.role}, ${s.organization}.` : `${s.year}. ${s.note}.`),
  institutional: cv.institutional_service,
  talks: cv.invited_presentations,
  conferences: cv.conference_presentations,
  teaching: courses,
  memberships: cv.professional_memberships,
  advising: cv.advising,
  media: cv.media_coverage,
  experience: cv.other_experience,
  languages: profile.languages,
  generated: new Date().toISOString().slice(0, 10),
};

fs.writeFileSync(path.join(ROOT, 'cv', 'data.json'), JSON.stringify(data, null, 1));

const out = path.join(ROOT, 'public');
fs.mkdirSync(out, { recursive: true });

for (const [src, dst] of [['cv.typ', 'cv.pdf'], ['cv-short.typ', 'cv-short.pdf']]) {
  execFileSync('typst', [
    'compile', path.join(ROOT, 'cv', src), path.join(out, dst),
    '--root', ROOT, '--font-path', path.join(ROOT, 'cv', 'fonts'),
  ], { stdio: 'inherit' });
  const kb = (fs.statSync(path.join(out, dst)).size / 1024).toFixed(0);
  console.log(`  cv: ${dst} (${kb} KB)`);
}
