# Brief: the <<VENUE>> website

## Who this is for
<<VENUE>> is <<one line: format, street, city>>.
<<two lines of history from the content pack: opened, awards, closures or relaunch>>
<<one line on its web presence today, from docs/web-presence.md: no real site, or a site that fails at X>>

This site will be shown to the owner on a phone as a sales pitch, and if they buy it, it goes live as their website.
It has to be good enough that they want it on sight: the best venue website in <<CITY>>, not a template with their name on it.

## No human in the loop
Nobody will answer questions while you work.
Where something is unclear, make the call a strong design lead would make, note it in `DESIGN-NOTES.md`, and keep going.

## What you have
- `PRODUCT.md`: who the venue is, who visits, what the site must achieve.
- `content/`: everything known about the venue as JSON (venue and spaces, menu, events, private-party packages, press quotes and reviews) plus `SOURCES.md`.
  Use this content; do not invent prices, dishes, events, quotes or facts.
- `public/assets/`: real photos of the venue, its food, drinks and nights, with `MANIFEST.md` describing each file.
  The logo is ready as vector files: `public/assets/logo/logo-dark.svg` (dark lettering, for light backgrounds) and `logo-light.svg` (light lettering, for dark backgrounds), traced from the venue's own logo.
  Use these photos and this logo. Crop, grade, mask and treat them however you like, but do not generate or fake photos of the venue, and do not redraw or replace the logo.
  Illustration, type, texture, CSS or SVG art of your own making is welcome.
- An empty Next.js app (App Router, TypeScript, Tailwind installed). Install any library you want (motion, smooth scroll, WebGL, anything).
  Read `AGENTS.md` first: this Next.js version differs from what you may remember.

## What to build
A complete, production-quality site, all of it working:
- Home: what <<VENUE>> is and what is on this week, its spaces, and clear routes to book.
- What's On: recurring nights and dated events, each event with its own shareable page. Ticketed events link out to their ticketing page; free nights get an RSVP via WhatsApp. Past events are clearly marked as past.
- Private parties and corporate events: this is the money page. Spaces and capacities, packages, and an enquiry form (name, phone, event type, date, guests, budget band, alcohol yes or no, preferred space).
  On submit, store the enquiry server-side (a JSON file is fine for now), and show a thank-you that offers a pre-filled WhatsApp message to the venue.
- Menu: real HTML, readable on a phone, clearly labelled as a sample menu from public listings, to be confirmed by the venue.
- The spaces: <<list of zones or spaces>>, what each is for.
- Contact and reserve: one address, one phone, hours, map link, Instagram, and links to book a table on <<booking platforms>>.
- Reserve, WhatsApp and Directions reachable from every page at all times, without ever covering content.
- LocalBusiness and Event structured data. Keep the existing `noindex` settings: this is a private demo.

## How it should feel
Creative, interactive and alive as you scroll: the kind of scroll-driven, fluid, cinematic experience the best studio sites of the last couple of years have made, where the page moves and reveals itself as you go.
It must feel made by people who know this venue, for this venue, and it must not look AI-generated or templated.
The venue's own material to work from: <<name story, interiors, menu art, mascot, signature nights, from venue.md and the asset manifest>>.
Creativity will be judged, alongside polish and whether it actually works.

## Non-negotiables
- Mobile first. Almost every visitor arrives from Instagram or Google Maps on a phone, often on mobile data.
  The motion must stay smooth on a mid-range phone, and the page must never trap the user's scroll.
  Make sure every scroll-driven animation actually moves as the page scrolls. With CSS scroll timelines, an ancestor with `overflow: hidden` silently freezes the animation; use `overflow: clip`.
  Firefox (and browsers built on it) has no CSS scroll-driven animations, so the motion must also work there: drive it with JavaScript, or load the scroll-timeline polyfill only where `CSS.supports("animation-timeline", "view()")` is false. The polyfill only reads plain top-level rules, not rules inside `@supports` or `@media`, and not ranges the CSS minifier has shortened (for example `entry 0% cover 40%` becomes `entry cover 40%`).
- Respect `prefers-reduced-motion` with a calm version that still looks designed.
- Fast: production build, optimised images, no layout shift; aim for Lighthouse mobile performance 90+. Readable contrast everywhere, keyboard and screen-reader friendly.
- `npm run build` and `npm run lint` pass with no errors.
- Check your own work in a real browser with the Playwright tools: phone (390x844) and desktop (1440x900), scroll through every page, look at the screenshots critically, and fix what looks off.
  Use port {{PORT}} for any server you start, and stop it when you finish.
- Keep every file you create, temporary ones included, inside {{ARM_DIR}}.
- Commit your work to git as you go, with clear messages.
- Do not modify anything under `.claude/`.

## When you are done
Write `DESIGN-NOTES.md`: the concept and why it suits <<VENUE>>, the type and colour choices, the motion ideas, what you checked, and anything left unfinished.
The site is finished when every page above exists, works on phone and desktop, and builds cleanly.
