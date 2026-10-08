# Creates the build workspace for one venue: <root>\<slug>\base, a neutral Next.js scaffold (no font, no design, noindex).
# <root> is $env:VP_ROOT (default C:\vp). Keep it outside synced folders (node_modules) and outside your user folder:
# Claude Code reads CLAUDE.md files from parent folders, which would leak into every arm.
param([Parameter(Mandatory)][string]$Slug)
$ErrorActionPreference = 'Stop'
$root = if ($env:VP_ROOT) { $env:VP_ROOT } else { 'C:\vp' }
$ws = Join-Path $root $Slug
New-Item -ItemType Directory -Force $ws, "$ws\homes", "$ws\runs", "$ws\serve", "$ws\bin" | Out-Null
if (-not (Test-Path "$ws\bin\cloudflared.exe")) {
  # Standalone exe: no installer, no elevation prompt.
  Invoke-WebRequest https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe -OutFile "$ws\bin\cloudflared.exe"
}
if (Test-Path "$ws\base") { "base exists: $ws\base"; exit 0 }
Set-Location $ws
npx -y create-next-app@latest base --ts --tailwind --eslint --app --src-dir --use-npm --import-alias "@/*" --turbopack --yes | Out-Null
python "$PSScriptRoot\neutralise_base.py" "$ws\base"
if ($LASTEXITCODE -ne 0) { throw "neutralise_base.py failed" }
Set-Location "$ws\base"
npx next build | Select-String "Compiled|rror" | Select-Object -First 3
git add -A
git commit -qm "Neutral Next.js scaffold with noindex"
"base ready: $ws\base"
