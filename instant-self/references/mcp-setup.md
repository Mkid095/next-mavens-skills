# FIDScript MCP Setup — `fidscript/instant-mcp@0.4.1`

How to connect the FIDScript self-hosted InstantDB MCP to Claude Code and other editors.

Source: https://instant.fidscript.com/docs/using-llms

## Prerequisites

1. Get your **Personal Access Token (PAT)**:
   - Go to **Dashboard → User Settings → Personal Access Tokens**
   - Click "Create New Token"
   - Copy it — it starts with `per_`

2. Get your **App ID**:
   - Go to **Dashboard → Apps → [your app]**
   - Copy the App ID

## Package

```bash
# The MCP package
fidscript/instant-mcp@0.4.1

# The client SDK (for app code)
npm install @fidscript/instant   # React
npm install @fidscript/core     # Vanilla
```

## Claude Code

### Add the MCP

```bash
claude mcp add instant-self \
  -e INSTANT_ACCESS_TOKEN=<YOUR_PAT> \
  -e INSTANT_API_URI=apiinstant.fidscript.com \
  -e INSTANT_APP_ID=<YOUR_APP_ID> \
  -- npx -y fidscript/instant-mcp@0.4.1
```

### Verify

```bash
claude mcp list
```

You should see `instant-self` in the list.

## Cursor / Windsurf / Cline

Edit your MCP config:

**Cursor**: `~/.cursor/mcp.json`
**Windsurf**: `~/.codeium/windsurf/mcp_config.json`
**Cline**: `~/.claude/mcp.json` or `~/.codeium/windsurf/mcp_config.json`

```json
{
  "mcpServers": {
    "instant-self": {
      "command": "npx",
      "args": ["-y", "fidscript/instant-mcp@0.4.1"],
      "env": {
        "INSTANT_ACCESS_TOKEN": "<YOUR_PAT>",
        "INSTANT_API_URI": "apiinstant.fidscript.com",
        "INSTANT_APP_ID": "<YOUR_APP_ID>"
      }
    }
  }
}
```

## Zed

Edit `~/.zed/settings.json`:

```json
{
  "context_servers": {
    "instant-self": {
      "command": {
        "path": "npx",
        "args": ["-y", "fidscript/instant-mcp@0.4.1"],
        "env": {
          "INSTANT_ACCESS_TOKEN": "<YOUR_PAT>",
          "INSTANT_API_URI": "apiinstant.fidscript.com",
          "INSTANT_APP_ID": "<YOUR_APP_ID>"
        }
      },
      "settings": {}
    }
  }
}
```

## Claude Desktop

Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "instant-self": {
      "command": "npx",
      "args": ["-y", "fidscript/instant-mcp@0.4.1"],
      "env": {
        "INSTANT_ACCESS_TOKEN": "<YOUR_PAT>",
        "INSTANT_API_URI": "apiinstant.fidscript.com",
        "INSTANT_APP_ID": "<YOUR_APP_ID>"
      }
    }
  }
}
```

## Other editors (stdio)

```bash
npx -y fidscript/instant-mcp@0.4.1
```

With environment variables:
```bash
INSTANT_ACCESS_TOKEN=<YOUR_PAT> \
INSTANT_API_URI=apiinstant.fidscript.com \
INSTANT_APP_ID=<YOUR_APP_ID> \
npx -y fidscript/instant-mcp@0.4.1
```

## Environment variables

| Variable | Required | Default |
|----------|----------|---------|
| `INSTANT_ACCESS_TOKEN` | Yes | — |
| `INSTANT_API_URI` | No | `https://apiinstant.fidscript.com` |
| `INSTANT_APP_ID` | No | — (can be set per tool call) |

## Verifying the install

1. Restart your editor
2. Run `claude mcp list` (or equivalent)
3. `instant-self` should appear
4. In Claude Code: `/instant-self inspect backend` to verify

## Troubleshooting

**"MCP server not found"** — ensure `npx -y fidscript/instant-mcp@0.4.1` can run in your terminal
**"Auth failed"** — check that `INSTANT_ACCESS_TOKEN` is correct and starts with `per_`
**"App not found"** — check `INSTANT_APP_ID` is correct, or pass it per tool call