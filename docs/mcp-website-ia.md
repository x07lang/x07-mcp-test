# MCP website IA + message hierarchy

Information architecture and messaging hierarchy for the MCP wedge pages.

## Route list (frozen)

- `/mcp` — Wedge landing page (what it is + why it matters).
- `/mcp/install` — Install `x07-mcp-test` (private alpha) and run `doctor`.
- `/mcp/action` — CI integration preview (GitHub Action surface).
- `/mcp/codespaces` — Zero-install evaluation path (Codespaces).

## Message hierarchy (frozen)

### `/mcp`

- Headline: Test and trust MCP servers.
- Subhead: `x07-mcp-test` is a standalone verifier that runs conformance, replay, and trust checks against MCP servers (any language).
- CTA 1: Install (private alpha)
- CTA 2: Open in Codespaces
- CTA 3: Add to CI (Action preview)

### `/mcp/install`

- Headline: Install `x07-mcp-test` (private alpha)
- Subhead: Prebuilt binaries; conformance requires a working Node/npm toolchain.
- CTA 1: Download latest alpha release
- CTA 2: Run `x07-mcp-test doctor`
- CTA 3: Run `x07-mcp-test conformance run`

### `/mcp/action`

- Headline: Run MCP conformance in CI
- Subhead: GitHub Action wrapper around `x07-mcp-test` outputs.
- CTA 1: See the Action YAML snippet
- CTA 2: View sample report artifacts
- CTA 3: Open an issue for early access

### `/mcp/codespaces`

- Headline: Try MCP verification with zero install
- Subhead: Codespaces is the default “first success” path for the private alpha.
- CTA 1: Open the Codespace
- CTA 2: Run the quickstart
- CTA 3: Leave feedback

## Explicitly out of scope (for now)

- No x07 homepage rewrite.
- No “State of MCP quality” report page yet.
- No aggressive comparison pages vs other MCP SDKs.

## Feedback destination

File issues in `x07lang/x07-mcp-test` with label `feedback`.
