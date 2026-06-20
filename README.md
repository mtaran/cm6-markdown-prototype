# CM6 Markdown Editor Prototype

A single-file [CodeMirror 6](https://codemirror.net) Markdown source editor.
Everything lives in [`index.html`](index.html); open it in a browser — no build
step. Dependencies load at runtime from [esm.sh](https://esm.sh), so first load
needs an internet connection.

## Features

- **Markdown source editing** with GitHub-Flavored-Markdown highlighting.
- **Line wrapping.**
- **Multiple cursors** — add or remove a cursor with **Alt-click** or
  **Cmd-click**.
- **Automatic light/dark theme** that follows the OS `prefers-color-scheme` and
  updates live when it changes.
- **Local autosave** — the document is persisted to `localStorage` and restored
  on reload.
