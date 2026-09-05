FIDScript self-hosted InstantDB skill — MCP-based backend management for instant.fidscript.com.

When invoked:
1. Read the SKILL.md: `~/.claude/skills/instant-self/SKILL.md`
2. Read the reference files:
   - `references/skill.md` — full 43-tool MCP reference
   - `references/mcp-setup.md` — MCP install per editor
3. Match the user's invocation:
   - `/instant-self` alone → show menu, ask what they want
   - `/instant-self start a new project` → scaffold FIDScript integration, create app via MCP
   - `/instant-self continue this project` → inspect existing config, suggest next step
   - `/instant-self use my existing FIDScript app` → verify MCP connection, read existing config
   - `/instant-self inspect backend` → run MCP list-apps + get-schema + get-perms
   - `/instant-self add <entity>` → generate schema snippet, push via MCP
   - `/instant-self push schema` → MCP push-schema (warns about dry-run first)
   - `/instant-self push schema --dry-run` → MCP push-schema-dry-run
   - `/instant-self query <text>` → show InstaQL pattern, optionally execute via MCP
   - `/instant-self transact <text>` → show transact pattern, optionally execute via MCP
   - `/instant-self create-app` → MCP create-app
   - `/instant-self delete-app <name>` → MCP delete-app (asks confirmation first)
   - `/instant-self list-apps` → MCP list-apps
   - `/instant-self list-webhooks` → MCP list-webhooks
   - `/instant-self create-webhook` → MCP create-webhook
   - `/instant-self backups` → MCP list-backups or create-backup
   - `/instant-self email-template` → MCP get-email-template / update-email-template
   - `/instant-self test-users` → MCP list-test-users / create-test-user / delete-test-user
   - `/instant-self members` → MCP invite-app-member / remove-app-member / update-app-member
   - `/instant-self help` → show full MCP tools reference

Key difference from `instantdb` skill:
- `instantdb` = InstantDB Cloud (instantdb.com) = client SDK + CLI
- `instant-self` = FIDScript self-hosted (instant.fidscript.com) = MCP + client SDK

For client-side code in FIDScript projects, use `@fidscript/instant` (same API as `@instantdb/react`).
For backend management (schema, perms, apps, webhooks), use the MCP tools listed above.

Always:
- Dry-run before push-schema
- Never expose the PAT in code
- Confirm before delete-app
- Use the correct skill for the correct platform