#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${repo_root}"

echo "==> fmt"
while IFS= read -r path; do
  x07 fmt --input "${path}" --check --report-json >/dev/null
done < <(find cli/src -name '*.x07.json' -print | LC_ALL=C sort)

echo "==> pkg lock"
x07 pkg lock --project x07.json --check --json=off >/dev/null

echo "==> arch check"
x07 arch check --manifest arch/manifest.x07arch.json >/dev/null

echo "==> cli smoke"
x07 run --project . --profile os --json=off -- x07-mcp-test --help >/dev/null

echo "==> schema fixtures"
x07 run --project . --profile os --json=off -- x07-mcp-test ci validate-fixtures

echo "==> doctor smoke"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

bin_path="${tmp_dir}/x07-mcp-test"
x07 bundle --project x07.json --profile os --json=off --out "${bin_path}" >/dev/null
chmod +x "${bin_path}"

ok_json="${tmp_dir}/doctor.ok.json"
"${bin_path}" doctor --machine json >"${ok_json}"
python3 scripts/ci/assert_doctor_json.py \
  "${ok_json}" true \
  os.uname=true \
  tmp.writable=true \
  shell.sh=true \
  node.present=true \
  npm.present=true \
  npx.present=true \
  url.reachable=true \
  cmd.present=true

bad_cmd="$(tr -d '\n' < fixtures/doctor/bad_cmd.txt)"
bad_cmd_json="${tmp_dir}/doctor.bad_cmd.json"
if "${bin_path}" doctor --machine json --cmd "${bad_cmd}" >"${bad_cmd_json}"; then
  echo "ERROR: expected doctor to fail for fixture cmd (got exit 0): ${bad_cmd}" >&2
  exit 1
fi
python3 scripts/ci/assert_doctor_json.py "${bad_cmd_json}" false cmd.present=false

bad_url="$(tr -d '\n' < fixtures/doctor/bad_url.txt)"
bad_url_json="${tmp_dir}/doctor.bad_url.json"
if "${bin_path}" doctor --machine json --url "${bad_url}" >"${bad_url_json}"; then
  echo "ERROR: expected doctor to fail for fixture url (got exit 0): ${bad_url}" >&2
  exit 1
fi
python3 scripts/ci/assert_doctor_json.py "${bad_url_json}" false url.reachable=false
