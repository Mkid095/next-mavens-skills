Parallel multi-agent orchestration via the Teammates skill.

When invoked:
1. Read the skill: `~/.claude/skills/teammates/SKILL.md` (and any references/* files it points to)
2. Identify the parallel streams needed for the user's task
3. Dispatch via `delegate_task` (parallel up to 3 concurrent; max_spawn_depth=1 = leaf subagents only)
4. Pass all required context to each subagent — subagents have no memory of this conversation
5. Wait for results, then verify each subagent's claims independently before reporting (subagent summaries are self-reports, not verified facts)
6. For external side-effects (HTTP POST/PUT, remote writes, file creation, publishing), require a verifiable handle (URL, ID, absolute path, HTTP status) and verify it yourself

Hard rules:
- Never use delegate_task for a single tool call or mechanical multi-step work with no reasoning needed
- Never ask subagents to call `clarify` (they cannot)
- Leaf subagents cannot nest delegation in this profile (max_spawn_depth=1)
- Return subagent model honors parent model unless `delegation.provider`/`delegation.model` is pinned in config.yaml
- Live transcripts available at `cache/delegation/live/<delegation_id>/` for diagnostics

Verify before reporting: do NOT trust subagent "all done" / "uploaded successfully" claims without re-running the actual command yourself.