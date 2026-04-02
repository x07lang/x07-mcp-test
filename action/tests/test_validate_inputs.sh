#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

run_case() (
  local name="${1:?missing name}"
  local expect="${2:?missing exit}"
  shift 2

  local out
  set +e
  out="$(
    X07_MCP_TEST_ACTION_URL="${X07_MCP_TEST_ACTION_URL:-}" \
    X07_MCP_TEST_ACTION_CMD="${X07_MCP_TEST_ACTION_CMD:-}" \
    X07_MCP_TEST_ACTION_FULL_SUITE="${X07_MCP_TEST_ACTION_FULL_SUITE:-false}" \
    X07_MCP_TEST_ACTION_SARIF="${X07_MCP_TEST_ACTION_SARIF:-false}" \
    "$@" 2>&1
  )"
  local got="$?"
  set -e

  if [[ "${got}" != "${expect}" ]]; then
    echo "ERROR: ${name}: expected exit ${expect}, got ${got}" >&2
    echo "${out}" >&2
    exit 1
  fi
)

script="${repo_root}/action/validate_inputs.sh"

X07_MCP_TEST_ACTION_URL="http://127.0.0.1:3000/mcp" \
  X07_MCP_TEST_ACTION_CMD="" \
  run_case "url-only" 0 bash "${script}"

X07_MCP_TEST_ACTION_URL="" \
  X07_MCP_TEST_ACTION_CMD="node server.mjs" \
  run_case "cmd-only" 0 bash "${script}"

X07_MCP_TEST_ACTION_URL="http://127.0.0.1:3000/mcp" \
  X07_MCP_TEST_ACTION_CMD="node server.mjs" \
  run_case "url-and-cmd" 2 bash "${script}"

X07_MCP_TEST_ACTION_URL="" \
  X07_MCP_TEST_ACTION_CMD="" \
  run_case "neither-url-nor-cmd" 2 bash "${script}"

X07_MCP_TEST_ACTION_URL="http://127.0.0.1:3000/mcp" \
  X07_MCP_TEST_ACTION_SARIF="nope" \
  run_case "bad-sarif" 2 bash "${script}"
