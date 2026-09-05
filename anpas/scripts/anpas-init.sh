#!/usr/bin/env bash
# anpas-init.sh — Bootstrap ANPAS into a project
# Usage: anpas-init.sh [project-path]
#        (default: current directory)

set -e

PROJ="${1:-$(pwd)}"
SKILLS_DIR="${ANPAS_SKILLS_DIR:-$HOME/AppData/Local/hermes/skills/software-development/anpas-standard}"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "❌ ANPAS skill not found at $SKILLS_DIR"
  exit 1
fi

mkdir -p "$PROJ/.ai" "$PROJ/docs/decisions"

# Copy templates
for f in project-manifest.md prompt-template.md workflows.md coding-rules.md review-checklist.md; do
  if [ ! -f "$PROJ/.ai/$f" ]; then
    cp "$SKILLS_DIR/templates/.ai/$f" "$PROJ/.ai/$f"
    echo "✓ .ai/$f"
  else
    echo "→ .ai/$f (exists, skipped)"
  fi
done

# ADR template
if [ ! -f "$PROJ/docs/decisions/ADR-template.md" ]; then
  cp "$SKILLS_DIR/references/adr-template.md" "$PROJ/docs/decisions/ADR-template.md"
  echo "✓ docs/decisions/ADR-template.md"
else
  echo "→ docs/decisions/ADR-template.md (exists, skipped)"
fi

echo ""
echo "Templates copied. You still need to:"
echo "  1. Fill .ai/project-manifest.md with real project content"
echo "  2. Write or patch CLAUDE.md with strict rules"
echo "  3. Write AGENTS.md if missing"
echo "  4. Add CHANGELOG.md entry under [Unreleased]"
echo ""
echo "Or use /anpas (Claude Code skill) for the full automated flow."