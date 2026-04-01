#!/usr/bin/env python3

import json
import sys
from pathlib import Path


def parse_bool(s: str) -> bool:
    s = s.strip().lower()
    if s in ("1", "true", "yes", "y", "on"):
        return True
    if s in ("0", "false", "no", "n", "off"):
        return False
    raise ValueError(f"invalid bool: {s!r}")


def main(argv: list[str]) -> int:
    if len(argv) < 3:
        print(
            "usage: assert_doctor_json.py <json_path> <expect_ok> [<check_id>=<bool>...]",
            file=sys.stderr,
        )
        return 2

    json_path = Path(argv[1])
    expect_ok = parse_bool(argv[2])
    expect_checks: dict[str, bool] = {}
    for item in argv[3:]:
        if "=" not in item:
            raise ValueError(f"expected <check_id>=<bool>, got: {item!r}")
        check_id, ok_s = item.split("=", 1)
        expect_checks[check_id] = parse_bool(ok_s)

    raw = json_path.read_text(encoding="utf-8")
    data = json.loads(raw)

    if data.get("schema_version") != "x07.mcp.doctor@0.1.0":
        raise ValueError(f"unexpected schema_version: {data.get('schema_version')!r}")

    ok = data.get("ok")
    if ok is not expect_ok:
        raise ValueError(f"unexpected ok: got {ok!r}, want {expect_ok!r}")

    checks = data.get("checks")
    if not isinstance(checks, list):
        raise ValueError("missing checks[]")

    by_id: dict[str, dict] = {}
    for check in checks:
        if not isinstance(check, dict):
            continue
        cid = check.get("id")
        if isinstance(cid, str):
            by_id[cid] = check

    for check_id, expect_check_ok in expect_checks.items():
        got = by_id.get(check_id)
        if got is None:
            raise ValueError(f"missing check id: {check_id}")
        if got.get("ok") is not expect_check_ok:
            raise ValueError(
                f"unexpected check {check_id}.ok: got {got.get('ok')!r}, want {expect_check_ok!r}"
            )

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

