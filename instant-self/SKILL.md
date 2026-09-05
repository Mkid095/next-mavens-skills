---
name: instant-self
description: FIDScript Self-Hosted InstantDB MCP — 43 backend management tools via `fidscript/instant-mcp@0.4.1`. Use when working with FIDScript self-hosted at instant.fidscript.com — app lifecycle (create, list, delete), schema push/dry-run, permissions push, InstaQL queries, transactions, file storage, webhooks, backups, email templates, sender verification, orgs, members, test users. Trigger on `/instant-self`, "fidscript", "FIDScript", "self-hosted instant", "instant.fidscript.com", "apiinstant.fidscript.com", "instant-self MCP", or any request to manage a self-hosted FIDScript/InstronDB backend.
disable-model-invocation: true
allowed-tools: Read Write Bash(npx -y fidscript/instant-mcp *) Bash(claude mcp *) Bash(claude mcp list) Bash(claude mcp add *)
---

# FIDScript Self-Hosted InstantDB (`instant-self`)

FIDScript is the self-hosted version of InstantDB, running at `instant.fidscript.com` with API at `apiinstant.fidscript.com`. It uses the same data model and API as InstantDB Cloud, but is **managed via the FIDScript MCP** (`fidscript/instant-mcp@0.4.1`) rather than a CLI or web dashboard.

This skill gives any AI coding agent the ability to create, configure, inspect, and develop FIDScript applications directly from the editor.

---

## Two platforms — which one are you using?

| | FIDScript (self-hosted) | InstantDB Cloud |
|---|---|---|
| **URL** | `instant.fidscript.com` | `instantdb.com` |
| **API** | `apiinstant.fidscript.com` | `api.instantdb.com` |
| **Client SDK** | `@fidscript/instant` (same API) | `@instantdb/react` |
| **Backend management** | MCP: `fidscript/instant-mcp` | CLI: `instant-cli` |
| **This skill** | `instant-self` | `instantdb` |

> If the user is using InstantDB Cloud at instantdb.com, use the `instantdb` skill instead.

---

## Invocation

| Input | Action |
|-------|--------|
| `/instant-self` (no prompt) | Show menu + ask what to do |
| `/instant-self start a new project` | Scaffold FIDScript integration + create app via MCP |
| `/instant-self continue this project` | Inspect existing project config, suggest next step |
| `/instant-self use my existing FIDScript app` | Read existing app config, verify MCP connection |
| `/instant-self inspect backend` | List apps, show schema and perms for the active app |
| `/instant-self add <entity>` | Generate schema snippet + push via MCP |
| `/instant-self push schema` | Run `push-schema` via MCP (warns about dry-run first) |
| `/instant-self push schema --dry-run` | Run `push-schema-dry-run` to preview changes |
| `/instant-self query <text>` | Show InstaQL pattern, optionally execute via MCP `query` |
| `/instant-self transact <text>` | Show `db.transact` pattern, optionally execute via MCP `transact` |
| `/instant-self create-app` | Run MCP `create-app` |
| `/instant-self delete-app <name>` | Run MCP `delete-app` (asks for confirmation first) |
| `/instant-self list-apps` | Run MCP `list-apps` |
| `/instant-self list-webhooks` | Run MCP `list-webhooks` |
| `/instant-self create-webhook` | Run MCP `create-webhook` |
| `/instant-self backups` | Run MCP `list-backups` or `create-backup` |
| `/instant-self email-template` | Get/update email template via MCP |
| `/instant-self test-users` | List/create/delete test users |
| `/instant-self members` | List/invite/remove org or app members |
| `/instant-self help` | Show full MCP tools reference |

---

## Workflow

### 1. Load context

Always read `references/skill.md` first — it contains the MCP tools reference and all 43 FIDScript MCP tools. Then follow this decision tree:

**Does the project have existing FIDScript config?**
- Look for `fidscript/`, `instant/`, `instantDb.ts`, `.env.local` with `VITE_INSTANT_APP_ID`, `instant.schema.ts`, `instant.perms.ts`
- Check `package.json` for `@fidscript/instant`
- Read any existing `CLAUDE.md` or `fidscript.md` in the project

**Is MCP connected?**
- Ask the user to run: `claude mcp list`
- Or check: does `claude mcp list` show `instant-self`?
- If not → guide through MCP install (see `references/mcp-setup.md`)

### 2. Set up MCP (if needed)

The MCP requires three environment variables:
- `INSTANT_ACCESS_TOKEN` — personal access token (starts with `per_`)
- `INSTANT_API_URI` — `apiinstant.fidscript.com` (self-hosted default)
- `INSTANT_APP_ID` — optional; can be overridden per tool call

```bash
# Claude Code
claude mcp add instant-self \
  -e INSTANT_ACCESS_TOKEN=<YOUR_PAT> \
  -e INSTANT_API_URI=apiinstant.fidscript.com \
  -e INSTANT_APP_ID=<YOUR_APP_ID> \
  -- npx -y fidscript/instant-mcp@0.4.1
```

For other editors: see `references/mcp-setup.md`.

### 3. Get the PAT

1. Go to **Dashboard → User Settings → Personal Access Tokens**
2. Click "Create New Token"
3. Copy the token — it starts with `per_`

### 4. Execute via MCP tools

Use the MCP tools for backend management (schema, perms, apps, webhooks, etc.). Use the SDK (`@fidscript/instant`) for client-side queries and transactions in the app code.

**MCP tools** (for backend management):
```
learn, query, transact, get-schema, push-schema, push-schema-dry-run,
get-perms, push-perms, list-apps, get-app, create-app, delete-app,
list-files, delete-file, get-upload-url, get-download-url,
list-webhooks, create-webhook, update-webhook, delete-webhook,
enable-webhook, disable-webhook, get-webhook-events, resend-webhook-event,
list-backups, create-backup, delete-backup, list-backup-jobs, get-backup-job,
cancel-backup-job, list-backup-files, get-backup-file-url,
list-test-users, create-test-user, delete-test-user,
get-email-template, update-email-template, send-test-email,
get-sender-verification, send-sender-verification, verify-sender-code,
list-orgs, get-org, list-org-apps,
invite-app-member, remove-app-member, update-app-member
```

**SDK** (for client-side React/JS code):
```typescript
import { db } from '@fidscript/instant';

// Query
const { isLoading, error, data } = db.useQuery({ posts: {} });

// Transact
db.transact([db.tx.posts[id()].create({ title: 'New post' })]);

// Auth (magic code)
await db.auth.sendMagicCode({ email: 'user@example.com' });
await db.auth.signInWithMagicCode({ email, code });
```

### 5. Schema workflow

```typescript
// 1. Draft schema locally (instant.schema.ts)
const _schema = i.schema({
  entities: {
    posts: i.entity({
      title: i.string(),
      body: i.string(),
    }),
  },
});

// 2. Dry-run first
MCP: push-schema-dry-run({ schema: _schema, appId })

// 3. If looks good, apply
MCP: push-schema({ schema: _schema, appId })
```

### 6. Report

Always tell the user:
- What was done
- What env vars to set (never expose the PAT)
- How to verify: `claude mcp list` should show `instant-self`
- Next step

---

## MCP Tools Reference

Full list in `references/skill.md`. Key tools:

### App management
| Tool | Description |
|------|-------------|
| `list-apps` | List all apps |
| `get-app` | Get app details |
| `create-app` | Create a new app |
| `delete-app` | Delete an app (irreversible) |

### Schema & permissions
| Tool | Description |
|------|-------------|
| `get-schema` | Get current schema |
| `push-schema` | Push new schema |
| `push-schema-dry-run` | Preview without applying |
| `get-perms` | Get current permissions |
| `push-perms` | Push new permissions |

### Data
| Tool | Description |
|------|-------------|
| `query` | Run InstaQL query |
| `transact` | Run transaction (create/update/delete) |

### Storage
| Tool | Description |
|------|-------------|
| `list-files` | List storage files |
| `delete-file` | Delete a file |
| `get-upload-url` | Get pre-signed upload URL |
| `get-download-url` | Get pre-signed download URL |

### Webhooks
| Tool | Description |
|------|-------------|
| `list-webhooks` | List all webhooks |
| `create-webhook` | Create webhook |
| `update-webhook` | Update webhook |
| `delete-webhook` | Delete webhook |
| `enable-webhook` | Re-enable webhook |
| `disable-webhook` | Temporarily disable |
| `get-webhook-events` | Get delivery events + retry history |
| `resend-webhook-event` | Re-trigger failed delivery |

### Backups
| Tool | Description |
|------|-------------|
| `list-backups` | List all backups |
| `create-backup` | Trigger on-demand backup |
| `delete-backup` | Delete a backup |
| `list-backup-jobs` | List in-progress jobs |
| `get-backup-job` | Get job status |
| `cancel-backup-job` | Cancel in-progress job |
| `list-backup-files` | List files in backup |
| `get-backup-file-url` | Get pre-signed URL |

### Email & sender
| Tool | Description |
|------|-------------|
| `get-email-template` | Get magic-code email template |
| `update-email-template` | Update template |
| `send-test-email` | Send test email |
| `get-sender-verification` | DKIM/Return-Path status |
| `send-sender-verification` | Send verification email |
| `verify-sender-code` | Complete domain verification |

### Test users
| Tool | Description |
|------|-------------|
| `list-test-users` | List test users |
| `create-test-user` | Create test user with sign-in code |
| `delete-test-user` | Delete a test user |

### Orgs & members
| Tool | Description |
|------|-------------|
| `list-orgs` | List all organizations |
| `get-org` | Get org details |
| `list-org-apps` | List apps in org |
| `invite-app-member` | Invite user to app |
| `remove-app-member` | Remove member |
| `update-app-member` | Update member role |

---

## Safety rules

1. **Never delete or modify unrelated applications** — always confirm the app ID before `delete-app`
2. **Never expose secrets** — PATs, admin tokens, API keys go only into the MCP config, never in code
3. **Always dry-run before schema push** — use `push-schema-dry-run` to preview before `push-schema`
4. **Use `instantdb` skill for InstantDB Cloud** — this skill is only for FIDScript self-hosted
5. **SDK is separate from MCP** — the MCP manages the backend; the `@fidscript/instant` SDK is for client code
6. **Backup before destructive operations** — run `create-backup` before schema migrations or `delete-app`

---

## Client SDK quick reference

```bash
# Install
npm install @fidscript/instant   # React
# or
npm install @fidscript/core      # Vanilla
```

```typescript
// instantDb.ts
import { init } from '@fidscript/instant';

const db = init({
  appId: import.meta.env.VITE_INSTANT_APP_ID,
  // For self-hosted, also set:
  // apiURI: 'https://apiinstant.fidscript.com',
});

// React hook
const { isLoading, error, data } = db.useQuery({ posts: {} });

// Transaction
db.transact([db.tx.posts[id()].create({ title: 'Hello' })]);
```

> Note: `@fidscript/instant` uses the same API as `@instantdb/react` — the data model, queries, and transactions are identical. The difference is the backend management (MCP vs CLI) and the package name.

---

## Honesty section

- FIDScript MCP version: `fidscript/instant-mcp@0.4.1` — verify the latest version on npm
- API URI for self-hosted: `https://apiinstant.fidscript.com` (do not confuse with InstantDB Cloud's `api.instantdb.com`)
- The MCP tools operate on the backend — schema, perms, apps, webhooks, backups. Client SDK operates in the browser/app.
- This skill does not own FIDScript; it wraps the documented MCP and SDK.
- Schema push is irreversible for deleted attributes — always dry-run first.