#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repo_root}"

tag="${X07_MCP_TEST_TAG:-${GITHUB_REF_NAME:-}}"
if [[ -z "${tag}" ]]; then
  echo "ERROR: missing release tag; set X07_MCP_TEST_TAG (example: v0.1.0-alpha.0)" >&2
  exit 2
fi

if [[ "${tag}" != v* ]]; then
  echo "ERROR: tag must start with 'v' (got: ${tag})" >&2
  exit 2
fi

platform="$(uname -s)"
arch="$(uname -m)"

artifact_platform=""
case "${platform}-${arch}" in
  Linux-x86_64) artifact_platform="linux-x64" ;;
  Darwin-arm64) artifact_platform="darwin-arm64" ;;
  Darwin-x86_64) artifact_platform="darwin-x64" ;;
  *)
    echo "ERROR: unsupported platform/arch for release packaging: ${platform}-${arch}" >&2
    echo "NOTE: on Windows, run inside WSL2 and use the linux-x64 artifact." >&2
    exit 2
    ;;
esac

dist_dir="${DIST_DIR:-dist}"
work_dir="${dist_dir}/work"
mkdir -p "${work_dir}"

bin_name="x07-mcp-test"
bin_path="${work_dir}/${bin_name}"

echo "==> bundle ${bin_name} (${artifact_platform})"
x07 bundle --project x07.json --profile os --json=off --out "${bin_path}" >/dev/null
chmod +x "${bin_path}"

archive_base="${bin_name}-${tag}-${artifact_platform}"
archive_path="${dist_dir}/${archive_base}.tar.gz"

echo "==> package ${archive_path}"
tar -C "${work_dir}" -czf "${archive_path}" "${bin_name}"

echo "${archive_path}"

