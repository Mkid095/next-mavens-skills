# anpas-init.ps1 — Bootstrap ANPAS into a project
# Usage: .\anpas-init.ps1 [-ProjectPath <path>]
#        (default: current directory)

param(
  [string]$ProjectPath = (Get-Location).Path,
  [string]$SkillsDir   = "$env:LOCALAPPDATA\hermes\skills\software-development\anpas-standard"
)

$ErrorActionPreference = "Stop"

# Resolve paths
$ProjectPath = (Resolve-Path $ProjectPath).Path

if (-not (Test-Path $SkillsDir)) {
  Write-Host "ANPAS skill not found at $SkillsDir" -ForegroundColor Red
  exit 1
}

# Create directories
New-Item -ItemType Directory -Force -Path "$ProjectPath\.ai"             | Out-Null
New-Item -ItemType Directory -Force -Path "$ProjectPath\docs\decisions"  | Out-Null

# Copy templates
$templates = @(
  "project-manifest.md",
  "prompt-template.md",
  "workflows.md",
  "coding-rules.md",
  "review-checklist.md"
)

foreach ($f in $templates) {
  $src = Join-Path $SkillsDir "templates\.ai\$f"
  $dst = Join-Path "$ProjectPath\.ai" $f
  if (Test-Path $src) {
    if (Test-Path $dst) {
      Write-Host "  -> .ai\$f (exists, skipped)" -ForegroundColor DarkGray
    } else {
      Copy-Item $src $dst
      Write-Host "  OK .ai\$f" -ForegroundColor Green
    }
  } else {
    Write-Host "  -- .ai\$f (template missing at $src)" -ForegroundColor Yellow
  }
}

# ADR template
$adrSrc = Join-Path $SkillsDir "references\adr-template.md"
$adrDst = Join-Path "$ProjectPath\docs\decisions\ADR-template.md"
if (Test-Path $adrSrc) {
  if (Test-Path $adrDst) {
    Write-Host "  -> docs\decisions\ADR-template.md (exists, skipped)" -ForegroundColor DarkGray
  } else {
    Copy-Item $adrSrc $adrDst
    Write-Host "  OK docs\decisions\ADR-template.md" -ForegroundColor Green
  }
}

Write-Host ""
Write-Host "Templates copied. Still needed:" -ForegroundColor Cyan
Write-Host "  1. Fill .ai\project-manifest.md with real project content"
Write-Host "  2. Write or patch CLAUDE.md with strict rules"
Write-Host "  3. Write AGENTS.md if missing"
Write-Host "  4. Add CHANGELOG.md entry under [Unreleased]"
Write-Host ""
Write-Host "Or use /anpas (Claude Code skill) for the full automated flow."