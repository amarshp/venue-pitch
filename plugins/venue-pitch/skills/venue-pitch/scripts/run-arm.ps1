# Runs one arm headless in isolation: a throwaway home, so no global CLAUDE.md, skills or plugins load;
# the arm's own .claude/ is the only difference between arms.
# Auth (the throwaway home has no login): set VP_CLAUDE_TOKEN (from `claude setup-token`), or VP_CLAUDE_TOKEN_FILE
# pointing at a file holding it, or ANTHROPIC_API_KEY.
# Output: <root>\<slug>\runs\<tag>-<arm>\transcript.jsonl, and times.txt once the run has fully exited.
param(
  [Parameter(Mandatory)][string]$Slug,
  [Parameter(Mandatory)][string]$Arm,
  [Parameter(Mandatory)][string]$PromptFile,
  [Parameter(Mandatory)][string]$Tag,
  [string]$Model = 'claude-opus-5-5',
  [double]$Budget = 150
)
$ErrorActionPreference = 'Stop'
$root = if ($env:VP_ROOT) { $env:VP_ROOT } else { 'C:\vp' }
$ws = Join-Path $root $Slug; $dir = "$ws\$Arm"; $home_ = "$ws\homes\$Arm"; $out = "$ws\runs\$Tag-$Arm"

$token = $env:VP_CLAUDE_TOKEN
if (-not $token -and $env:VP_CLAUDE_TOKEN_FILE) { $token = (Get-Content -Raw $env:VP_CLAUDE_TOKEN_FILE).Trim() }
if (-not $token -and -not $env:ANTHROPIC_API_KEY) {
  throw "No credentials for the arm: set VP_CLAUDE_TOKEN or VP_CLAUDE_TOKEN_FILE (claude setup-token), or ANTHROPIC_API_KEY"
}

New-Item -ItemType Directory -Force $home_, $out | Out-Null
$env:USERPROFILE = $home_; $env:HOME = $home_
$env:CLAUDE_CONFIG_DIR = "$home_\.claude"
if ($token) { $env:CLAUDE_CODE_OAUTH_TOKEN = $token }   # never printed
$env:PLAYWRIGHT_MCP_OUTPUT_DIR = "$out\playwright"
Set-Location $dir
$start = Get-Date
Get-Content $PromptFile -Raw | claude -p --model $Model --max-budget-usd $Budget `
  --mcp-config "$PSScriptRoot\mcp.json" --strict-mcp-config --dangerously-skip-permissions `
  --output-format stream-json --verbose 2>&1 | Out-File -Encoding utf8 "$out\transcript.jsonl"
"start=$($start.ToString('o')) end=$((Get-Date).ToString('o'))" | Out-File "$out\times.txt"
