# error-messages-decoded MCP Server

An MCP (Model Context Protocol) server that gives AI assistants access to a curated knowledge base of decoded error messages. Feed it an error, get back the root cause, tested fix, and anti-patterns to avoid.

## Tools

| Tool | Description |
|------|-------------|
| `decode_error` | Search for an error message. Returns root cause, fix, and anti-patterns. |
| `list_stacks` | List all available stacks with error counts. |
| `list_errors` | List all known errors for a specific stack. |

## Setup

### With Claude Desktop

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "error-messages-decoded": {
      "command": "node",
      "args": ["/absolute/path/to/error-messages-decoded/mcp-server/dist/index.js"]
    }
  }
}
```

### With Claude Code

```bash
claude mcp add error-decoded node /absolute/path/to/error-messages-decoded/mcp-server/dist/index.js
```

### Build from source

```bash
cd mcp-server
npm install
npm run build
```

## Example

When an AI encounters an error like `EACCES: permission denied`, it can call:

```json
{
  "name": "decode_error",
  "arguments": {
    "error_message": "EACCES permission denied",
    "stack": "node",
    "limit": 1
  }
}
```

And gets back the full decoded entry: what happened, why, the fix, and what not to do.

## Coverage

131 errors across 19 stacks: Node.js, npm, Python, pip, TypeScript, React, Docker, Kubernetes, Git, PostgreSQL, Redis, Nginx, Linux, SSH, AWS, Go, Rust, Webpack, ESLint.
