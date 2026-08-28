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
function withClause(item) {
  const co = item.coauthors || [];
  if (!co.length) return '';
  if (co.length === 1) return `with ${co[0]}`;
  return `with ${co.slice(0, -1).join(', ')} and ${co[co.length - 1]}`;
}

// Word and hand-typed YAML mix straight and curly marks; normalise for print.
const smartQuotes = (s) => s
  .replace(/(\w)'(\w)/g, '$1\u2019$2')
  .replace(/'/g, '\u2019');

function citation(item) {
  const bits = [];
  if (item.title) bits.push(`“${item.title},”`);
  const w = withClause(item);
  if (w) bits.push(`${w},`);
  if (item.editors) bits.push(`in ${item.editors},`);
  if (item.venue) bits.push(item.venue);
  if (item.publisher && item.venue !== item.publisher) bits.push(`, ${item.publisher}`);
  if (item.series && !item.venue) bits.push(`${item.publisher} · ${item.series}`);
  if (item.volume) bits.push(` ${item.volume}`);
  let s = bits.join(' ').replace(/\s+,/g, ',').replace(/\s+/g, ' ').trim();
  if (!/[.?!]$/.test(s)) s += '.';
  return smartQuotes(s);
}

const fmt = (list) => list.map((i) => ({
  year: i.year ?? null,
  text: citation(i),
  note: i.note ?? null,
  former: i.former_title ?? null,
}));

// Short CV: items flagged `featured: true`, else the 8 most recent articles.
const featured = pubs.articles.filter((a) => a.featured);
const shortArticles = featured.length ? featured : pubs.articles.slice(0, 8);

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
