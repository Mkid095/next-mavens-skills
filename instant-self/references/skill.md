# FIDScript MCP Tools Reference

Full list of 43 tools exposed by `fidscript/instant-mcp@0.4.1`.

Source: https://instant.fidscript.com/docs/using-llms (FIDScript self-hosted docs)

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `INSTANT_ACCESS_TOKEN` | Yes | — | Personal access token (starts with `per_`) |
| `INSTANT_API_URI` | No | `https://apiinstant.fidscript.com` | Self-hosted API URL |
| `INSTANT_APP_ID` | No | — | Default app ID (overridable per tool call) |

## All 43 tools

### Core — learn
| Tool | Args | Description |
|------|------|-------------|
| `learn` | — | Learn about InstantDB concepts and syntax (useful for the agent to understand the data model) |

### Data — query & transact
| Tool | Args | Description |
|------|------|-------------|
| `query` | `appId?`, `query` | Execute an InstaQL query against an app |
| `transact` | `appId?`, `txs` | Execute a transaction (create/update/delete data) |

### Schema & permissions
| Tool | Args | Description |
|------|------|-------------|
| `get-schema` | `appId?` | Retrieve the current schema for an app |
| `push-schema` | `appId`, `schema` | Push a new schema definition (irreversible for deleted attrs — dry-run first) |
| `push-schema-dry-run` | `appId`, `schema` | Preview a schema push without applying it |
| `get-perms` | `appId?` | Retrieve the current permissions rules |
| `push-perms` | `appId?`, `perms` | Push new permissions rules |

### App lifecycle
| Tool | Args | Description |
|------|------|-------------|
| `list-apps` | — | List all apps associated with your account |
| `get-app` | `appId` | Get detailed info about a specific app |
| `create-app` | `name`, `description?` | Create a new InstantDB app |
| `delete-app` | `appId` | Permanently delete an app (irreversible — backup first) |

### File storage
| Tool | Args | Description |
|------|------|-------------|
| `list-files` | `appId?` | List all files in app storage |
| `delete-file` | `appId?`, `fileId` | Delete a file from storage |
| `get-upload-url` | `appId?`, `filename`, `contentType` | Get a pre-signed URL for file uploads |
| `get-download-url` | `appId?`, `fileId` | Get a pre-signed URL for file downloads |

### Webhooks
| Tool | Args | Description |
|------|------|-------------|
| `list-webhooks` | `appId?` | List all webhooks for an app |
| `create-webhook` | `appId?`, `url`, `namespaces?`, `actions?` | Create a new webhook endpoint |
| `update-webhook` | `appId?`, `webhookId`, `url?`, `namespaces?`, `actions?` | Update a webhook's URL, namespaces, or actions |
| `delete-webhook` | `appId?`, `webhookId` | Delete a webhook |
| `enable-webhook` | `appId?`, `webhookId` | Re-enable a disabled webhook |
| `disable-webhook` | `appId?`, `webhookId` | Temporarily disable a webhook |
| `get-webhook-events` | `appId?`, `webhookId`, `limit?` | Get webhook delivery events with retry history |
| `resend-webhook-event` | `appId?`, `eventId` | Re-trigger a failed webhook delivery |

### Backups
| Tool | Args | Description |
|------|------|-------------|
| `list-backups` | `appId?` | List all backups for an app |
| `create-backup` | `appId?` | Trigger an on-demand backup |
| `delete-backup` | `appId?`, `backupId` | Delete a backup |
| `list-backup-jobs` | `appId?` | List in-progress backup jobs |
| `get-backup-job` | `appId?`, `jobId` | Get status of a specific backup job |
| `cancel-backup-job` | `appId?`, `jobId` | Cancel an in-progress backup |
| `list-backup-files` | `appId?`, `backupId` | List files in a backup |
| `get-backup-file-url` | `appId?`, `backupId`, `fileId` | Get a pre-signed URL for a backup file |

### Test users
| Tool | Args | Description |
|------|------|-------------|
| `list-test-users` | `appId?` | List test users for an app |
| `create-test-user` | `appId?`, `email?` | Create a test user with a sign-in code |
| `delete-test-user` | `appId?`, `testUserId` | Delete a test user |

### Email & sender verification
| Tool | Args | Description |
|------|------|-------------|
| `get-email-template` | `appId?` | Get the magic-code email template |
| `update-email-template` | `appId?`, `template`, `subject` | Update the magic-code email template |
| `send-test-email` | `appId?`, `email` | Send a test email to verify template config |
| `get-sender-verification` | `appId?` | Get DKIM/Return-Path verification status |
| `send-sender-verification` | `appId?`, `domain` | Send a sender verification email |
| `verify-sender-code` | `appId?`, `code` | Complete sender domain verification |

### Organizations & members
| Tool | Args | Description |
|------|------|-------------|
| `list-orgs` | — | List all organizations |
| `get-org` | `orgId` | Get org details including apps, members, invites |
| `list-org-apps` | `orgId` | List all apps in an org |
| `invite-app-member` | `appId?`, `email`, `role` | Invite a user to an app |
| `remove-app-member` | `appId?`, `userId` | Remove a member from an app |
| `update-app-member` | `appId?`, `userId`, `role` | Update a member's role on an app |

---

## Usage examples

### Push schema (with dry-run first)

```
// Draft schema
MCP: push-schema-dry-run({
  appId: 'my-app-id',
  schema: { entities: { posts: { attrs: { title: 'string' } } } }
})
// Review the preview...

// Apply if looks good
MCP: push-schema({
  appId: 'my-app-id',
  schema: { entities: { posts: { attrs: { title: 'string' } } } }
})
```

### Query data

```
MCP: query({
  appId: 'my-app-id',
  query: { posts: {}, profiles: {} }
})
// Returns JSON matching the InstaQL query shape
```

### Transact (create)

```
MCP: transact({
  appId: 'my-app-id',
  txs: [
    { op: 'create', path: ['posts', 'new-id'], data: { title: 'Hello', body: 'World' } }
  ]
})
```

### Create a webhook

```
MCP: create-webhook({
  appId: 'my-app-id',
  url: 'https://myapp.com/webhook',
  namespaces: ['posts', 'comments'],
  actions: ['create', 'update', 'delete']
})
```

### Create a test user

```
MCP: create-test-user({
  appId: 'my-app-id',
  email: 'test@example.com'
})
// Returns a sign-in code for the test user
```

---

## Safety

- `push-schema` is irreversible for deleted attributes — always dry-run first
- `delete-app` is permanent — confirm app ID and backup first
- `delete-backup` is permanent
- `remove-app-member` cannot be undone — confirm before running
- Never expose `INSTANT_ACCESS_TOKEN` in code — only in MCP config