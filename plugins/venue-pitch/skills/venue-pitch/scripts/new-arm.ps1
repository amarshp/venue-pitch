# Creates one design arm: clones base, copies the shared pack, fills the brief, installs the arm's skills, commits.
# -Skills: comma list of impeccable, frontend-design (empty = brief only).
# -Concept: a concept file (Markdown) appended to the brief as this arm's direction; omit to give every arm the same brief.
param(
  [Parameter(Mandatory)][string]$Slug,
  [Parameter(Mandatory)][string]$Arm,
  [Parameter(Mandatory)][int]$Port,
  [Parameter(Mandatory)][string]$PackDir,   # <docs>\build: BRIEF.md, PRODUCT.md, content\, assets\raw, assets\logo, assets\MANIFEST.md
  [string]$Skills = '',
  [string]$Concept = ''
)
$ErrorActionPreference = 'Stop'
$root = if ($env:VP_ROOT) { $env:VP_ROOT } else { 'C:\vp' }
$ws = Join-Path $root $Slug; $dir = "$ws\$Arm"; $home_ = "$ws\homes\$Arm"
if (Test-Path $dir) { throw "arm exists: $dir" }
git clone -q "$ws\base" $dir
New-Item -ItemType Directory -Force "$dir\content", "$dir\public\assets\photos", "$dir\public\assets\logo", $home_ | Out-Null
Copy-Item "$PackDir\content\*" "$dir\content\"
Copy-Item "$PackDir\assets\raw\*" "$dir\public\assets\photos\"
Copy-Item "$PackDir\assets\logo\*.svg" "$dir\public\assets\logo\"
Copy-Item "$PackDir\assets\MANIFEST.md" "$dir\public\assets\MANIFEST.md"
Copy-Item "$PackDir\PRODUCT.md" "$dir\PRODUCT.md"
$brief = (Get-Content "$PackDir\BRIEF.md" -Raw).Replace('{{PORT}}', "$Port").Replace('{{ARM_DIR}}', $dir)
if ($Concept) { $brief += "`n## Your creative direction`n`n" + (Get-Content $Concept -Raw) }
[IO.File]::WriteAllText("$dir\BRIEF.md", $brief)
Set-Location $dir
git add -A
git commit -qm "Shared brief, product notes, content and asset pack"
foreach ($s in ($Skills -split ',' | Where-Object { $_ })) {
  switch ($s.Trim()) {
    'impeccable' {
      # Throwaway home so the installer cannot touch your real ~/.claude.
      $realProfile = $env:USERPROFILE; $realHome = $env:HOME
      $env:USERPROFILE = $home_; $env:HOME = $home_
      npx -y impeccable install --providers=claude --scope=project | Select-Object -Last 2
      $env:USERPROFILE = $realProfile; $env:HOME = $realHome
      "impeccable version: $(Get-Content .claude\skills\impeccable\scripts\VERSION)"
    }
    'frontend-design' {
      # From Anthropic's official plugin marketplace (add it with: /plugin marketplace add anthropics/claude-plugins-official).
      $src = "$env:USERPROFILE\.claude\plugins\marketplaces\claude-plugins-official\plugins\frontend-design\skills\frontend-design"
      if (-not (Test-Path $src)) { throw "frontend-design not found at $src; add the claude-plugins-official marketplace first" }
      New-Item -ItemType Directory -Force .claude\skills | Out-Null
      Copy-Item -Recurse -Force $src .claude\skills\
    }
    default { throw "unknown skill: $s" }
  }
}
"arm $Arm ready at $dir (port $Port, skills: $Skills)"
