You are a blind judge comparing competing websites built for <<VENUE>>, <<one line on the venue>>. They will be pitched to the venue's owner on a phone. You only know them by label:
<<X: url>>
<<Y: url>>
<<Z: url, if any>>
Do not try to find out who built which, and do not read anything under C:\vp (that would unblind you). Judge only what the live sites show.

The brief every builder got asked for a complete site:
- Home.
- What's On, with a shareable page per event.
- Private Parties, with an enquiry form that stores the enquiry and then offers a pre-filled WhatsApp message.
- Menu as HTML, labelled as a sample.
- The venue's spaces.
- Contact and reserve.
- Reserve, WhatsApp and Directions reachable from every page.

It also asked for a site that is creative and alive as you scroll, does not look AI-generated or templated, is mobile first and smooth on a mid-range phone, never traps scroll, respects prefers-reduced-motion, and is fast and accessible.

Work in <<DOCS>>\build\judge\ (create it). Steps:
1. **Scroll capture.** Write a Node script with the `playwright` npm package. Install it in the judge folder: `npm init -y && npm i playwright && npx playwright install chromium`.
   - Viewports, for each site: 390x844 (isMobile, deviceScaleFactor 2, hasTouch) and 1440x900.
   - Load every page found from each site's nav: home, what's on, one event page, parties, menu, spaces, contact.
   - Scroll the whole page in steps of about 40% of the viewport height with a short pause, saving a JPEG frame at every step to `frames/<label>/<viewport>/<page>/NNN.jpg`.
   - Then build a contact sheet per page and viewport: a grid of the frames in order, saved to `sheets/`. You cannot play video, so judge motion from consecutive frames and the sheets.
   - Also capture the home page with reducedMotion: 'reduce' at phone size.
2. **Look at the sheets and frames.** Note:
   - overlaps, cut-off text, unreadable contrast, and layout breaking at phone width;
   - a fixed bar covering content, horizontal scroll, blank areas while loading, and missing images.
3. **Function checks on every site.**
   - Submit the party enquiry form with visible fields only, clearly marked TEST (name "TEST JUDGE", phone 9999999999, a future date). Skip hidden fields: forms often carry a honeypot that returns a fake success to bots.
   - Confirm a thank-you and a WhatsApp link appear.
   - Then submit once with required fields empty and report what happens.
   - Open an event page and check it has a ticket link or a WhatsApp RSVP.
   - Check the menu is labelled as a sample.
   - Check Reserve, WhatsApp and Directions exist on every page.
   - Check for horizontal overflow (document.documentElement.scrollWidth > innerWidth) on every page at phone size.
4. **Lighthouse** mobile on the home and parties pages of each site, run twice, keeping the median performance:
   `npx -y lighthouse <url> --form-factor=mobile --only-categories=performance,accessibility,best-practices --output=json --output-path=... --chrome-flags="--headless=new" --quiet`
   The tunnels add the same latency to every site.
5. **Score each site 1-10** on:
   - creativity and concept;
   - scroll motion and interactivity;
   - visual polish and craft;
   - does not look AI-generated or templated;
   - mobile experience;
   - content and conversion;
   - technical quality.
   Give 1-3 lines of concrete evidence per score, citing frame or sheet files.
6. **Write JUDGE.md** in the judge folder:
   - the score table and the evidence;
   - the top 5 strengths and top 5 problems per site, each problem with page, viewport and frame file, and how sure you are;
   - Lighthouse numbers and function-check results;
   - a verdict: which site you would show the owner, why, and what it should take from the others.

Use plain dash "-", never the em dash. Be critical and specific; do not give sites equal scores out of politeness. Reply with a short summary of the verdict and the score table.
