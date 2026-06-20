#!/usr/bin/env bash
#
# Runner for the lightpanda transcript (PandaScript) persistence test.
# Starts a static server, replays the transcript with `lightpanda agent`, and
# asserts the JSON result contains "pass":true.
#
# Requires a lightpanda build with the `agent` command (PandaScript replay).
#
# Usage: tests/persistence.pandascript.sh
# Exit code 0 = pass, non-zero = fail.

set -euo pipefail

PORT="${PORT:-8077}"
URL="http://127.0.0.1:${PORT}/index.html"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="${ROOT}/tests/persistence.pandascript.js"
LIGHTPANDA="${LIGHTPANDA:-lightpanda}"

cleanup() { if [[ -n "${SERVER_PID:-}" ]]; then kill "$SERVER_PID" >/dev/null 2>&1 || true; fi; }
trap cleanup EXIT

fail() { echo "FAIL: $1"; exit 1; }

# The transcript hard-codes port 8077; keep them in sync.
[[ "$PORT" == "8077" ]] || fail "PORT must be 8077 to match the transcript URL"

( cd "$ROOT" && python3 -m http.server "$PORT" >/dev/null 2>&1 ) &
SERVER_PID=$!
for _ in $(seq 1 50); do
  curl -sf -o /dev/null "$URL" && break
  sleep 0.1
done

out="$("$LIGHTPANDA" agent "$SCRIPT" 2>/dev/null)" || fail "lightpanda agent exited non-zero"
echo "$out"
echo "$out" | grep -q 'pass=true' \
  || fail "transcript did not report pass=true"

echo "PASS: edited document text persists via localStorage (lightpanda transcript)"
