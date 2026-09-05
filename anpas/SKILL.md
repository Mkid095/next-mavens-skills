---
name: anpas
description: AI-Native Project Architecture Standard — bootstrap, audit, and enforce the ANPAS structure (`.ai/`, `CLAUDE.md`, `AGENTS.md`, `CHANGELOG.md`, `docs/decisions/`) in any project. Use when the user says "install anpas", "set up anpas", "/anpas init", "/anpas audit", "/anpas", or asks to make a project AI-native. Reads canonical spec at `~/AppData/Local/hermes/skills/software-development/anpas-standard/SKILL.md`.
disable-model-invocation: true
allowed-tools: Read Write Bash(git *) Bash(cp *) Bash(mkdir *) Bash(find *) Bash(wc *) Bash(grep *) Bash(ls *) Bash(cat *)
---

# ANPAS — AI-Native Project Architecture Standard

## What This Skill Does

Installs the ANPAS operating layer into the current project:

```
.ai/                         ← AI entry map (READ FIRST)
├── project-manifest.md      ← domains, flows, tech stack
├── prompt-template.md       ← task format
├── workflows.md             ← execution flow
├── coding-rules.md          ← ENFORCEMENT RULES
└── review-checklist.md      ← VERIFICATION CHECKLIST
CLAUDE.md                    ← strict dev rules + AI entry order
AGENTS.md                    ← agent enforcement rules
CHANGELOG.md                 ← mandatory change log
docs/decisions/ADR-template.md ← architecture decision records
```

## Canonical Reference

The full ANPAS standard lives at:
```
~/AppData/Local/hermes/skills/software-development/anpas-standard/
├── SKILL.md              (55K, 926 lines — the canonical spec)
├── templates/.ai/        (5 template files)
├── scripts/              (anpas-init.sh, anpas-audit.sh, verify-skill-updates.sh, plus PowerShell .ps1 variants)
└── references/           (audit logs, ADR templates, failure-mode docs)
```

Always read the canonical SKILL.md first if you need to know *why* a rule exists.

---

## Invocation Patterns

The skill accepts a `$ARGUMENTS` and dispatches based on first token:

| Input | Action |
|-------|--------|
| `/anpas` or `/anpas init` | Install ANPAS into current directory |
| `/anpas init <path>` | Install ANPAS into `<path>` |
| `/anpas audit` | Run audit on current project |
| `/anpas audit <path>` | Run audit on `<path>` |
| `/anpas status` | Show current project's ANPAS compliance |
| `/anpas templates` | List available templates and their purpose |

If no `$ARGUMENTS`, default to `init` in the current working directory.

---

## Mode: INIT (default)

**Goal:** Bootstrap ANPAS into a project without breaking existing content.

### Workflow

1. **Check project state** (read-only, no destructive action):
   ```bash
   # Is .ai/ already there?
   test -d .ai && echo "ANPAS already installed" || echo "needs install"
   # Is this a git repo?
   git rev-parse --is-inside-work-tree 2>/dev/null || echo "not a git repo"
   ```

2. **Read existing content** (preserve, don't overwrite):
   - Read `CLAUDE.md` if it exists — we will PREPEND the strict rules block, not replace
   - Read `AGENTS.md` if it exists — same
   - Check if `CHANGELOG.md` exists — append an "Unreleased" section
   - Check if `docs/decisions/ADR-template.md` exists — skip if so

3. **Inspect the codebase to fill project-manifest.md**:
   ```bash
   # Find tech stack clues
   ls package.json requirements.txt go.mod Cargo.toml pubspec.yaml 2>/dev/null
   # Find domain folders
   ls -d src/* apps/* 2>/dev/null | head -20
   # Check for CLAUDE.md / README patterns
   ls CLAUDE.md README.md SPEC.md ARCHITECTURE.md 2>/dev/null
   ```

4. **Copy templates** from the canonical skill:
   ```powershell
   # PowerShell (Windows native — preferred)
   powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\anpas\scripts\anpas-init.ps1" [-ProjectPath "C:\path\to\project"]
   ```

   Or via bash (git-bash / WSL):
   ```bash
   bash "$HOME/.claude/skills/anpas/scripts/anpas-init.sh" [project-path]
   ```

5. **Fill project-manifest.md with REAL content** (not placeholder):
   - Domain names from the directory structure
   - Tech stack from `package.json` / `pubspec.yaml` / etc.
   - Critical flows from `CLAUDE.md` / `SPEC.md` / `ARCHITECTURE.md` if they exist
   - Existing docs (preserve references, don't duplicate)

6. **Write CLAUDE.md**:
   - If file exists: PATCH it — prepend the ANPAS strict rules block (5 rules table + AI entry order) and append a verification checklist
   - If file does not exist: write the full strict CLAUDE.md from scratch

7. **Write AGENTS.md** (if missing): full enforcement rules with never/always lists

8. **Write CHANGELOG.md** (if missing) OR add an "Unreleased" section under existing file

9. **Stage and commit** (if git repo):
   ```bash
   git add .ai/ CLAUDE.md AGENTS.md CHANGELOG.md docs/decisions/
   git commit -m "feat(anpas): bootstrap AI-native project structure

   - Add .ai/ layer (project-manifest, prompt-template, workflows, coding-rules, review-checklist)
   - [Prepend|Write] CLAUDE.md with strict ANPAS rules and AI entry order
   - [Write|Update] AGENTS.md with enforcement rules
   - [Write|Append] CHANGELOG.md
   - Add docs/decisions/ADR-template.md
   - <project-name>: ANPAS Phase 1 bootstrap — <date>"
   ```

10. **Report** — what was added, what was preserved, commit hash, push status (do NOT push without explicit user approval)

### What NOT to do during init

- ❌ Do NOT overwrite an existing `CLAUDE.md` — PATCH it instead
- ❌ Do NOT overwrite an existing `CHANGELOG.md` — APPEND to it
- ❌ Do NOT delete or rewrite existing source code
- ❌ Do NOT push to remote without user confirmation
- ❌ Do NOT stage files outside the ANPAS scope (no mass `git add .`)
- ❌ Do NOT touch `node_modules/`, `dist/`, `build/`, `.next/`, etc.

---

## Mode: AUDIT

**Goal:** Verify ANPAS compliance on a project.

### Workflow

1. **Read project state**:
   ```bash
   PROJ="$(pwd)"
   ls "$PROJ/.ai/" 2>/dev/null
   ls "$PROJ/CLAUDE.md" "$PROJ/AGENTS.md" "$PROJ/CHANGELOG.md" 2>/dev/null
   ls "$PROJ/docs/decisions/ADR-template.md" 2>/dev/null
   ```

2. **Check each rule** — produce a table:

   | Check | Required | Pass |
   |-------|----------|------|
   | `.ai/project-manifest.md` exists | yes | ✓/✗ |
   | `.ai/coding-rules.md` exists | yes | ✓/✗ |
   | `.ai/review-checklist.md` exists | yes | ✓/✗ |
   | `CLAUDE.md` exists with strict rules table | yes | ✓/✗ |
   | `CLAUDE.md` has AI entry order | yes | ✓/✗ |
   | `AGENTS.md` exists | yes | ✓/✗ |
   | `CHANGELOG.md` exists with "Unreleased" | yes | ✓/✗ |
   | `docs/decisions/ADR-template.md` exists | yes | ✓/✗ |

3. **Run file-size compliance** (if user asks for full audit):
   ```bash
   find "$PROJ" -type f \( -name "*.ts" -o -name "*.tsx" \) \
     -not -path "*/node_modules/*" -not -path "*/dist/*" -not -path "*/.next/*" \
     | xargs wc -l 2>/dev/null | awk '$1 > 150 {print}'
   ```

4. **Report findings** — what's missing, what's over 150 lines, what to fix next.

---

## Mode: STATUS

**Goal:** Quick glance at current project's ANPAS layer.

Read the 5 `.ai/` files and report:
- Project name + version (from project-manifest.md)
- Domains covered
- Tech stack
- Date of last bootstrap

---



**Note:** The canonical template `coding-rules.md` includes the "no AI visual vocabulary" rule by default. This bans:
- Icons: ✨ Sparkles, 🪄 Wand, 🧠 Brain, 🤖 Robot, 🪐 Orb, ❤️ Heartbeat, 🌐 Network nodes (any AI-decoration icons)
- Visual styles: purple/violet gradient backgrounds, glassmorphism, pulsing glow/shimmer
- Reserve ✨ ONLY for actual AI features (Google/AWS/Red Hat pattern)

This rule is propagated to every project on ANPAS install and detected by `anpas-audit.ps1`. If the user wants to relax it, they edit the resulting `.ai/coding-rules.md` directly.

## Verification Checklist (run before declaring done)

- [ ] `.ai/` has all 5 template files (or explicitly noted which were already there)
- [ ] `CLAUDE.md` has the STRICT RULE callout + Non-Negotiable Rules table + AI Entry Order
- [ ] `AGENTS.md` has never/always lists
- [ ] `CHANGELOG.md` has an entry under [Unreleased] (created OR appended, not overwritten)
- [ ] `docs/decisions/ADR-template.md` exists
- [ ] NO existing source code was modified
- [ ] NO existing CLAUDE.md content was deleted (only appended/prepended)
- [ ] If git repo: commit message follows `feat(anpas):` format
- [ ] If git repo: did NOT push to remote without user approval
- [ ] Reported file list + commit hash to user