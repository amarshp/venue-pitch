"""Trace a logo crop into clean SVGs (dark and light lettering) plus transparent PNGs for decks.

The logo is usually found as a small profile picture. Look first for a large copy overlaid on the venue's own
high-resolution photos (food shots on Google Maps often carry it at 600-900 px) and crop that.

Usage: python trace_logo.py <crop.png> <out_dir> --text "r>225,g>225,b>225" [--accent "r>170,g>95,g<170,b<90"]
  --text:   pixel test for the lettering colour in the crop (default: near-white lettering)
  --accent: optional pixel test for a second, coloured part of the mark (kept in its median colour)
Needs: pip install potracer pillow numpy
"""
import argparse
import pathlib

import numpy as np
import potrace
from PIL import Image


def mask_from(spec, rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    m = np.ones(r.shape, dtype=bool)
    for cond in spec.split(","):
        ch, op, val = cond[0], cond[1], int(cond[2:])
        arr = {"r": r, "g": g, "b": b}[ch]
        m &= (arr > val) if op == ">" else (arr < val)
    return m


def svg_path(mask):
    # potracer traces the False pixels, so invert the mask.
    curves = potrace.Bitmap(~mask).trace(turdsize=30, alphamax=1.0, opticurve=True, opttolerance=0.2)
    d = []
    for c in curves:
        s = c.start_point
        d.append(f"M{s.x:.1f},{s.y:.1f}")
        for seg in c.segments:
            if seg.is_corner:
                d.append(f"L{seg.c.x:.1f},{seg.c.y:.1f}L{seg.end_point.x:.1f},{seg.end_point.y:.1f}")
            else:
                d.append(f"C{seg.c1.x:.1f},{seg.c1.y:.1f} {seg.c2.x:.1f},{seg.c2.y:.1f} {seg.end_point.x:.1f},{seg.end_point.y:.1f}")
        d.append("Z")
    return "".join(d)


ap = argparse.ArgumentParser()
ap.add_argument("crop")
ap.add_argument("out_dir")
ap.add_argument("--text", default="r>225,g>225,b>225")
ap.add_argument("--accent", default="")
ap.add_argument("--name", default="")
a = ap.parse_args()
out = pathlib.Path(a.out_dir)
out.mkdir(parents=True, exist_ok=True)
rgb = np.asarray(Image.open(a.crop).convert("RGB")).astype(int)
text = mask_from(a.text, rgb)
accent = mask_from(a.accent, rgb) if a.accent else np.zeros_like(text)
accent_hex = "#%02x%02x%02x" % tuple(np.median(rgb[accent], axis=0).astype(int)) if accent.any() else None
ys, xs = np.where(text | accent)
x0, x1, y0, y1 = xs.min() - 8, xs.max() + 8, ys.min() - 8, ys.max() + 8
pt, pa = svg_path(text), (svg_path(accent) if accent.any() else "")
label = a.name or "Logo"
for name, fill, ink in [("logo-dark", "#141414", (20, 20, 20)), ("logo-light", "#ffffff", (239, 232, 220))]:
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x0} {y0} {x1 - x0} {y1 - y0}" role="img" aria-label="{label}">'
    svg += f'<path fill="{fill}" fill-rule="evenodd" d="{pt}"/>'
    if pa:
        svg += f'<path fill="{accent_hex}" fill-rule="evenodd" d="{pa}"/>'
    (out / f"{name}.svg").write_text(svg + "</svg>")
    png = np.zeros(rgb.shape[:2] + (4,), dtype=np.uint8)
    png[text] = ink + (255,)
    if accent.any():
        png[accent] = tuple(int(accent_hex[i:i + 2], 16) for i in (1, 3, 5)) + (255,)
    Image.fromarray(png[max(y0, 0):y1, max(x0, 0):x1]).save(out / f"{name}.png")
print(f"wrote logo-dark/light .svg and .png to {out}; accent {accent_hex}. Render both on light and dark before use.")
