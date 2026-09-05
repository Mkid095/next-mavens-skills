# anpas-audit.ps1 — Verify ANPAS compliance on a project
# Usage: .\anpas-audit.ps1 [-ProjectPath <path>]
#        (default: current directory)

param(
  [string]$ProjectPath = (Get-Location).Path
)

$ProjectPath = (Resolve-Path $ProjectPath).Path

Write-Host ""
Write-Host "ANPAS Audit -- $ProjectPath" -ForegroundColor Cyan
Write-Host ("=" * 60)
Write-Host ""

$pass = 0
$fail = 0

function Check-Exists {
  param([string]$Description, [string]$Path)
  if (Test-Path $Path) {
    Write-Host "  OK  $Description" -ForegroundColor Green
    $script:pass++
  } else {
    Write-Host "  XX  $Description" -ForegroundColor Red
    $script:fail++
  }
}

# Required files
Check-Exists ".ai\project-manifest.md"   "$ProjectPath\.ai\project-manifest.md"
Check-Exists ".ai\prompt-template.md"    "$ProjectPath\.ai\prompt-template.md"
Check-Exists ".ai\workflows.md"          "$ProjectPath\.ai\workflows.md"
Check-Exists ".ai\coding-rules.md"       "$ProjectPath\.ai\coding-rules.md"
Check-Exists ".ai\review-checklist.md"   "$ProjectPath\.ai\review-checklist.md"
Check-Exists "CLAUDE.md"                 "$ProjectPath\CLAUDE.md"
Check-Exists "AGENTS.md"                 "$ProjectPath\AGENTS.md"
Check-Exists "CHANGELOG.md"              "$ProjectPath\CHANGELOG.md"
Check-Exists "docs\decisions\ADR-template.md" "$ProjectPath\docs\decisions\ADR-template.md"

Write-Host ""
Write-Host "Result: $pass passed, $fail failed" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })

# STRICT RULE callout check
if (Test-Path "$ProjectPath\CLAUDE.md") {
  $content = Get-Content "$ProjectPath\CLAUDE.md" -Raw
  if ($content -match "STRICT RULE") {
    Write-Host "  OK  CLAUDE.md has STRICT RULE callout" -ForegroundColor Green
    $pass++
  } else {
    Write-Host "  XX  CLAUDE.md missing STRICT RULE callout" -ForegroundColor Red
    $fail++
  }
}

# 150-line check
Write-Host ""
Write-Host "Files exceeding 150 lines (excluding node_modules/dist/.next):" -ForegroundColor Cyan

$over = 0
$exclude = @("node_modules", "dist", ".next", "build", ".git", ".claude")
$files = Get-ChildItem -Path $ProjectPath -Recurse -Include "*.ts","*.tsx" -File -ErrorAction SilentlyContinue |
  Where-Object {
    $path = $_.FullName
    -not ($exclude | Where-Object { $path -like "*\$_\*" })
  }

foreach ($f in $files) {
  $lines = (Get-Content $f.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
  if ($lines -gt 150) {
    Write-Host "  XX  $($f.FullName.Replace($ProjectPath, '.')) -- $lines lines" -ForegroundColor Yellow
    $over++
  }
}

if ($over -gt 0) {
  Write-Host "  $over file(s) exceed 150 lines" -ForegroundColor Yellow
  $fail++
} else {
  Write-Host "  OK  No files exceed 150 lines" -ForegroundColor Green
  $pass++
}

# AI visual vocabulary check (forbidden AI tell icons)
Write-Host ""
Write-Host "AI visual vocabulary check (forbidden icons):" -ForegroundColor Cyan

$iconPatterns = @(
  @{ Name = "Sparkles"; Pattern = "Sparkles" },
  @{ Name = "Sparkle emoji"; Pattern = "✨" },
  @{ Name = "Wand"; Pattern = "(?<!From)Wand" },
  @{ Name = "Brain"; Pattern = "(?<![a-z])Brain(?!storming)" },
  @{ Name = "Robot"; Pattern = "Robot" },
  @{ Name = "Orb"; Pattern = "(?<!D)[Oo]rb(?!it)" },
  @{ Name = "Network nodes"; Pattern = "NetworkNodes|network.?nodes" },
  @{ Name = "Pulse"; Pattern = "(?<!Im)pulse" },
  @{ Name = "Heartbeat"; Pattern = "Heartbeat" }
)

$totalHits = 0
$srcFiles = Get-ChildItem -Path $ProjectPath -Recurse -Include "*.ts","*.tsx","*.js","*.jsx","*.vue","*.svelte","*.html" -File -ErrorAction SilentlyContinue |
  Where-Object {
    $path = $_.FullName
    -not ($exclude | Where-Object { $path -like "*\$_\*" })
  }

foreach ($icon in $iconPatterns) {
  $hits = 0
  $examples = @()
  foreach ($f in $srcFiles) {
    $fileContent = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($fileContent -match $icon.Pattern) {
      $hits++
      if ($examples.Count -lt 3) {
        $examples += $f.FullName.Replace($ProjectPath, '.')
      }
    }
  }
  if ($hits -gt 0) {
    Write-Host "  XX $($icon.Name): $hits file(s) - $($examples -join ', ')" -ForegroundColor Yellow
    $totalHits += $hits
  }
}

if ($totalHits -gt 0) {
  Write-Host "  $totalHits file(s) use AI-tell icons (forbidden)" -ForegroundColor Yellow
  $fail++
} else {
  Write-Host "  OK No AI-tell icon usage found" -ForegroundColor Green
  $pass++
}

# AI website style check (purple gradients, glassmorphism in CSS)
Write-Host ""
Write-Host "AI website style check (purple gradients, glassmorphism):" -ForegroundColor Cyan

$stylePatterns = @(
  @{ Name = "Purple gradient"; Pattern = "(?i)(purple|violet|indigo).*gradient|gradient.*(purple|violet|indigo)" },
  @{ Name = "Glassmorphism"; Pattern = "(?i)glassmorphism|backdrop.?blur.*rounded|backdrop-filter.*blur" }
)

$styleHits = 0
$styleFiles = Get-ChildItem -Path $ProjectPath -Recurse -Include "*.css","*.scss","*.tsx","*.ts" -File -ErrorAction SilentlyContinue |
  Where-Object {
    $path = $_.FullName
    -not ($exclude | Where-Object { $path -like "*\$_\*" })
  }

foreach ($style in $stylePatterns) {
  $hits = 0
  foreach ($f in $styleFiles) {
    $fileContent = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($fileContent -match $style.Pattern) {
      $hits++
    }
  }
  if ($hits -gt 0) {
    Write-Host "  XX $($style.Name): $hits file(s)" -ForegroundColor Yellow
    $styleHits += $hits
  }
}

if ($styleHits -gt 0) {
  Write-Host "  $styleHits file(s) use AI website styles (review for purple/glassmorphism)" -ForegroundColor Yellow
  # Note: don't increment fail since this might be intentional
} else {
  Write-Host "  OK No AI website style detected" -ForegroundColor Green
  $pass++
}

Write-Host ""
Write-Host ("=" * 60)
Write-Host "Total: $pass passed, $fail failed" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })

exit $fail