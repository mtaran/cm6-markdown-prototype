import { test, expect } from "@playwright/test";

// Test: "edited document text persists via localStorage" — Playwright + real Chrome.
//
// Each Playwright test gets a fresh browser context, so localStorage starts
// empty (the app shows its demo document on first load). We edit the document,
// reload, and assert the edit was restored from localStorage.
//
// Why the edit is dispatched through the editor rather than typed: CodeMirror 6
// renders its editable surface as a `contenteditable` and applies typed text
// from `beforeinput` events whose `getTargetRanges()` come from real user
// editing. Synthetic input driven through Playwright does not produce that —
// `keyboard.type`, `keyboard.insertText`, `pressSequentially`, `locator.fill`,
// and even a raw `CDPSession` `Input.insertText` were all verified to be no-ops
// against this editor (the events fire but CM6 never applies them). So the test
// makes a genuine document change via the editor's own dispatch API, which
// exercises the exact `updateListener -> localStorage.setItem` path persistence
// relies on. The restored text is then read back the way a user sees it.

const MARKER = "PERSISTED_EDIT_PW";

test("edited document text persists via localStorage", async ({ page }) => {
  await page.goto("/index.html");
  await page.waitForSelector(".cm-content");

  // Make a real change to the document (insert a unique marker at the start).
  await page.evaluate((marker) => {
    const view = document.querySelector(".cm-content").cmView.view;
    view.dispatch({ changes: { from: 0, insert: marker + " " } });
  }, MARKER);

  // Reload to simulate reopening the app.
  await page.reload();
  await page.waitForSelector(".cm-content");

  // The edit must have been restored from localStorage — read the visible text.
  await expect(page.locator(".cm-content")).toContainText(MARKER);
});
