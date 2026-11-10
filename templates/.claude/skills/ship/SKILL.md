---
name: ship
description: Verify, self-review and open a GitHub PR for the current branch. Use when a feature branch is ready for review.
disable-model-invocation: true
---

# Ship the current branch

1. Make sure we're not on `main`. If we are, stop and ask for a branch name.
2. Run the definition of done and show output:
   `gofmt -l . && go vet ./... && go test ./... -race`
   If anything fails, stop and report. Don't open a PR with failing checks.
3. Self-review `git diff main...HEAD` against templates/review-checklist.md
   (or docs/review-checklist.md if present). List any findings and fix the clear ones.
   Ask before fixing anything that changes behaviour.
4. Check for leftovers: TODO/FIXME added in this branch, debug prints, commented-out code, new deps in go.mod.
5. Push the branch (`git push -u origin HEAD`). This asks for permission, which is expected.
6. Open a PR with `gh pr create` containing:
   - **What**: 2–4 bullets
   - **Why**: link to docs/specs/<feature>.md or the issue
   - **How it was verified**: commands + results
   - **Risks / follow-ups**
7. Output the PR URL. Remind the user to self-review it on GitHub before merging.
