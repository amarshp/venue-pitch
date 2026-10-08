# Builds and serves the given arms (production `next start`), opens a Cloudflare quick tunnel per arm,
# and writes blind links: serve\blind-links.txt (for the person judging) and serve\blind-mapping.txt (hidden until judged).
# -Restart: restarts only the tunnels and rewrites the links with the same blind labels.
# Usage: serve.ps1 -Slug <slug> -Arms "b:3101,c:3102,d:3103" [-Restart]
param([Parameter(Mandatory)][string]$Slug, [Parameter(Mandatory)][string]$Arms, [switch]$Restart)
$ErrorActionPreference = 'Stop'
$root = if ($env:VP_ROOT) { $env:VP_ROOT } else { 'C:\vp' }
$ws = Join-Path $root $Slug; $serve = "$ws\serve"
New-Item -ItemType Directory -Force $serve | Out-Null
$list = $Arms -split ',' | ForEach-Object { $a, $p = $_ -split ':'; @{ arm = $a; port = [int]$p } }

if (-not $Restart) {
  foreach ($x in $list) {
    Set-Location "$ws\$($x.arm)"
    npm run build 2>&1 | Select-String "rror|Compiled" | Select-Object -First 3
    Start-Process cmd -WindowStyle Hidden -WorkingDirectory "$ws\$($x.arm)" -ArgumentList '/c', "npx next start -p $($x.port) > $serve\next-$($x.arm).log 2>&1"
  }
  # Random blind labels, assigned once per serve; -Restart keeps them.
  $labels = 'X', 'Y', 'Z', 'W'
  $shuffled = @($list.arm | Sort-Object { Get-Random })
  $map = for ($i = 0; $i -lt $shuffled.Count; $i++) { "$($labels[$i]) = arm $($shuffled[$i])" }
  $map | Set-Content "$serve\blind-mapping.txt"
}

Get-Process cloudflared -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq "$ws\bin\cloudflared.exe" } | Stop-Process -Force
foreach ($x in $list) {
  Start-Process "$ws\bin\cloudflared.exe" -WindowStyle Hidden -ArgumentList 'tunnel', '--no-autoupdate', '--url', "http://localhost:$($x.port)" -RedirectStandardError "$serve\tunnel-$($x.arm).log"
}
Start-Sleep 30
$urls = @{}
foreach ($x in $list) {
  $urls[$x.arm] = Select-String -Path "$serve\tunnel-$($x.arm).log" -Pattern 'https://[a-z0-9-]+\.trycloudflare\.com' | Select-Object -First 1 | ForEach-Object { $_.Matches[0].Value }
}
$links = foreach ($line in Get-Content "$serve\blind-mapping.txt") {
  $label, $arm = $line -split ' = arm '
  $u = $urls[$arm.Trim()]
  $ok = try { (Invoke-WebRequest $u -UseBasicParsing -TimeoutSec 30).StatusCode } catch { "FAIL" }
  "$($label.Trim()): $u   ($ok)"
}
$links | Set-Content "$serve\blind-links.txt"
$links
