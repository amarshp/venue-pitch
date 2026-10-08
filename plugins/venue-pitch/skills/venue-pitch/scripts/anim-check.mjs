// Checks that every CSS scroll-driven animation on a page actually moves as the page scrolls.
// A frozen one usually means an ancestor with overflow: hidden became the animation's scroller; use overflow: clip.
// Needs the playwright package: run from a folder where `npm i playwright` has been done.
// Usage: node anim-check.mjs <url> [width] [height]
import { chromium } from 'playwright';

const [url, W = '1440', H = '900'] = process.argv.slice(2);
const browser = await chromium.launch();
const page = await (await browser.newContext({ viewport: { width: +W, height: +H } })).newPage();
await page.goto(url, { waitUntil: 'networkidle' });
await page.addStyleTag({ content: 'html{scroll-behavior:auto!important}' });
const results = await page.evaluate(async () => {
  const frame = () => new Promise((r) => requestAnimationFrame(() => requestAnimationFrame(r)));
  const out = [];
  for (const a of document.getAnimations()) {
    if (!a.timeline || a.timeline instanceof DocumentTimeline) continue;
    const el = a.effect.target;
    const top = el.getBoundingClientRect().top + scrollY;
    const seen = [];
    // sample the element low, middle and high in the viewport
    for (const f of [0.8, 0.5, 0.2]) {
      scrollTo(0, top - f * innerHeight);
      await frame();
      seen.push(a.effect.getComputedTiming().progress);
    }
    let scroller = 'page';
    for (let e = el.parentElement; e && e !== document.body; e = e.parentElement) {
      const s = getComputedStyle(e);
      if (/hidden|auto|scroll/.test(s.overflowX + s.overflowY)) {
        scroller = `${e.tagName.toLowerCase()}.${[...e.classList].slice(0, 3).join('.')}`;
        break;
      }
    }
    out.push({ name: a.animationName, top: Math.round(top), seen, scroller });
  }
  return out;
});
// An animation near the very top of the page cannot be scrolled "before" itself, so it may legitimately read the same
const frozen = results.filter((r) => new Set(r.seen.map(String)).size === 1 && r.top > +H);
console.log(`${results.length} CSS scroll animations, ${frozen.length} frozen` + (results.length ? '' : ' (animations driven by JavaScript are not checked)'));
for (const r of frozen) console.log(`  frozen: ${r.name} at y=${r.top}, tracking ${r.scroller}`);
await browser.close();
process.exit(frozen.length ? 1 : 0);
