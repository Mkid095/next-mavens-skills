Write content that doesn't sound like AI.

Steps:
1. Always load the canonical anti-AI rules first:
   - `~/.claude/skills/human-writing/SKILL.md` (full workflow + quick reference)
   - `~/.claude/skills/ai-writing-detector/references/vocabulary.md`
   - `~/.claude/skills/ai-writing-detector/references/grammar.md`
   - `~/.claude/skills/ai-writing-detector/references/style.md`
   - `~/.claude/skills/ai-writing-detector/references/content.md`
   - `~/.claude/skills/ai-writing-detector/references/structural.md`
2. Do whatever the user asked. Apply the anti-AI rules as you write.
3. Self-check the draft against the rules before declaring done (per SKILL.md).
4. If user said "verify" or wants a score, run:
   `powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\ai-writing-detector\scripts\ai-vocab-scan.ps1" -FilePath <path>`
5. Report what was written.

This skill does NOT change the user's task. It changes HOW the agent writes. The user describes the task (write an about page, draft an email, compose a blog post, etc.); the skill makes the output human-sounding.

Note: The 'no AI visual vocabulary' ANPAS rule also applies — no sparkle, wand, brain, robot, orb, lightning-as-decoration, neural nodes. No purple/violet gradient backgrounds, glassmorphism. Use Lucide icons.
