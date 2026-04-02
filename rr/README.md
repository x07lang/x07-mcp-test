# Replay / record (rr)

Replay support lets `x07-mcp-test` produce deterministic, reviewable evidence:

- `x07-mcp-test replay record` records a small deterministic HTTP session into a session file (`x07.mcp.replay.session@0.2.0`).
- `x07-mcp-test replay verify` replays the recorded cassette against a target server and emits a pass/fail verification report (`x07.mcp.replay.verify@0.2.0`).

The recorded cassette lives inside the session file at `details.http_session` and is schema-versioned as `x07.mcp.rr.http_session@0.1.0`.

## Cassette format (v1)

`x07.mcp.rr.http_session@0.1.0` contains:

- `id`: scenario id (example: `smoke.basic`)
- `base_url`: scheme + host + port (example: `http://127.0.0.1:18080`)
- `mcp_path`: HTTP path (example: `/mcp`)
- `steps[]`: ordered request/response steps with normalized headers and JSON payloads

HTTP+SSE targets (Streamable HTTP) are supported by extracting and canonicalizing JSON payloads from `data: ...` event lines.

## Sanitization

`replay record` supports `--sanitize` categories to redact token-like / secret-like fields before writing the session file.

## Fixtures and schemas

- Fixture session output: `fixtures/reports/replay.session.json`
- Fixture cassette: `rr/fixtures/good-http.session.json`
- Cassette schema: `rr/schemas/session.schema.json`
- Verify schema: `rr/schemas/replay-verify.schema.json`
