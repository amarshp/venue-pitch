# Asset pack: photos and logo (phase 3)

Output: `build/assets/raw/` (originals), `build/assets/MANIFEST.md`, `build/assets/logo/`.

## Photos (one agent)
**Sources, roughly best first:**
- The architect's or interior designer's project page, through the Wayback Machine if the site is gone. Studio photos are usually full resolution.
- Dining-app photo galleries. Strip any resize query string from the image URL to get the original.
- Google Maps photos, which often appear embedded on aggregator pages.
- Press features.
- Party-marketplace galleries.
- Event posters on ticketing sites.
- Instagram and Facebook, through a logged-in browser.

**How to collect:**
- Pull `img` src, srcset, background-image and og:image with `browser_evaluate`, and scroll to trigger lazy loading.
- Download with curl, sending a browser User-Agent and the page as Referer.

**MANIFEST:** one row per file with:
- filename, source page and direct URL;
- pixel size;
- what it shows (each space, food, drinks, crowd or event, exterior, logo, menu art, plans);
- a quality note (sharp, blurry, watermark, text overlay, prominent faces).
End with "Best picks" per category and the gaps.

Only real photos of this venue. Never generate or edit images.

## Logo
1. Profile pictures are tiny. Do not upscale them.
2. Look for a large copy first:
   - overlays on the venue's own high-resolution food or interior photos;
   - event posters;
   - menu headers;
   - signage.
3. Crop the largest clean copy and trace it:
   `python <skill>/scripts/trace_logo.py crop.png build/assets/logo --text "<lettering colour test>" --accent "<second colour test>" --name "<Venue>"`.
   Pick the colour tests by sampling the crop. For dark lettering on a light background, use for example `--text "r<60,g<60,b<60"`.
4. Check `logo-dark.svg` on a light background and `logo-light.svg` on a dark one in the browser. Serve them locally (`python -m http.server`), because the browser may block `file:` URLs.
5. The brief tells the arms that the logo is final and must not be redrawn. Ask the owner for the original vector at CP2.
