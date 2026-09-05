#!/usr/bin/env bash
# ai-vocab-scan.sh — Bash fallback for the PowerShell pre-screener
# Usage: ai-vocab-scan.sh <file>
#        cat text | ai-vocab-scan.sh

set -e

VOCAB='delve|tapestry|testament|pivotal|foster|bolster|crucial|intricate|landscape|enduring|leverage|garner|robust|multifaceted|holistic|paradigm|synergy|seamless|streamline|utilize|facilitate|endeavor|embark|realm|ever-evolving|fast-paced|rapidly evolving|ever-changing|dynamic|vibrant|bustling|nestled|stunning|must-visit|distinct|stark|bold|imposing|prominent|active social media presence|maintains an active social media presence|serves as a|stands as a|functions as|operates as|boasts a|features a|maintains a|offers a'

FILE="${1:-/dev/stdin}"

if [ ! -r "$FILE" ] && [ "$FILE" != "/dev/stdin" ]; then
  echo "File not readable: $FILE" >&2
  exit 1
fi

words=$(tr -s ' \t\n' '\n' < "$FILE" | wc -l)

echo ""
echo "AI Vocabulary Pre-Screen (bash)"
echo "============================================================"
echo "Word count: $words"
echo ""

em_count=$(grep -o '—' "$FILE" | wc -l)
em_density=$(awk "BEGIN { printf \"%.2f\", ($em_count / $words) * 1000 }")

vocab_count=$(grep -oiE "\\b($VOCAB)\\b" "$FILE" | wc -l)
vocab_density=$(awk "BEGIN { printf \"%.2f\", ($vocab_count / $words) * 1000 }")

echo "AI vocabulary hits:    $vocab_count ($vocab_density per 1000 words)"
echo "Em dash count:         $em_count ($em_density per 1000 words)"

if (( $(awk "BEGIN { print ($vocab_density > 5) }") )); then
  echo ""
  echo "Verdict: Possibly AI — run full SKILL.md analysis"
elif (( $(awk "BEGIN { print ($vocab_density > 15) }") )); then
  echo ""
  echo "Verdict: Likely AI vocabulary signature"
else
  echo ""
  echo "Verdict: Vocabulary looks mostly human"
fi