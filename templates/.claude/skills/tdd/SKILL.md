---
name: tdd
description: Implement a change test-first in Go. Use when adding new behaviour or fixing a bug that can be reproduced by a test.
---

# Test-driven change

1. Restate the desired behaviour as a short list of acceptance criteria.
   If a spec exists in .scratch/specs/ or the GitHub issue, use its criteria. Ask if anything is ambiguous.
2. Agree on the public interface first: propose the smallest exported API (deep module) that covers the criteria,
   list what stays unexported, and get the user's OK. Skip if the interface already exists.
3. Write failing tests:
   - test only through the public API (`package foo_test`), no tests for unexported helpers
   - fakes only at external edges (DB, network, time), no mocks of internal parts
   - table-driven, `t.Run(tc.name, ...)`
   - cover happy path, invalid input, boundaries, and error cases
   - inject time/randomness, no sleeps
   - do NOT write implementation code yet
4. Run the tests (`go test ./<pkg> -run <TestName> -v`) and show that they fail **for the right reason**
   (missing behaviour, not a compile error in the test itself).
5. STOP. Show the test file and wait for the user to approve the tests.
6. After approval, commit the tests: `test: add tests for <behaviour>`.
7. Implement the minimal code to make the tests pass. **Never modify the approved test files.**
   Don't export anything beyond the agreed interface.
   If a test seems wrong, stop and explain why instead of changing it.
8. Run the definition of done:
   `gofmt -l . && go vet ./... && go test ./... -race`
   Iterate until clean.
9. Refactor only if it clearly improves the code, keeping tests green.
10. Summarise: what changed, full test output, anything left open.
