import { defineConfig } from "@playwright/test";

// Drives the prototype with real Google Chrome (channel: "chrome"). A tiny
// static server hosts index.html for the duration of the run.
export default defineConfig({
  testDir: "./tests",
  testMatch: "**/*.spec.js",
  webServer: {
    command: "python3 -m http.server 8077",
    url: "http://127.0.0.1:8077/index.html",
    reuseExistingServer: !process.env.CI,
  },
  use: {
    baseURL: "http://127.0.0.1:8077",
    channel: "chrome",
  },
});
