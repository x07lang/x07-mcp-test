# x07-mcp-test

Private-alpha MCP verifier CLI (Track A wedge).

## Status

M1 Week 3 expands the verifier beyond conformance-only:

- conformance (`conformance run`)
- replay record + replay verify (`replay record`, `replay verify`)
- trust verification (`trust verify`)
- bundle verification (`bundle verify`)

All commands support `--machine json` and emit schema-versioned JSON outputs under `schemas/`.

## Usage

- `x07-mcp-test --help`
- `x07-mcp-test doctor`
- `x07-mcp-test doctor --machine json --cmd "<stdio cmd>" --url "<http url>"`
- `x07-mcp-test conformance run --url "<http url>"`
- `x07-mcp-test conformance run --url "<http url>" --out out/`
- `x07-mcp-test conformance run --url "<http url>" --full-suite`
- `x07-mcp-test replay record --url "<http url>" --out out/replay.session.json --scenario smoke/basic`
- `x07-mcp-test replay verify --session out/replay.session.json --url "<http url>" --out out/replay-verify`
- `x07-mcp-test trust verify --server-json "<path>"`
- `x07-mcp-test bundle verify --server-json "<path>" --mcpb "<path>"`

See `docs/doctor.md`.

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

## Notes

- Conformance runs the official MCP suite via `npx`; use `x07-mcp-test doctor` to confirm Node/npm/npx preconditions.
- For now, `replay record` records the `smoke/basic` HTTP scenario and stores the cassette at `details.http_session` (schema `x07.mcp.rr.http_session@0.1.0`). See `rr/README.md`.
- Trust and bundle verification operate on registry artifacts (`server.json` and `.mcpb`) rather than a running HTTP server. See `trust/README.md`.
- Output paths should be **relative** (example: `out/...`). Absolute paths are rejected by the current filesystem capability model.

## Conformance outputs

`x07-mcp-test conformance run` writes:
- `summary.json` (schema: `x07.mcp.conformance.summary@0.1.0`)
- `summary.junit.xml`
- `summary.html`

Exit codes:
- `0` all required scenarios passed
- `1` one or more required scenarios failed
- `2` invocation/config/runtime precondition failure

## Fixture targets (Week 2)

Local fixture servers live under `fixtures/servers/` and are wired via:
- `conformance/fixtures/targets.json`
- `conformance/scripts/spawn_reference_http.sh`
- `conformance/scripts/wait_for_http.sh`

Ports/URLs:
- `good-http`: `http://127.0.0.1:18080/mcp`
- `auth-http`: `http://127.0.0.1:18081/mcp`
- `broken-http`: `http://127.0.0.1:18082/mcp`

Start a fixture server:
- `conformance/scripts/spawn_reference_http.sh good-http noauth`
