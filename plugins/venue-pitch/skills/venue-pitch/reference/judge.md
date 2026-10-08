# Serve, judge, fix: phase 6

## Serve
`scripts/serve.ps1 -Slug <slug> -Arms "b:3101,c:3102[,d:3103]"` does four things:
- builds each arm and runs `next start`;
- opens a Cloudflare quick tunnel per arm;
- writes `serve/blind-links.txt` with labels X, Y, Z for the person judging;
- writes `serve/blind-mapping.txt`, kept hidden until they have judged.

Before sending the links, load each one at phone size yourself.
Quick tunnels are temporary. `-Restart` gives new URLs under the same labels.
For the pitch itself, use a fixed address, such as a named tunnel on a domain or a paid hosting preview.

## Judge
- **The user judges first, blind, on a phone.** Ask them to look at:
  - creativity, motion and polish;
  - whether it looks AI-made;
  - the party form and the event pages;
  - what the winner should take from the others.
  Do not reveal the mapping before their verdict.
- **Then the AI judge.** It is a background Sonnet agent with only the labelled URLs and no access to the workspace (`templates/judge.md`). It produces:
  - scroll frames and contact sheets at phone and desktop size;
  - function checks;
  - Lighthouse mobile results;
  - seven scores with evidence;
  - problems with frame references;
  - a verdict.
- **Check that the animations play:** run `scripts/anim-check.mjs <url>` at phone and desktop size on each site. It exits non-zero and names the scroller when a scroll-driven animation is frozen; put any it finds in the fix pass.
- **Confirm the judge's bug reports in the code before passing them on.**
- **Report to the user:**
  - the mapping;
  - time and cost per arm;
  - the judge's table;
  - the confirmed bugs.

## Fix pass
Every site going to the client gets a follow-up run (`run-arm.ps1 -Tag fix1`). Its prompt lists the confirmed problems and the borrowings the user approved, and asks the arm to:
1. fix each one;
2. re-check at both viewports;
3. keep `npm run build` and `npm run lint` clean;
4. commit.

Then rebuild, re-serve, and check each fix yourself.
