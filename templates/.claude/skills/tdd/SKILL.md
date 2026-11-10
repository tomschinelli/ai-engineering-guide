---
name: tdd
description: Implement a change test-first in Go. Use when adding new behaviour or fixing a bug that can be reproduced by a test.
---

# Test-driven change

1. Restate the desired behaviour as a short list of acceptance criteria.
   If a spec exists in docs/specs/, use its criteria. Ask if anything is ambiguous.
2. Write failing tests:
   - table-driven, `t.Run(tc.name, ...)`
   - cover happy path, invalid input, boundaries, and error cases
   - inject time/randomness, no sleeps
   - do NOT write implementation code yet
3. Run the tests (`go test ./<pkg> -run <TestName> -v`) and show that they fail **for the right reason**
   (missing behaviour, not a compile error in the test itself).
4. STOP. Show the test file and wait for the user to approve the tests.
5. After approval, commit the tests: `test: add tests for <behaviour>`.
6. Implement the minimal code to make the tests pass. **Never modify the approved test files.**
   If a test seems wrong, stop and explain why instead of changing it.
7. Run the definition of done:
   `gofmt -l . && go vet ./... && go test ./... -race`
   Iterate until clean.
8. Refactor only if it clearly improves the code, keeping tests green.
9. Summarise: what changed, full test output, anything left open.
