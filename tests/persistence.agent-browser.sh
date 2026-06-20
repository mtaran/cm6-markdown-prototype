#!/usr/bin/env bash
#
# Test: "edited document text persists via localStorage" — agent-browser version.
#
# Drives index.html with the agent-browser CLI (Chrome via CDP) and asserts that
# an edit to the CodeMirror document is written to localStorage and restored
# after a reload.
#
# Why we edit by dispatching a CodeMirror transaction instead of sending
# keystrokes: CM6's input handling does not pick up synthetic CDP key events in
# headless Chrome, so a `keyboard type` is silently dropped. Dispatching a
# transaction through the live EditorView (reachable at
# `.cm-content`.cmView.view) inserts real text into the document and triggers
# the exact `updateListener -> localStorage.setItem` path that persistence
# relies on — which is what this test is about.
#
# Usage: tests/persistence.agent-browser.sh
# Exit code 0 = pass, non-zero = fail.

set -euo pipefail

PORT="${PORT:-8099}"
URL="http://127.0.0.1:${PORT}/index.html"
SESSION="cm6-persist-$$"
KEY="cm6-markdown-doc"
MARKER="PERSISTED_EDIT_$$"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ab() { agent-browser --session-name "$SESSION" "$@"; }

# eval helper: run JS in the page, return its result on stdout (unquoted-ish).
ev() { ab eval "$1" 2>/dev/null | tail -1; }

cleanup() {
  ab eval "localStorage.removeItem('${KEY}'); 1" >/dev/null 2>&1 || true
  ab close >/dev/null 2>&1 || true
  if [[ -n "${SERVER_PID:-}" ]]; then kill "$SERVER_PID" >/dev/null 2>&1 || true; fi
}
trap cleanup EXIT

fail() { echo "FAIL: $1"; exit 1; }

# --- Start a static server for the app ------------------------------------
( cd "$ROOT" && python3 -m http.server "$PORT" >/dev/null 2>&1 ) &
SERVER_PID=$!
for _ in $(seq 1 50); do
  curl -sf -o /dev/null "$URL" && break
  sleep 0.1
done

echo "1. Open app and start from a clean slate (no saved doc)."
ab open "$URL" >/dev/null
ab wait ".cm-content" >/dev/null
ab eval "localStorage.removeItem('${KEY}'); 1" >/dev/null
ab reload >/dev/null
ab wait ".cm-content" >/dev/null
[[ "$(ev "localStorage.getItem('${KEY}')===null")" == "true" ]] \
  || fail "expected no saved doc after clearing localStorage"

echo "2. Edit the document (insert a unique marker at the start)."
ev "var v=document.querySelector('.cm-content').cmView.view; \
    v.dispatch({changes:{from:0,insert:'${MARKER} '}}); 'ok'" >/dev/null

echo "3. Assert the edit was written to localStorage on change."
saved="$(ev "(localStorage.getItem('${KEY}')||'').includes('${MARKER}')")"
[[ "$saved" == "true" ]] || fail "marker was not saved to localStorage after edit"

echo "4. Reload the page (simulates reopening the app)."
ab reload >/dev/null
ab wait ".cm-content" >/dev/null

echo "5. Assert the edited text was restored into the editor from localStorage."
restored="$(ev "document.querySelector('.cm-content').cmView.view.state.doc.toString().includes('${MARKER}')")"
[[ "$restored" == "true" ]] || fail "edited text did not persist across reload"

echo "PASS: edited document text persists via localStorage (agent-browser)"
