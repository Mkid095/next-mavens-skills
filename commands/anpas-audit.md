Run ANPAS compliance audit on the current project.

Steps:
1. Execute PowerShell audit script:
   ```
   powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\anpas\scripts\anpas-audit.ps1" [-ProjectPath "path"]
   ```
   (Bash fallback: `bash "$HOME/.claude/skills/anpas/scripts/anpas-audit.sh" [path]`)
2. Report findings as a table: Check / Status / Evidence
3. Highlight any failures and suggest fixes

Note: ANPAS now enforces the 'no AI visual vocabulary' rule — no sparkle (✨), magic wand (🪄), brain (🧠), robot (🤖), orb, lightning-as-decoration, neural nodes, heartbeat/pulse, flame, target as AI-decoration. No purple/violet gradient backgrounds, glassmorphism, or pulsing glow. Reserve ✨ ONLY for actual AI features. This is checked by anpas-audit.ps1.
