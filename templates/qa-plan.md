# QA plan: <feature name>

- **Spec:** docs/specs/<feature>.md
- **Commits / PR:** <range or PR link, e.g. `main..feat/link-expiry`>
- **Written by:** agent (fresh session) · **Tested by:** <you> · **Date:** YYYY-MM-DD

> Manual checks for a **human** to run against the real app. This is not the code review
> ([`review-checklist.md`](review-checklist.md)) and not a replacement for automated tests.
> It covers what tests can't easily prove: the feature works end to end, the way a user would hit it.

## Setup
```bash
# exact commands to get a testable app, e.g.
make db-reset && go run ./cmd/shorty
```

## Already covered by automated tests
<Which acceptance criteria have tests, by test name. Don't re-test these by hand unless they're high-risk.>
- <criterion> → `TestXxx`

## Manual test cases
One row per acceptance criterion that needs eyes, plus edge cases. Exact steps, exact expected result.

| # | Criterion / case | Steps | Expected | Result |
|---|---|---|---|---|
| 1 | <happy path> | `curl -i -X POST localhost:8080/links -d '{"url":"https://go.dev","expires_in":"1h"}'` | `201`, body has `expires_at` | ☐ pass ☐ fail |
| 2 | <edge case> | | | ☐ |

## Risk areas
<Where the change touched shared or risky code (migrations, auth, caching, concurrency). What to poke at.>
- <area>: <what could break, how to check>

## Regression spot-checks
<Existing behaviour that must still work.>
- [ ] <e.g. links without expiry still redirect with 302>

## Outcome
- [ ] All cases pass → merge
- Failures → one new ticket each (steps to reproduce, expected vs. actual), back on the board
