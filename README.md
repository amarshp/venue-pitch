# venue-pitch

A Claude Code skill for selling a website to a bar, restaurant or venue.
Give it a venue name and city, and it works through the whole job with you:

1. **Research.**
   - Who owns the venue, and its history.
   - Its current web presence.
   - Every listing, and where they contradict each other.
   - Search demand, and what reviewers praise and complain about.
2. **Competitors.** A real competitor set that it researches itself, then an audit of how much effort each competitor puts into the web.
3. **Pack.**
   - An evidence file where every number has a source and a date.
   - A content pack: menu, events, spaces, parties, reviews.
   - A photo pack, and the venue's logo traced to a clean vector.
4. **Concepts.** 5-6 site concepts drawn from the venue's own story; you pick 2-3.
5. **Build.** Each concept is built by its own Opus agent in an isolated workspace: a complete, scroll-driven, mobile-first Next.js site.
6. **Judge.** You judge the sites blind on your phone. Then an AI judge records scroll frames, runs Lighthouse, tests the forms and scores each site. A fix pass follows.
7. **Pitch.** A slide deck with numbers and proofs, plus a pitch kit: objections and answers, discovery questions, a price ladder and a pitch-day checklist.

It stops for you at five checkpoints: the competitor set, the pack gaps, the concepts, your blind verdict and the deck. Everything in between runs unattended.

## Install

In Claude Code:

```
/plugin marketplace add amarshp/venue-pitch
/plugin install venue-pitch@venue-pitch
```

Or copy `plugins/venue-pitch/skills/venue-pitch/` into `~/.claude/skills/`.

Then ask: "pitch a website to <venue> in <city>".

## Requirements
- **Windows with PowerShell 7.** The build scripts are PowerShell, and `wait-done.sh` runs in Git Bash.
- **Software:** Node.js 20+, Python 3 with `pip install potracer pillow numpy`, and git.
- **Claude Code**, with:
  - the [Playwright MCP](https://github.com/microsoft/playwright-mcp) server;
  - a web search tool. The skill uses Exa by default. Use your own key, because the free limit runs out on a full run.
- **Anthropic's official plugin marketplace**, for the `frontend-design` skill: `/plugin marketplace add anthropics/claude-plugins-official`. [Impeccable](https://github.com/pbakaus/impeccable) is installed per arm by the scripts. Neither is bundled here.
- **Credentials for the build agents.** They run in throwaway homes with no login of their own, so set one of:
  - `VP_CLAUDE_TOKEN` (from `claude setup-token`);
  - `VP_CLAUDE_TOKEN_FILE`, a path to a file holding the token;
  - `ANTHROPIC_API_KEY`.

## Settings (environment variables)

| Variable | Default | What |
|---|---|---|
| `VP_ROOT` | `C:\vp` | Build workspace. Keep it outside synced folders and outside your user folder. |
| `VP_DOCS_ROOT` | `~/Documents/venue-pitch` | Research, packs, concepts, judging and the pitch kit, one folder per venue. |
| `VP_CLAUDE_TOKEN` / `VP_CLAUDE_TOKEN_FILE` | - | Credentials for the build agents. |

## Cost and time
Expect roughly $60-120 of usage per venue:
- research and judging subagents: about 1-1.5M tokens;
- each Opus build: $15-25 and 30-50 minutes.

The skill states the cost and waits for a yes before it builds.

## Status
v0.1.
- **Tested:** the build scripts (scaffold, arm setup, isolation checks, logo tracing).
- **Not yet run end to end through the skill:** the research, judging and deck phases. They encode a process that has been carried out by hand once.
- **Untested default:** arms using both `frontend-design` and `impeccable` together.

Issues and pull requests are welcome.

## Notes
- **Private demos.** The demo sites use the venue's name and photos before it has signed. Every build is noindex, and links should stay private until the venue agrees.
- **Domains.** Register a venue's domain only to hand it over at cost, never to resell it.

## License
MIT
