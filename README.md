# x07-mcp-test

Private-alpha MCP verifier CLI (Track A wedge).

## Status

Week 1 scope is repo skeleton + CLI dispatch. Most commands are stubs until later weeks.

## Usage

- `x07-mcp-test --help`
- `x07-mcp-test doctor`

## Commands (M1 contract)

- `doctor`
- `conformance run`
- `replay record`
- `replay verify`
- `trust verify`
- `bundle verify`

## Install (alpha)

Release artifacts are built via GitHub Actions on tags like `v0.1.*-alpha*`.

On Windows, run inside WSL2 and use the `linux-x64` artifact.

## Schemas

Week 1 freezes report schema naming and the shared envelope fields:

- `x07.mcp.conformance.summary@0.1.0` (`schemas/x07.mcp.conformance.summary.schema.json`)
- `x07.mcp.replay.session@0.1.0` (`schemas/x07.mcp.replay.session.schema.json`)
- `x07.mcp.replay.verify@0.1.0` (`schemas/x07.mcp.replay.verify.schema.json`)
- `x07.mcp.trust.summary@0.1.0` (`schemas/x07.mcp.trust.summary.schema.json`)
- `x07.mcp.bundle.verify@0.1.0` (`schemas/x07.mcp.bundle.verify.schema.json`)

Sample fixtures live under `fixtures/reports/` and validate in CI.
