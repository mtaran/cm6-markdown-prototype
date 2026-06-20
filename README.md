# CM6 Markdown Editor Prototype

A single-file [CodeMirror 6](https://codemirror.net) Markdown source editor.
Everything lives in [`index.html`](index.html); open it in a browser — no build
step. Dependencies load at runtime from [esm.sh](https://esm.sh), so first load
needs an internet connection.

## Features

- **Markdown source editing** with GitHub-Flavored-Markdown highlighting.
- **Line wrapping.**
- **Command / insert modes** — command mode (default) is a read-only,
  word-oriented view; press **`i`** for insert mode (normal editing, warm
  background) and **`Esc`** to return. The current mode shows in a chip in the
  top-right. Switching to insert keeps the command-mode selection, so it's ready
  to replace or edit.
  - **Left/Right** move by word and select it; **Up/Down** move the word
    selection between lines. **Alt** and **Cmd** behave the same as no modifier,
    and adding **Shift** to any arrow grows the selection outward — by a word
    (Left/Right) or a line (Up/Down).
  - The word under the cursor is selected, so its other occurrences are
    highlighted; **Alt-click** toggles a word's selection.
  - In insert mode, **Cmd+Left/Right** move by word (matching
    **Alt+Left/Right**) rather than jumping to the line start/end.
- **Entity highlights** — attach a persistent gold highlight to text, with a
  small **"entity"** label shown in the gap below the line. In command mode
  press **`e`** (or **`Cmd+e`**) to toggle the highlight on the current word
  selection(s); in insert mode press **`Cmd+e`** to toggle it on the word(s) the
  cursor is on. The same gesture over already-highlighted text removes it, and
  **`Backspace`** / **`Cmd+Backspace`** remove the highlight under the
  cursor/selection. Highlights stick to their text through edits.
- **Multiple cursors** — add or remove a cursor with **Alt-click** or
  **Cmd-click**.
- **Automatic light/dark theme** that follows the OS `prefers-color-scheme` and
  updates live when it changes.
- **Local autosave** — the document and its entity highlights are persisted to
  `localStorage` and restored on reload.
