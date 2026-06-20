# CM6 Markdown Editor Prototype

A single-file, build-free prototype of a Markdown **source** editor built on
[CodeMirror 6](https://codemirror.net). The entire app lives in
[`index.html`](index.html) — open it in a browser and it runs; there is no
bundler, package manager, or server required.

## Running

Open `index.html` directly in a modern browser, or serve the folder with any
static file server (e.g. `python3 -m http.server`). CodeMirror and its
dependencies load at runtime from [esm.sh](https://esm.sh) via an
[import map](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap),
so an internet connection is required on first load.

## Features

### Editing
- **Markdown syntax highlighting** via `@codemirror/lang-markdown` using the
  GitHub-Flavored-Markdown-capable `markdownLanguage` (tables, strikethrough,
  task lists, fenced code, etc.).
- **Syntax highlighting inside fenced code blocks** using CodeMirror's
  `defaultHighlightStyle`.
- **Line wrapping** — long lines wrap instead of scrolling horizontally.
- **Line numbers** in the gutter.
- **Code folding** with a fold gutter and fold keymap.
- **Undo / redo history** (`Ctrl/Cmd-Z`, `Ctrl/Cmd-Y` / `Ctrl-Shift-Z`).
- **Auto-indentation** on input.
- **Bracket matching** and **auto-closing brackets**.
- **Autocompletion** support (CodeMirror's completion framework).
- **Special-character highlighting** (visualizes non-printing characters).

### Selection & cursors
- **Multiple cursors / selections** — add or remove a cursor with **Alt-click**
  or **Cmd-click**.
- **Active line highlighting** in both the editor and the gutter.
- **Selection match highlighting** — other occurrences of the current selection
  are highlighted.
- **Drawn selection** and **drop cursor** for richer selection/drag feedback.
- Rectangular selection and the crosshair cursor are intentionally **disabled**
  so the `Alt` modifier stays free for multi-cursor behavior.

### Search
- **Find / replace** via the standard CodeMirror search keymap
  (`Ctrl/Cmd-F` to open search).

### Theming
- **Automatic light / dark mode** that follows the OS
  `prefers-color-scheme` setting and switches live when the system theme
  changes.
- Dark mode uses the `one-dark` theme; light mode uses a custom theme tuned to
  blend with the page chrome. Theme colors are driven by CSS custom properties.
- *(Note: an explicit light/dark/auto toggle was removed; theming is now fully
  automatic.)*

### Persistence
- **Local autosave** — the document is saved to `localStorage` (key
  `cm6-markdown-doc`) on every change and restored on reload. A demo document is
  shown the first time, before anything has been saved.

## Implementation notes
- `basicSetup` is unpacked manually so `rectangularSelection` and
  `crosshairCursor` can be dropped (they would otherwise claim the `Alt`
  modifier needed for multi-cursor).
- The import map pins and dedupes all `@codemirror/*` and `@lezer/*` packages to
  single shared instances; mixing independently-pinned esm.sh builds otherwise
  throws "multiple instances of @codemirror/state".
- The theme is held in a CodeMirror `Compartment` so it can be reconfigured at
  runtime without recreating the editor state.
