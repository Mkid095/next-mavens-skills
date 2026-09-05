---
name: teammates
description: Spawn a real agent team with named teammates to work in parallel on complex multi-part tasks. Triggers on /teammates, "use teammates", "spawn a team", "agent team", or any request to run independent tasks in parallel across multiple sessions with inter-agent messaging.
---

# Teammates — Spawn and Orchestrate Agent Teams

Use this skill to coordinate **real agent teams** (separate Claude Code sessions that message each other), NOT subagents (background agents that only report back to a single session).

> **Documentation:** https://code.claude.com/docs/llms.txt
> Fetch the docs index above before exploring sub-pages. The relevant page is `agent-teams.md` (orchestration) and `sub-agents.md` (contrast).

---

## The Key Distinction

| | Agent Team (this skill) | Subagent (Task tool) |
|---|---|---|
| Identity | Named teammates you can message | Background process, no name |
| Communication | Teammates message each other | Only reports back to lead |
| Context | Independent context window per teammate | Shares lead's context |
| Coordination | Shared task list + SendMessage | One-shot return |
| Use when | Parallel work that benefits from cross-checking | Single-purpose delegated tasks |

---

## Trigger Phrases

This skill auto-loads when the user says:
- `/teammates` — direct invocation
- "spawn a team" / "use teammates" / "agent team"
- "run these in parallel" + mentions of multiple workers
- Requests to coordinate N independent investigations/features

If the user just says "do these in parallel" without naming or coordination needs, default subagents are usually fine.

---

## Spawn Format (MUST FOLLOW EXACTLY)

To spawn a real agent team, the lead's prompt MUST include:
1. The phrase **"Spawn an agent team with teammates named"** — this is the trigger phrase
2. Each teammate's **kebab-case name** (so you can message them directly via SendMessage)
3. Each teammate's **specific task domain** (one-line scope)
4. Instruction to **message each other** on overlapping findings

**Correct:**
```
Spawn an agent team with teammates named offline-audit, ux-audit, and arch-audit
to audit the desktop app comprehensively.

- offline-audit: investigate offline-first data storage, sync queue design, and conflict handling.
- ux-audit: investigate UI/UX quality — navigation, loading states, error states, accessibility.
- arch-audit: investigate codebase structure, module boundaries, and technical debt.

Have them message each other on overlapping findings. Report a synthesized summary when done.
```

**Incorrect (triggers subagents, not team):**
```
Run these 3 audits in parallel using subagents.
```
Using the word "subagents" makes Claude reach for the Task tool. Always use the exact phrasing above.

---

## Coordination Rules

1. **Exclusive file ownership** — two teammates touching the same file = conflict. Split by feature/module, not by line.
2. **Teammates message the lead when done** — the lead synthesizes findings into one report.
3. **Shared schemas first** — if two teammates will both touch the same concept (e.g., a TypeScript interface), have one design and broadcast it before the other implements.
4. **Monitor via agent panel** — arrow keys select teammate, Enter to view transcript, Esc to interrupt.
5. **Use isolation: "worktree"** when teammates will edit files in parallel — each gets its own branch.

---

## If Claude Uses Subagents Instead

If Claude spawns "general-purpose" or "background agents" instead of named teammates, the user should say EXACTLY:

> "No, use a real agent team with named teammates, not subagents. Spawn teammates named [name1], [name2]."

---

## Prerequisite

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` must be set in `~/.claude/settings.json`. Already enabled in this user's config.

---

## Quick Recipe for the Main Agent

When `/teammates` is invoked, the lead should:

1. **Read** the user's task and identify 2–5 independent work streams.
2. **Reframe** the prompt into the spawn format above with kebab-case names.
3. **Call Agent** with `isolation: "worktree"` for each teammate that will edit files.
4. **Wait for completion notifications** (one per teammate).
5. **Synthesize** findings into a single concise report — don't dump raw teammate outputs.
6. **Hand back to user** with the synthesized summary.

If the user did not give enough structure to split cleanly, ASK before spawning. Don't invent teammates out of vague requests.

---

#### ANPAS rule reminder

When teammates generate UI or visual content, they must follow ANPAS rules — including the **no AI visual vocabulary** rule:
- No sparkle (✨), magic wand (🪄), brain (🧠), robot (🤖), orb, lightning-as-decoration, neural nodes
- No purple/violet gradient backgrounds, glassmorphism, pulsing glow/shimmer
- Reserve ✨ ONLY for actual AI features (not every action)

If a teammate generates UI with these patterns, that's a violation — flag and have them redo.
