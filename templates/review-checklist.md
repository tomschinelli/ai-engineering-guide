# AI Diff Review Checklist

Use for every AI-written change before you commit or merge. You own every line.

## 1. Intent
- [ ] Does it do what was asked, matching the spec/acceptance criteria?
- [ ] Does it do **only** what was asked? (no drive-by refactors, renames, reformatting)
- [ ] Can I explain every changed line? (If not, ask the agent and keep asking until you can.)

## 2. Correctness
- [ ] Build, vet, lint, and tests pass, **and I saw the output**
- [ ] Edge cases: empty/nil, invalid input, boundaries, duplicates, concurrency
- [ ] Errors are handled, wrapped with context, never swallowed (`_ = err`, empty `if err != nil {}`)
- [ ] No stubs, TODOs, `panic("not implemented")`, or commented-out code
- [ ] All called functions, packages, and flags actually exist (no hallucinated APIs)
- [ ] Resources closed (`defer rows.Close()`, `resp.Body.Close()`), contexts passed through, no goroutine leaks

## 3. Tests
- [ ] New behaviour has tests that would **fail** if the behaviour broke
- [ ] Tests check behaviour, not implementation details or mocks only
- [ ] No existing tests weakened, skipped, or deleted
- [ ] Test diffs reviewed as carefully as code diffs

## 4. Design
- [ ] Follows existing patterns and conventions (CLAUDE.md)
- [ ] Reuses existing helpers instead of duplicating them
- [ ] No unnecessary abstraction, config, or generality
- [ ] Names are clear. Comments explain *why*, not *what*.

## 5. Security
- [ ] Input validated at boundaries. No SQL/command built by string concatenation.
- [ ] No secrets, tokens, or personal data in code, logs, or tests
- [ ] AuthN/AuthZ checks present where needed
- [ ] New dependencies: needed, real, maintained, exact name (typosquatting)

## 6. Housekeeping
- [ ] Docs / CLAUDE.md / spec updated if behaviour or conventions changed
- [ ] Commit message explains *why*
- [ ] PR title is a Conventional Commit, and breaking changes are marked with `!`
- [ ] Anything the agent got wrong that will recur → added to CLAUDE.md
