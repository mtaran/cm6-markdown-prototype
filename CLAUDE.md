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
6. **Fast-forward `main` in the primary checkout to the merge commit.** Merging
   the PR only advances `main` on the remote; the primary checkout's local
   `main` still points at the old commit until you update it
   (`git -C <primary-checkout> merge --ff-only origin/main`, or `git pull`).

**Updating the primary checkout's `main` is part of the task — not optional.** A
change is not really done while the primary working copy still shows the
pre-merge state. When you work from a worktree, the worktree is thrown away but
the primary checkout is what the user sees next, so it must end at the merge
commit. (`gh pr merge --delete-branch` run from a worktree also fails its local
cleanup with `'main' is already checked out` — delete the remote branch with
`git push origin --delete <branch>` and fast-forward the primary checkout
manually.)

**Code review happens post-merge**, not as a blocking gate before merge, so
merging your own PR as part of completing a task is expected. Committing
directly to `main` is not the standard flow.

### Delivery pitfalls — read before every PR

These have bitten repeatedly; avoid them:

- **Start each task from a worktree freshly branched off the latest
  `origin/main` — never reuse a worktree (or branch) left over from a previous
  task.** After a squash-merge, your old local branch still holds the
  *unsquashed* commit, so it has diverged from `main`'s history; building the
  next change on top of it produces avoidable merge conflicts. If you're
  continuing in an existing worktree, first `ExitWorktree` and `EnterWorktree`
  again (or otherwise branch from `origin/main`) so you start from a clean base.
  Before your first commit, confirm `git log -1 origin/main` matches the merge
  commit of any work you just shipped.
- **Never pipe `gh pr merge` (or `git push --delete`) into `tail`/`head`/etc.,
  and never chain it with `&&` after such a pipe.** A pipe reports the exit
  status of the *last* command (`tail`), masking a merge failure, so the chain
  proceeds and you delete a branch whose PR never merged. Run `gh pr merge` as
  its own standalone command, check that it actually succeeded (or verify with
  `gh pr view <n> --json state,mergeCommit`), and only then delete the branch
  and fast-forward the primary checkout.

## Commit early and often — a change isn't "done" until it's merged

- Commit in small, logical increments rather than batching everything into one
  large commit at the end. Commit early and often.
- A change is **not "done" until it has been committed, pushed, and merged.** A
  working tree edit, an uncommitted change, or an unpushed/unmerged commit is
  work in progress — never report it as complete.
- Treat "done" as a claim about the merged state of the repository, not about
  your local working copy.
- "Done" also requires that the **primary checkout's `main` has been
  fast-forwarded to the merge commit** (see the delivery flow above). A merged
  PR whose change is not yet reflected in the primary working copy is not done.
