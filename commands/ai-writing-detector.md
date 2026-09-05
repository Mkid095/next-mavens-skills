Detect signs of AI-generated writing in text the user provides.

Steps:
1. If user provided text inline, use it. If they said "this file" or named a file, read it.
2. Always read the canonical taxonomy first:
   `~/.claude/skills/ai-writing-detector/SKILL.md`
3. Read all 6 reference files in `~/.claude/skills/ai-writing-detector/references/` (vocabulary.md, grammar.md, style.md, content.md, structural.md, outdated.md, ineffective.md)
4. For pre-screening, optionally run:
   ```
   powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\ai-writing-detector\scripts\ai-vocab-scan.ps1" -FilePath "<path>"
   ```
5. Scan all 23 categories (A-W) per the SKILL.md workflow
6. Produce the report:
   - Verdict (Likely AI / Possibly AI / Mostly human / Inconclusive)
   - Score (normalized per 1000 words)
   - Per-category matches with quoted phrase + location
   - Suggested human rewrites for each match
   - Honest limitations note
7. If user provided text inline, do not save it to disk.

DO NOT accuse the user of generating AI text — the report is a detection aid, not a judgment. Frame as "heuristic" and let the user decide.

Note: Beyond text patterns, the detector also flags the AI visual vocabulary in any UI description: sparkle, wand, brain, robot, orb, etc.
