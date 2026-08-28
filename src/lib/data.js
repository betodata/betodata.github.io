// Loads the YAML data files. These four files are the single source of truth
// for both this website and the PDF CV.
import fs from 'node:fs';
import path from 'node:path';
import yaml from 'js-yaml';

const DATA = path.resolve(process.cwd(), 'data');
const read = (f) => yaml.load(fs.readFileSync(path.join(DATA, f), 'utf8'));

export const profile      = read('profile.yml');
export const publications = read('publications.yml');
export const teaching     = read('teaching.yml');
export const cv           = read('cv.yml');

// --- author lines ------------------------------------------------------------
// The site shows full author lists with Simpser bolded (his choice); the CV
// keeps the conventional "with X and Y" form. Both derive from `coauthors`.
const SELF = 'Alberto Simpser';

export function authorList(item) {
  const co = item.coauthors || [];
  if (!co.length) return [{ name: SELF, self: true }];
  return [...co.map((n) => ({ name: n, self: false })), { name: SELF, self: true }];
}

export function authorsText(item) {
  const a = authorList(item).map((x) => x.name);
  if (a.length === 1) return a[0];
  return a.slice(0, -1).join(', ') + ' & ' + a[a.length - 1];
}

// --- link presentation -------------------------------------------------------
export const LINK_LABEL = {
  journal: 'Journal', preprint: 'Preprint', pdf: 'PDF',
  replication: 'Replication', data: 'Data', code: 'Code',
  appendix: 'Appendix', preregistration: 'Pre-registration',
  media: 'Coverage', toc: 'Contents', order: 'Order', review: 'Review',
};
export const linkLabel = (l) => l.label || LINK_LABEL[l.type] || l.type;

// Word and hand-typed YAML mix straight and curly marks; normalise for display.
export const smart = (s) => (s ?? '').replace(/(\w)'(\w)/g, '$1\u2019$2').replace(/'/g, '\u2019');

// Splits *emphasised* spans out of a plain-text field so the YAML can stay
// free of markup. Returns [{text, em}] for the template to render.
export function emphasise(str) {
  return (str ?? '').split(/\*([^*]+)\*/g)
    .map((chunk, i) => ({ text: chunk, em: i % 2 === 1 }))
    .filter((c) => c.text !== '');
}

// --- grouping ----------------------------------------------------------------
export function articlesByYear() {
  const groups = new Map();
  for (const a of publications.articles) {
    if (!groups.has(a.year)) groups.set(a.year, []);
    groups.get(a.year).push(a);
  }
  return [...groups.entries()].sort((x, y) => y[0] - x[0]);
}

export const allItems = () => [
  ...publications.articles,
  ...publications.books,
  ...publications.working_papers,
  ...publications.other_publications,
];
