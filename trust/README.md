# Trust verification

Week 3 adds a minimal trust wedge to `x07-mcp-test`:

`x07-mcp-test trust verify` checks a registry `server.json` file for required publisher-provided trust metadata and emits a machine-readable trust summary report (`x07.mcp.trust.summary@0.1.0`).

This is intentionally a small, deterministic set of checks for the private alpha. It validates the presence and basic format of trust fields; it does not prove a server is secure or safe to run.

## Usage

```sh
x07-mcp-test trust verify --server-json ./server.json

# machine output:
x07-mcp-test trust verify --server-json ./server.json --machine json
```

## Fixtures

- `trust/fixtures/server-good.json` (expected pass)
- `trust/fixtures/server-bad.json` (expected fail)

