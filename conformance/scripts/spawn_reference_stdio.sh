#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET_ID="${1:?missing target id (good-stdio|broken-stdio)}"

cd "${ROOT}/fixtures/servers"

if [[ ! -d node_modules ]]; then
  npm ci >/dev/null
fi

case "${TARGET_ID}" in
  good-stdio)
    exec node stdio-hello/server.mjs
    ;;
  broken-stdio)
    exec node stdio-broken/server.mjs
    ;;
  *)
    echo "ERROR: unknown target id: ${TARGET_ID}" >&2
    exit 2
    ;;
esac

