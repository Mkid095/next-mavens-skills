# ai-vocab-scan.ps1 — Quick pre-screen for AI vocabulary density
# Usage: ai-vocab-scan.ps1 [-FilePath <path>]
#        ai-vocab-scan.ps1 (reads stdin)
#
# Counts occurrences of common AI vocabulary in the input.
# This is a PRE-SCREEN — not a definitive detector. Use the SKILL.md
# workflow for full analysis with all 23 categories.

param(
  [string]$FilePath
)

# Common AI tells (high-confidence)
$vocab = @(
  'delve', 'delves', 'delved', 'delving',
  'tapestry',
  'testament',
  'pivotal',
  'foster', 'fostering',
  'bolster', 'bolstering',
  'crucial',
  'intricate',
  'landscape',
  'enduring',
  'leverage', 'leveraged', 'leveraging',
  'garner', 'garnered',
  'robust',
  'multifaceted',
  'holistic',
  'paradigm',
  'synergy',
  'seamless', 'seamlessly',
  'streamline', 'streamlining',
  'utilize', 'utilizing', 'utilizes',
  'facilitate', 'facilitates', 'facilitating',
  'endeavor', 'endeavors',
  'embark', 'embarks', 'embarking',
  'realm',
  'ever-evolving',
  'fast-paced',
  'rapidly evolving',
  'ever-changing',
  'dynamic',
  'vibrant',
  'bustling',
  'nestled',
  'stunning',
  'must-visit',
  'distinct',
  'stark',
  'bold',
  'imposing',
  'prominent',
  'pivotal moment',
  'broader trends',
  'lasting legacy',
  'plays a vital role',
  'plays a key role',
  'serves as a testament',
  'stands as a testament',
  'rich tapestry',
  'rich history',
  'evolving landscape',
  'active social media presence',
  'maintains an active social media presence'
)

# Copulative substitutions (separate category)
$copulatives = @(
  'serves as a',
  'stands as a',
  'functions as',
  'operates as',
  'represents a',
  'boasts a',
  'features a',
  'maintains a',
  'offers a'
)

# Em dash
$emDash = [char]0x2014

# Read input
if ($FilePath) {
  if (-not (Test-Path $FilePath)) {
    Write-Host "File not found: $FilePath" -ForegroundColor Red
    exit 1
  }
  $text = Get-Content $FilePath -Raw
} else {
  $text = $input | Out-String
}

if ([string]::IsNullOrWhiteSpace($text)) {
  Write-Host "No input provided. Pipe text or use -FilePath." -ForegroundColor Yellow
  exit 1
}

# Word count
$words = ($text -split '\s+' | Where-Object { $_ }).Count

Write-Host ""
Write-Host "AI Vocabulary Pre-Screen" -ForegroundColor Cyan
Write-Host ("=" * 60)
Write-Host "Word count: $words"
Write-Host ""

# Count vocabulary matches
$vocabHits = @()
foreach ($term in $vocab) {
  $count = ([regex]::Matches($text, [regex]::Escape($term), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
  if ($count -gt 0) {
    $vocabHits += [PSCustomObject]@{ Term = $term; Count = $count }
  }
}

# Count copulatives
$copHits = @()
foreach ($term in $copulatives) {
  $count = ([regex]::Matches($text, [regex]::Escape($term), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
  if ($count -gt 0) {
    $copHits += [PSCustomObject]@{ Term = $term; Count = $count }
  }
}

# Em dash count
$emDashCount = ([regex]::Matches($text, [regex]::Escape($emDash))).Count
$emDashDensity = if ($words -gt 0) { [math]::Round(($emDashCount / $words) * 1000, 2) } else { 0 }

# Total vocab score
$totalVocab = ($vocabHits | Measure-Object -Property Count -Sum).Sum
$totalCop = ($copHits | Measure-Object -Property Count -Sum).Sum

# Density per 1000 words
$vocabDensity = if ($words -gt 0) { [math]::Round(($totalVocab / $words) * 1000, 2) } else { 0 }
$copDensity = if ($words -gt 0) { [math]::Round(($totalCop / $words) * 1000, 2) } else { 0 }

Write-Host "AI vocabulary hits:    $totalVocab ($vocabDensity per 1000 words)" -ForegroundColor $(if ($vocabDensity -gt 8) { "Red" } elseif ($vocabDensity -gt 3) { "Yellow" } else { "Green" })
Write-Host "Copulative hits:        $totalCop ($copDensity per 1000 words)" -ForegroundColor $(if ($copDensity -gt 2) { "Red" } elseif ($copDensity -gt 0.5) { "Yellow" } else { "Green" })
Write-Host "Em dash count:          $emDashCount ($emDashDensity per 1000 words)" -ForegroundColor $(if ($emDashDensity -gt 3) { "Yellow" } else { "Green" })

Write-Host ""
Write-Host "Top vocabulary hits:" -ForegroundColor Cyan
$vocabHits | Sort-Object -Property Count -Descending | Select-Object -First 15 | ForEach-Object {
  Write-Host ("  {0,-45} {1}" -f $_.Term, $_.Count)
}

if ($copHits.Count -gt 0) {
  Write-Host ""
  Write-Host "Copulative hits:" -ForegroundColor Cyan
  $copHits | Sort-Object -Property Count -Descending | ForEach-Object {
    Write-Host ("  {0,-25} {1}" -f $_.Term, $_.Count)
  }
}

# Verdict
Write-Host ""
Write-Host ("=" * 60)
$score = $vocabDensity + ($copDensity * 2) + ($emDashDensity - 3) * 0.5
if ($vocabDensity -gt 15 -or $score -gt 20) {
  Write-Host "Verdict: Likely AI vocabulary signature" -ForegroundColor Red
} elseif ($vocabDensity -gt 5 -or $score -gt 10) {
  Write-Host 'Verdict: Possibly AI - run full SKILL.md analysis' -ForegroundColor Yellow
} else {
  Write-Host "Verdict: Vocabulary looks mostly human" -ForegroundColor Green
}
Write-Host ""
Write-Host "Note: This is a PRE-SCREEN. Run the full detection workflow" -ForegroundColor DarkGray
Write-Host "(/ai-writing-detector or follow SKILL.md) for structural + content analysis." -ForegroundColor DarkGray