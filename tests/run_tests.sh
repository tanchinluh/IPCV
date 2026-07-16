#!/usr/bin/env sh

set -u

SCILAB_EXECUTABLE=${1:-scilab-cli}
IPCV_TEST_SUITE=${2:-core}
IPCV_TEST_NAMES=${3:-}
IPCV_TEST_TIMEOUT=${IPCV_TEST_TIMEOUT:-600}
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
STATUS_FILE=$(mktemp "${TMPDIR:-/tmp}/ipcv-test.XXXXXX")
PROGRESS_FILE=$(mktemp "${TMPDIR:-/tmp}/ipcv-progress.XXXXXX")
RESULTS_DIR="$SCRIPT_DIR/results"
REPORT_FILE="$RESULTS_DIR/ipcv-$IPCV_TEST_SUITE-report.csv"

mkdir -p "$RESULTS_DIR"
trap 'rm -f "$STATUS_FILE" "$PROGRESS_FILE"' EXIT HUP INT TERM

export IPCV_TEST_STATUS_FILE="$STATUS_FILE"
export IPCV_TEST_REPORT_FILE="$REPORT_FILE"
export IPCV_TEST_PROGRESS_FILE="$PROGRESS_FILE"
export IPCV_TEST_SUITE
export IPCV_TEST_NAMES

"$SCILAB_EXECUTABLE" -nb -f "$SCRIPT_DIR/run_tests.sce" &
SCILAB_PID=$!
ELAPSED=0
while kill -0 "$SCILAB_PID" 2>/dev/null; do
    if [ "$ELAPSED" -ge "$IPCV_TEST_TIMEOUT" ]; then
        PROGRESS=$(sed -n '1p' "$PROGRESS_FILE")
        kill "$SCILAB_PID" 2>/dev/null || true
        wait "$SCILAB_PID" 2>/dev/null || true
        printf 'IPCV test suite timed out after %s seconds at: %s\n' "$IPCV_TEST_TIMEOUT" "${PROGRESS:-no progress reported}" >&2
        exit 1
    fi
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done
wait "$SCILAB_PID"
SCILAB_STATUS=$?

if [ -s "$STATUS_FILE" ] && [ "$(sed -n '1p' "$STATUS_FILE")" = "PASS" ]; then
    cat "$STATUS_FILE"
    if [ "$SCILAB_STATUS" -ne 0 ]; then
        printf 'Warning: Scilab returned %s after the test runner reported PASS.\n' "$SCILAB_STATUS" >&2
    fi
    exit 0
fi

if [ -s "$STATUS_FILE" ]; then
    cat "$STATUS_FILE" >&2
else
    printf 'IPCV test runner produced no status file. Scilab exit code: %s\n' "$SCILAB_STATUS" >&2
fi
exit 1
