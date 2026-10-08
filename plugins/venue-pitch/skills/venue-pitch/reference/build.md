# Concepts and build: phases 4-5

## Phase 4: concepts
Arms given the same brief can converge on the same idea, so pick distinct concepts deliberately.
1. Write 5-6 concepts to `build/concepts/<name>.md`. Ground each in something real about the venue: the story behind its name, its interiors, menu art, street or signature nights.
   Each concept covers:
   - the idea in one line;
   - the hero moment on a phone;
   - how scrolling moves the story;
   - type and colour, drawn from the venue's own palette;
   - how the pages that make money (parties, events) carry the idea;
   - one risk.
2. Pick the 2 that differ most in look, structure and motion. Optionally add a wild card: the boldest idea that still meets every non-negotiable in the brief.
3. **CP3**: show the shortlist, one paragraph each, and build what the user picks.
4. In compare mode, skip this phase: every arm gets the identical brief.

## Phase 5: build
The workspace (`$VP_ROOT/<slug>`) must sit outside synced folders, because node_modules does not sync well. It must also sit outside your user folder: Claude Code reads CLAUDE.md files from parent folders, and they would leak into every arm.

1. **Base.** `scripts/new-workspace.ps1 -Slug <slug>` (started in Phase 0). It creates a neutral Next.js scaffold with no font or design. noindex is set in the meta tags, the headers and robots.txt.
2. **Brief.** Fill `templates/BRIEF.md` into `build/BRIEF.md`:
   - replace every `<<...>>` with facts from the content pack;
   - leave `{{PORT}}` and `{{ARM_DIR}}` as they are, because `new-arm.ps1` fills them;
   - do not paste any design skill's rules into the brief, so each arm's skills stay the only difference between arms.
3. **Arms.** Create one arm per concept:
   `scripts/new-arm.ps1 -Slug <slug> -Arm b -Port 3101 -PackDir <docs>\build -Skills frontend-design,impeccable -Concept <docs>\build\concepts\<name>.md`.
   Use ports 3101, 3102 and so on. Every arm gets the same pack, logo and model.
4. **Canary each arm** with `templates/canary.txt` on a cheap model:
   `run-arm.ps1 -Slug <slug> -Arm b -PromptFile <skill>\templates\canary.txt -Tag canary -Model sonnet -Budget 2`.
   From the init event and the answer, confirm:
   - the arm sees exactly its intended skills;
   - no CLAUDE.md is loaded;
   - the browser MCP is connected;
   - in Impeccable arms, the post-edit hook fires.
   Then delete what the canary wrote.
5. **Launch.** State the cost and get a yes. Start each arm as a detached process so it survives an idle session:
   `Start-Process pwsh -WindowStyle Hidden -ArgumentList '-NoProfile','-File','<skill>\scripts\run-arm.ps1','-Slug','<slug>','-Arm','<arm>','-PromptFile','<skill>\templates\prompt.txt','-Tag','r1'`.
   Check free memory first; three arms at once needs about 10 GB.
6. **Wait.** Run `bash <skill>/scripts/wait-done.sh <slug> r1 <arms>` in the background. It returns when every arm has exited, not at its first result. `python <skill>/scripts/status.py <slug> r1 <arms>` shows progress.
7. **After the runs.**
   - Read each arm's final report and `DESIGN-NOTES.md`.
   - Check in the status output that each arm called the skills it was given.
   - Before calling a surprising fact invented, check it against the content pack.
   - The machine must stay awake for the whole run.
