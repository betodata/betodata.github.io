#!/usr/bin/env node
/* Checks every external URL in the YAML, plus every local file the YAML
   points at. Runs in CI so a link that rots surfaces in a build log rather
   than in front of a reader. Never fails the build — it reports. */
import fs from 'node:fs';
import path from 'node:path';
import yaml from 'js-yaml';

const ROOT = process.cwd();
const read = (f) => yaml.load(fs.readFileSync(path.join(ROOT, 'data', f), 'utf8'));
const pubs = read('publications.yml');
const teach = read('teaching.yml');

const urls = new Map();          // url -> [where]
const add = (u, where) => {
  if (!u) return;
  if (!urls.has(u)) urls.set(u, []);
  urls.get(u).push(where);
};

for (const key of ['articles', 'books', 'working_papers', 'other_publications'])
  for (const it of pubs[key] || [])
    for (const l of it.links || []) add(l.url, it.title);

for (const inst of teach.institutions)
  for (const c of inst.courses)
    for (const m of c.materials || []) add(m.url, c.title);

const local = [...urls.keys()].filter((u) => u.startsWith('/'));
const remote = [...urls.keys()].filter((u) => /^https?:/.test(u));

let bad = 0;

console.log(`\nLocal files (${local.length})`);
for (const u of local) {
  const p = path.join(ROOT, 'public', u);
  const ok = fs.existsSync(p);
  if (!ok) bad++;
  console.log(`  ${ok ? 'ok  ' : 'MISS'} ${u}${ok ? '' : `   <- ${urls.get(u)[0]}`}`);
}

console.log(`\nExternal links (${remote.length})`);
const results = await Promise.all(remote.map(async (u) => {
  try {
    const ctl = AbortSignal.timeout(20000);
    let r = await fetch(u, { method: 'HEAD', redirect: 'follow', signal: ctl });
    if (r.status === 405 || r.status === 501)
      r = await fetch(u, { method: 'GET', redirect: 'follow', signal: ctl });
    return { u, status: r.status };
  } catch (e) {
    return { u, status: 0, err: e.message };
  }
}));

for (const { u, status, err } of results.sort((a, b) => a.status - b.status)) {
  // 401/403/429 are publisher bot-blocking, not rot — flag separately.
  const state = status === 0 ? 'DEAD' : status >= 400 && ![401, 403, 429].includes(status)
    ? 'DEAD' : [401, 403, 429].includes(status) ? 'bot?' : 'ok  ';
  if (state === 'DEAD') bad++;
  console.log(`  ${state} ${status || err} ${u}`);
}

console.log(`\n${bad} problem(s) found across ${urls.size} links.\n`);
