# x07-mcp-test GitHub Action (public beta contract)

This Action downloads an `x07-mcp-test` release binary and runs `x07-mcp-test conformance run` against a target MCP server (HTTP or stdio).

## Usage

### Streamable HTTP target

```yaml
name: mcp-quality

on:
  push:
  pull_request:

jobs:
  conformance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Start your MCP server here (or target a deployed URL).
      # - name: Start server
      #   run: ./scripts/start-server.sh

      - name: Run MCP conformance
        id: mcp
        uses: x07lang/x07-mcp-test/action@v0.1.0-alpha.4
        with:
          url: http://127.0.0.1:3000/mcp
          full-suite: "false"

      - name: Upload reports
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: x07-mcp-test-reports
          path: |
            out/doctor.json
            out/conformance/summary.json
            out/conformance/summary.junit.xml
            out/conformance/summary.html
```

### stdio target

```yaml
- name: Run MCP conformance (stdio)
  id: mcp
  uses: x07lang/x07-mcp-test/action@v0.1.0-alpha.4
  with:
    cmd: node server.mjs
    cwd: servers/my-mcp
    env-file: .env.mcp
    full-suite: "false"
```

## Inputs

- `url` (required unless `cmd`): MCP HTTP URL (example: `http://127.0.0.1:3000/mcp`)
- `cmd` (required unless `url`): MCP stdio command (example: `node server.mjs`)
- `cwd` (optional): working directory for `cmd`
- `env-file` (optional): env file to load for `cmd`
- `full-suite` (optional): `"true"` to run the full official suite
- `baseline` (optional): path to an expected-failures YAML file
- `sarif` (optional): `"true"` to emit a `summary.sarif.json` file
- `version` (optional): `v0.1.*-alpha.*` tag, or `latest-alpha`

## Outputs

- `ok`: `true` if conformance passed (exit 0)
- `json_report`: `out/conformance/summary.json`
- `junit_report`: `out/conformance/summary.junit.xml`
- `html_report`: `out/conformance/summary.html`
- `sarif_report`: `out/conformance/summary.sarif.json` (when enabled)

## Notes

- The official conformance suite runs via `npx`, so Node/npm/npx must be available on the runner.
- Windows is supported via WSL2; this Action currently targets Linux/macOS runners.
- `sarif=true` currently emits a stub SARIF file (schema/shape is frozen; renderer is not implemented yet).

## PR summary snippet

```yaml
- name: MCP conformance summary
  if: always()
  run: |
    {
      echo "### MCP conformance"
      echo ""
      echo "- ok: ${{ steps.mcp.outputs.ok }}"
      echo "- json: ${{ steps.mcp.outputs.json_report }}"
      echo "- junit: ${{ steps.mcp.outputs.junit_report }}"
      echo "- html: ${{ steps.mcp.outputs.html_report }}"
      echo "- sarif: ${{ steps.mcp.outputs.sarif_report }}"
    } >>"$GITHUB_STEP_SUMMARY"
```
