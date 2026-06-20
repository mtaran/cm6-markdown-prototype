// Test: "edited document text persists via localStorage" — lightpanda transcript.
//
// This is a PandaScript: vanilla JavaScript with lightpanda's native browser
// primitives (new Page, page.goto, page.evaluate, page.waitForSelector). It is
// the kind of transcript `lightpanda agent` records via /save and replays
// deterministically (no LLM at replay time) with:
//
//     lightpanda agent tests/persistence.pandascript.js
//
// The runner asserts on the `pass=true` line this script logs to stdout.
// See tests/persistence.pandascript.sh.
//
// As in the agent-browser version, the edit is made by dispatching a CodeMirror
// transaction through the live EditorView (reachable at `.cm-content`.cmView.view)
// rather than by synthetic keystrokes: that inserts real text into the document
// and triggers the exact updateListener -> localStorage.setItem path that
// persistence depends on.

const URL = "http://127.0.0.1:8077/index.html";
const KEY = "cm6-markdown-doc";
const MARKER = "PERSISTED_EDIT_PANDA";

const page = new Page();

// 1. Open the app and start from a clean slate (no saved doc).
await page.goto(URL);
await page.waitForSelector(".cm-content");
page.evaluate(`localStorage.removeItem(${JSON.stringify(KEY)})`);
await page.goto(URL); // reload
await page.waitForSelector(".cm-content");
const clean = page.evaluate(`localStorage.getItem(${JSON.stringify(KEY)}) === null`);

// 2. Edit the document (insert a unique marker at the start).
page.evaluate(
  `document.querySelector('.cm-content').cmView.view` +
  `.dispatch({changes:{from:0,insert:${JSON.stringify(MARKER + " ")}}})`
);

// 3. The edit must have been written to localStorage on change.
const saved = page.evaluate(
  `(localStorage.getItem(${JSON.stringify(KEY)})||'').includes(${JSON.stringify(MARKER)})`
);

// 4. Reload the page (simulates reopening the app).
await page.goto(URL);
await page.waitForSelector(".cm-content");

// 5. The edited text must have been restored into the editor from localStorage.
const restored = page.evaluate(
  `document.querySelector('.cm-content').cmView.view.state.doc.toString()` +
  `.includes(${JSON.stringify(MARKER)})`
);

const pass = clean && saved && restored;
console.log(`clean=${clean} saved=${saved} restored=${restored} pass=${pass}`);
