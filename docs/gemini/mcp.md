# MCP Server Documentation

## Endpoints

The RubyLLM Chat App exposes an MCP server (Model Context Protocol) via Server-Sent Events (SSE). It is mounted using the `fast-mcp` gem.

- **SSE Endpoint (GET)**: `/mcp/sse`
- **Messages Endpoint (POST)**: `/mcp/messages` (Note the plural `messages`, not `message`!)

## Request Format and Headers

When communicating with the MCP endpoints manually or via `curl`, you must abide by the following rules:

1. **Origin Header**: The `fast-mcp` gem enforces Origin validation to prevent CSRF attacks. Your request must include a valid `Origin` header that matches one of the `RICC_ALLOWED_HOSTS` defined in `config/initializers/aaa_ricc_hosts.rb` (e.g., `http://localhost`).
2. **Content-Type**: The POST request must have `Content-Type: application/json`.
3. **Session ID**: After connecting to the SSE endpoint, you will receive a `session_id`. You must append this to the messages URL as a query parameter: `/mcp/messages?session_id=<SESSION_ID>`.

### Example `curl` usage

1. **Connect to SSE** (in one terminal)
   ```bash
   curl -N -H "Origin: http://localhost" http://localhost:8080/mcp/sse
   ```
   *Note: This will return a `session_id`, e.g., `event: endpoint\ndata: /mcp/messages?session_id=12345`*

2. **Send JSON-RPC POST** (in another terminal)
   ```bash
   curl -X POST \
     -H "Origin: http://localhost" \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}' \
     "http://localhost:8080/mcp/messages?session_id=12345"
   ```

## Troubleshooting

- **404 Not Found**: You are likely trying to hit `/mcp/` or `/mcp/message`. Use `/mcp/sse` and `/mcp/messages`.
- **403 Forbidden ("Origin validation failed")**: You are missing the `Origin` header, or it is not in the allowed list. Use `-H "Origin: http://localhost"`.
