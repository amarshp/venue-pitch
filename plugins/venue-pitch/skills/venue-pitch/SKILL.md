---
name: venue-pitch
description: End-to-end pitch for selling a website to a bar, restaurant or venue - deep research on the venue, its owner, its listings and its real competitors; a sourced evidence file; a content and photo pack with a traced logo; 2-3 competing scroll-driven website builds in isolated agents; blind judging and a fix pass; and a slide deck with numbers and proofs plus a pitch kit. Use when asked to pitch, build a demo site for, or convince a venue to get a website.
---

# Venue pitch: research, build 2-3 sites, deck

Scripts, references and templates live next to this file; `<skill>` below means this file's folder.

## Inputs and defaults
- **Venue:** name and city (required). The slug is a short lowercase name.
- **Docs folder:** `$VP_DOCS_ROOT/<Venue>/`, default `~/Documents/venue-pitch/<Venue>/`. Research, the pack, concepts and judging land here.
- **Build workspace:** `$VP_ROOT/<slug>/`, default `C:\vp\<slug>`. See `reference/build.md`.
- **Mode:**
  - **product** (default): each site gets a different concept, and the goal is the best sellable sites.
  - **compare**: every arm gets the same brief, to compare design skills.
- **Arms:** 2 concepts by default, plus an optional wild card.
- **Models:** arms use `claude-opus-5-5`. Research and judging subagents use Sonnet.
- **Arm skills:** a parameter per arm. Default: `frontend-design` for creative direction plus `impeccable` for checking, both named in the arm's run prompt so the arm uses both rather than picking one.
- **Cost:** research and judging take roughly 1-1.5M subagent tokens. Each Opus arm takes $15-25 and 30-50 min. State the total before Phase 5 and get a yes.

## Phases and checkpoints
Report briefly at the end of each phase. Pause only at the checkpoints (CP); run everything between them unattended.

| # | Phase | Reference | Output | Pause |
|---|---|---|---|---|
| 0 | Intake | this file | docs folder, workspace | if the venue's identity is ambiguous |
| 1 | Discovery: identity and owner, web presence, listings, demand, reviews | `reference/research.md` | `docs/` | - |
| 2 | Competitor set from your own search, then effort audit | `reference/research.md` | `docs/competitors.md`, `docs/competitor-effort.md` | **CP1: confirm the set** |
| 3 | Evidence file, content pack, asset pack and logo, local pricing | `reference/research.md`, `reference/assets.md`, `reference/evidence-library.md` | `docs/evidence.md`, `build/` | **CP2: gaps the owner could fill** |
| 4 | Concepts from the venue's own story; pick the most different | `reference/build.md` | `build/concepts/` | **CP3: pick concepts** |
| 5 | Build arms in isolation, canary first | `reference/build.md` | one site per arm | - |
| 6 | Serve, blind judging (user, then AI), fix pass | `reference/judge.md` | blind links, `build/judge/JUDGE.md` | **CP4: blind verdict** |
| 7 | Deck and pitch kit | `reference/deck.md` | slide deck, `PITCH-KIT.md` | **CP5: deck review** |

## Phase 0: intake
1. Pin the venue: its exact name and address, and its listing URLs (Google Maps, Zomato or the local equivalent). Check look-alike names and domains before you rely on them. If two venues could match, ask.
2. Create the docs folder. Record the inputs and decisions as you go.
3. If the user can log into Instagram and Facebook in the Playwright browser, ask now. Logged-out Instagram shows almost nothing, and it is usually the richest photo source.
4. Start `<skill>/scripts/new-workspace.ps1 -Slug <slug>` in the background.

## Rules that apply throughout
- **No invention.** Never invent a fact, price, quote, event or photo. Every number in the evidence file, the content pack and the deck carries a source and the date it was seen.
- **Check before you rely.** A claim from an old document, a chat or a third-party summary is a hypothesis until a live page confirms it. Listings change week to week.
- **Run research in parallel.** Use parallel background subagents, each owning its own files.
- **Searching:** keep each agent's web-search calls sequential, and on a rate-limit error wait and retry.
- **Browser extraction:** on listing sites, prefer extracting with `browser_evaluate` over full-page snapshots.
- **These are private demos.** They use the venue's name and photos before it has signed:
  - every build is noindex;
  - links are shared privately;
  - a domain registered for the venue is handed over at cost, never resold at a markup.
