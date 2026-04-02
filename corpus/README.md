# Corpus runner (skeleton)

The corpus runner exists to make the public quality report reproducible:

- a checked-in manifest defines **what** was tested and under which assumptions
- `x07-mcp-test corpus run` produces per-target outputs plus an aggregate `index.json`

This is intentionally a **skeleton**: it enumerates targets and emits stub outputs/paths so downstream consumers (website/report pages) can depend on a frozen shape before implementation fans out.

## Manifest

- Schema: `schemas/x07.mcp.report.manifest.schema.json` (`x07.mcp.report.manifest@0.1.0`)
- Example: `corpus/manifests/quality-report-001.json`

Each `targets[]` entry captures:

- `id`: stable server id used in output paths
- `source`: repo/version (and optional commit/registry id) for reproducibility
- `target`: transport + reference (`streamable_http` URL or `stdio` command)
- `assumptions`: auth mode notes for fair testing
- `exclusions`: explicit skipped scenarios

## `corpus run` outputs

`x07-mcp-test corpus run --manifest <FILE> --out <DIR>` writes:

- `<DIR>/index.json` (`x07.mcp.corpus.summary@0.1.0`)
- `<DIR>/<server_id>/result.json` (`x07.mcp.corpus.result@0.1.0`)
- stub per-target artifact paths (summary JSON/JUnit/HTML/SARIF) for later wiring

## Notes

- The skeleton emits `ok=false` and exits `1` with a `corpus.stub` error explaining the placeholder status.
- Replace the CI fixture manifest contents with the real report target set before generating the public dataset.
