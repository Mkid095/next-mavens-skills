Bootstrap ANPAS into the current project.

Steps:
1. Check if `.ai/CLAUDE.md` etc. already exist; if so, ask before overwriting
2. Run PowerShell init script:
   ```
   powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\anpas\scripts\anpas-init.ps1" [-ProjectPath "<cwd>"]
   ```
   (Bash fallback: `bash "$HOME/.claude/skills/anpas/scripts/anpas-init.sh" [<path>]`)
3. Generate `CLAUDE.md` with strict ANPAS rules table + AI entry order (if missing) or patch existing
4. Generate `AGENTS.md` with never/always lists (if missing)
5. Generate `CHANGELOG.md` with [Unreleased] section (if missing)
6. Run `git status` and ask before staging
7. Commit with `feat(anpas): bootstrap AI-native project structure`
8. Report commit hash; DO NOT push without explicit user approval

DO NOT overwrite any existing files. DO NOT modify source code. DO NOT push.

Note: ANPAS now enforces the 'no AI visual vocabulary' rule — no sparkle (✨), magic wand (🪄), brain (🧠), robot (🤖), orb, lightning-as-decoration, neural nodes, heartbeat/pulse, flame, target as AI-decoration. No purple/violet gradient backgrounds, glassmorphism, or pulsing glow. Reserve ✨ ONLY for actual AI features. This is checked by anpas-audit.ps1.
