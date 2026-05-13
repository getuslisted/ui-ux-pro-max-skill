#!/usr/bin/env bash
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QC_ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$QC_ROOT_DIR/scripts/check.sh"
FIXTURES="$SCRIPT_DIR/fixtures"
[ -x "$CHECK" ] || { echo "FAIL: $CHECK is not executable"; exit 1; }
FAIL=0; PASS=0; FAILED_TESTS=()
TMPDIR="$(mktemp -d)"; trap 'rm -rf "$TMPDIR"' EXIT
run_test() {
  local name="$1" fixture="$2" expect="$3"
  local json_name; json_name=$(echo "$name" | tr '/' '_')
  local json="$TMPDIR/${json_name}.json"
  QC_ROOT="$fixture" QC_TARGETS="." QC_JSON="$json" QC_QUIET=1 QC_STRICT=1 "$CHECK" >/dev/null 2>&1
  local exit_code=$?
  if [ "$expect" = "flag" ]; then
    if [ "$exit_code" -eq 1 ]; then PASS=$((PASS + 1)); printf "  PASS  %s\n" "$name"
    else FAIL=$((FAIL + 1)); FAILED_TESTS+=("$name"); printf "  FAIL  %s (got %s)\n" "$name" "$exit_code"; fi
  else
    if [ "$exit_code" -eq 0 ]; then PASS=$((PASS + 1)); printf "  PASS  %s\n" "$name"
    else FAIL=$((FAIL + 1)); FAILED_TESTS+=("$name"); printf "  FAIL  %s (got %s)\n" "$name" "$exit_code"; [ -f "$json" ] && printf "        %s\n" "$(cat "$json")"; fi
  fi
}
echo "Quality Checks — test suite"; echo
echo "should-flag fixtures:"
for d in "$FIXTURES/should-flag"/*/; do [ -d "$d" ] || continue; run_test "should-flag/$(basename "$d")" "$d" "flag"; done
echo; echo "should-pass fixtures:"
for d in "$FIXTURES/should-pass"/*/; do [ -d "$d" ] || continue; run_test "should-pass/$(basename "$d")" "$d" "pass"; done
echo; echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -gt 0 ] && exit 1 || exit 0
