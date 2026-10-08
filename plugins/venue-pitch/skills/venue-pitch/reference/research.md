# Research: phases 1-3

Run independent research as parallel background subagents (general-purpose, Sonnet). Each agent writes its own files under the docs folder and returns a short summary.
Give every agent:
- the venue's exact name, address and listing URLs from Phase 0;
- the docs folder path;
- the rules from SKILL.md: sources and dates, no invention, sequential search with retry, `browser_evaluate` over snapshots;
- the files it owns.

## Phase 1: discovery (four agents in parallel)

### 1a. Identity, owner and history: `docs/venue.md`
- **Ownership:** the operating company and owner or group, and the group's other venues. This decides who to pitch, and other venues are a natural upsell.
- **History:** opening year, closures and relaunches, awards, and the architect or interior designer with their project page. Use the Wayback Machine if that page is gone.
- **Brand:** the story behind the name, any mascot, menu art, colours, and the typefaces seen on menus and posters.
- **Look-alikes:** domains and social handles with similar names that belong to someone else. List them so nothing gets attributed to the venue by mistake.

### 1b. Web presence audit: `docs/web-presence.md`
Decide the branch the whole pitch hangs on:
- **No site, or a dead one:**
  - RDAP for the obvious domains;
  - the Wayback Machine for every past domain: what each was, and when and how it died. This answers "we had a website".
- **A live site:**
  - Lighthouse mobile, page weight, and load time on a phone profile;
  - Wayback distinct versions and Last-Modified, to show how stale it is;
  - broken links;
  - what it fails to answer: menu, this week's events, booking, party enquiry, hours, one phone number;
  - whether Instagram and Google Maps link to it at all.
- **Either way:** where the Instagram bio link goes, whether the Google Business Profile has a website button, and any link-in-bio page.

### 1c. Listings consistency: `docs/listings.md`
Cover every listing that shows the venue: dining and booking apps, review sites, ticketing platforms, and private-party marketplaces.
For each, record: cost for two, hours, phones, menu (present or not, and its date), offers, ratings with counts, party packages and capacities.
Produce a conflicts table (the same fact with different values, per source). Note duplicate listings, and marketplaces that show their own phone number instead of the venue's.

### 1d. Demand and reviews: `docs/demand.md`, `docs/reviews.md`
- **Google Trends** for the brand in the venue's region:
  - 5-year interest, and related and rising queries;
  - the brand next to competitors on one scale.
  - Keep the CSVs. Values are relative and noisy, so mark them for a rerun on pitch day.
- **Do not pitch on competitor traffic.** Visit counts for small sites are not obtainable.
- **Reviews:**
  - recurring praise, as testimonial candidates with source and date;
  - recurring complaints the site could answer (event timing, pricing confusion, booking problems). Keep these in a "do not display" list.

## Phase 2: real competitors

### 2a. Build the set yourself
Search for the venues the target is actually compared with:
- the curated collections it appears in on dining apps;
- events and dining in the same area and price band on ticketing platforms;
- venues listed alongside it on party marketplaces;
- the same street or neighbourhood with the same format tags;
- shared promoters and Instagram co-authors.
Arrange them in rings:
1. same street, format and price;
2. same-night alternatives;
3. private-party rivals.
Mark venues that have closed permanently or temporarily (not just closed for the night).
Write `docs/competitors.md`. Then **CP1**: show the rings in a short table and get a yes before 2b.

### 2b. Effort audit of rings 1 and 2: `docs/competitor-effort.md`
For each venue, record:
- own domain (registration dates, DNS live or dead) and Wayback distinct versions;
- site tech;
- menu on site;
- events with dates, and how stale they are;
- booking on site, and a party page;
- page weight and load time;
- Instagram followers and where the bio link goes;
- when the dining-app menu was last updated;
- the Trends value on the brand scale.
End with the pitch lines it supports, for example "3 of 12 have a working site; every events list is stale".

## Phase 3: evidence, content, pricing

### 3a. Evidence file: `docs/evidence.md`
Start from `evidence-library.md`. Recheck any item past its recheck date, then add the venue-specific findings from phases 1-2.
Rate each item:
- STRONG: a filing, contract, archive, or the venue's own page;
- MEDIUM: named press or an industry body;
- WEAK: a vendor survey.
Keep a "NOT FOUND, do not say" list.

### 3b. Content pack: `build/content/` (one agent)
- `venue.json`:
  - name, address, geo, phones, hours, Instagram, ratings, cost for two;
  - tagline candidates in the venue's own words only;
  - spaces, each with description, capacity, best_for and source.
- `menu.json`: sections and items, each with name, description, price (or null), veg, source and date seen. Include a status saying it is a sample from public listings.
- `events.json`: recurring and dated events, with price, promoter and ticket URL.
- `parties.json`.
- `voice.json`: press quotes and reviews with source and date, plus a do-not-display list.
- `SOURCES.md`: one line per source, a conflicts section with the value chosen and why, and a missing section.

Aim for the full menu. Image menus can be transcribed. Older menu cards on other sites are kept apart and labelled as older.

### 3c. Local pricing: `docs/pricing.md`
Collect published website prices in the same city: template shops, custom builds with a CMS and bookings, and maintenance retainers. This feeds the price conversation, never the deck.

### 3d. PRODUCT.md: `build/PRODUCT.md`
Fill `templates/PRODUCT.md` from the content pack. Then **CP2**: list the gaps the owner could fill: a vector logo, original photos, prices, and the WhatsApp number for enquiries.
