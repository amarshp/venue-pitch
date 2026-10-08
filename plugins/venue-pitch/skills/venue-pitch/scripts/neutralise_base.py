"""Strip create-next-app defaults so every arm starts from the same blank page, and make the site noindex."""
import pathlib
import sys

b = pathlib.Path(sys.argv[1])
(b / "src/app/layout.tsx").write_text('''import type { Metadata } from "next";
import "./globals.css";

// Private pitch demo: never index (also enforced by the X-Robots-Tag header in next.config.ts).
export const metadata: Metadata = {
  title: "Demo",
  robots: { index: false, follow: false },
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
''')
(b / "src/app/page.tsx").write_text("export default function Home() {\n  return <main>Demo</main>;\n}\n")
(b / "src/app/globals.css").write_text('@import "tailwindcss";\n')
(b / "src/app/robots.ts").write_text('''import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return { rules: { userAgent: "*", disallow: "/" } };
}
''')
cfg = b / "next.config.ts"
s = cfg.read_text()
header = '  async headers() {\n    return [{ source: "/:path*", headers: [{ key: "X-Robots-Tag", value: "noindex, nofollow" }] }];\n  },\n'
if "/* config options here */" in s:
    s = s.replace("  /* config options here */\n", header, 1)
else:
    s = s.replace("const nextConfig: NextConfig = {\n", "const nextConfig: NextConfig = {\n" + header, 1)
if "X-Robots-Tag" not in s:
    sys.exit("next.config.ts template changed; add the noindex header by hand")
cfg.write_text(s)
for f in (b / "public").glob("*.svg"):
    f.unlink()
print("neutralised", b)
