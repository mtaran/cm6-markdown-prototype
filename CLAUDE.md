# Project guidance for agents

This is a single-file CodeMirror 6 Markdown editor prototype. All application
code lives in `index.html` (HTML + CSS + an inline ES module). There is no build
step, package manager, or server — dependencies load at runtime from esm.sh via
the import map in `index.html`.

## Keep README.md in sync — required

`README.md` contains the canonical, user-facing listing of features and
functionality. **Any commit that adds, removes, or changes user-facing
functionality MUST include a corresponding edit to `README.md` in the same
commit.**

This includes (non-exhaustive):
- Adding, removing, or changing an editor feature, keybinding, or command.
- Changing theming, persistence, or default behavior.
- Changing how the app is run or what it depends on.

Internal-only refactors that do not change observable behavior do not require a
README change, but if in doubt, update it.

When you change functionality, update the relevant section of `README.md` (don't
just append) so the listing stays accurate and well-organized.

### Keep it minimal

`README.md` must stay minimal — every word there for a reason. List **only**
functionality that was deliberately built or specifically requested for this
project. Do **not** document stock CodeMirror behavior that comes for free and
wasn't specifically asked for (e.g. undo history, line numbers, code folding,
bracket matching, autocompletion, search). When in doubt, leave it out. Prefer a
short bullet per feature over prose; no "Running"/"Implementation notes"
boilerplate unless it earns its place.

## Standard delivery flow: branch → PR → merge

Every change ships through a pull request. This is the default for **every**
change — do not ask which delivery method to use:

1. Create a feature branch.
2. Commit the change (including any required `README.md` update — see above).
3. Push the branch to `origin`.
4. Open a PR with `gh`.
5. Merge the PR (squash) and delete the branch.

**Code review happens post-merge**, not as a blocking gate before merge, so
merging your own PR as part of completing a task is expected. Committing
directly to `main` is not the standard flow.

## Commit early and often — a change isn't "done" until it's merged

- Commit in small, logical increments rather than batching everything into one
  large commit at the end. Commit early and often.
- A change is **not "done" until it has been committed, pushed, and merged.** A
  working tree edit, an uncommitted change, or an unpushed/unmerged commit is
  work in progress — never report it as complete.
- Treat "done" as a claim about the merged state of the repository, not about
  your local working copy.
