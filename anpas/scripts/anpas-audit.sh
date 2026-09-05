#!/usr/bin/env bash
# anpas-audit.sh — Verify ANPAS compliance on a project
# Usage: anpas-audit.sh [project-path]
#        (default: current directory)

set -e

PROJ="${1:-$(pwd)}"

echo "ANPAS Audit — $PROJ"
echo "===================="
echo ""

pass=0
fail=0

check() {
  local desc="$1"
  local path="$2"
  if [ -e "$path" ]; then
    echo "✓ $desc"
    pass=$((pass + 1))
  else
    echo "✗ $desc"
    fail=$((fail + 1))
  fi
}

check ".ai/project-manifest.md"   "$PROJ/.ai/project-manifest.md"
check ".ai/prompt-template.md"    "$PROJ/.ai/prompt-template.md"
check ".ai/workflows.md"          "$PROJ/.ai/workflows.md"
check ".ai/coding-rules.md"       "$PROJ/.ai/coding-rules.md"
check ".ai/review-checklist.md"   "$PROJ/.ai/review-checklist.md"
check "CLAUDE.md"                 "$PROJ/CLAUDE.md"
check "AGENTS.md"                 "$PROJ/AGENTS.md"
check "CHANGELOG.md"              "$PROJ/CHANGELOG.md"
check "docs/decisions/ADR-template.md" "$PROJ/docs/decisions/ADR-template.md"

echo ""
echo "Result: $pass passed, $fail failed"

# Check for STRICT RULE callout in CLAUDE.md
if [ -f "$PROJ/CLAUDE.md" ]; then
  if grep -q "STRICT RULE" "$PROJ/CLAUDE.md"; then
    echo "✓ CLAUDE.md has STRICT RULE callout"
    pass=$((pass + 1))
  else
    echo "✗ CLAUDE.md missing STRICT RULE callout"
    fail=$((fail + 1))
  fi
fi

# Find oversized source files
echo ""
echo "Files exceeding 150 lines:"
over=$(find "$PROJ" -type f \( -name "*.ts" -o -name "*.tsx" \) \
  -not -path "*/node_modules/*" -not -path "*/dist/*" -not -path "*/.next/*" \
  -not -path "*/build/*" -not -path "*/.git/*" \
  | xargs wc -l 2>/dev/null | awk '$1 > 150' | wc -l)
if [ "$over" -gt 0 ]; then
  echo "✗ $over files exceed 150 lines"
  fail=$((fail + 1))
else
  echo "✓ No files exceed 150 lines"
  pass=$((pass + 1))
fi

echo ""

# AI visual vocabulary check (forbidden icons)
echo ""
echo "AI visual vocabulary check (forbidden icons):"
sparkle_hits=0
icon_files=$(find "$PROJ" -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.vue" -o -name "*.svelte" -o -name "*.html" \) 2>/dev/null | grep -vE "$EXCLUDES")
for icon in "Sparkles" "Wand" "Brain" "Robot" "Orb" "Pulse" "Heartbeat" "NetworkNodes"; do
  hits=$(echo "$icon_files" | xargs grep -lE "\b$icon\b" 2>/dev/null | wc -l)
  if [ "$hits" -gt 0 ]; then
    echo "  XX $icon: $hits file(s)"
    sparkle_hits=$((sparkle_hits + hits))
  fi
done

if [ "$sparkle_hits" -gt 0 ]; then
  echo "  $sparkle_hits file(s) use AI-tell icons (forbidden)"
  fail=$((fail + 1))
else
  echo "  OK No AI-tell icon usage found"
  pass=$((pass + 1))
fi

# AI website style check
echo ""
echo "AI website style check (purple gradients, glassmorphism):"
style_hits=0
style_files=$(find "$PROJ" -type f \( -name "*.css" -o -name "*.scss" -o -name "*.tsx" -o -name "*.ts" \) 2>/dev/null | grep -vE "$EXCLUDES")
for style in "purple.*gradient" "violet.*gradient" "glassmorphism" "backdrop-filter.*blur"; do
  hits=$(echo "$style_files" | xargs grep -lE "$style" 2>/dev/null | wc -l)
  if [ "$hits" -gt 0 ]; then
    echo "  XX $style: $hits file(s)"
    style_hits=$((style_hits + hits))
  fi
done
if [ "$style_hits" -gt 0 ]; then
  echo "  $style_hits file(s) use AI website styles (review)"
else
  echo "  OK No AI website style detected"
  pass=$((pass + 1))
fi


echo "Total: $pass passed, $fail failed"
exit $fail