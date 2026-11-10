# <Project name>

<One or two sentences: what this is and who uses it.>

## Commands
- Build: `go build ./...`
- Run locally: `go run ./cmd/<app>` (listens on :8080)
- Test all: `go test ./... -race`
- Test one: `go test ./internal/<pkg> -run TestName -v`
- Lint: `go vet ./... && golangci-lint run`
- Format: `gofmt -w .` (a hook runs this after edits)

## Architecture
- `cmd/<app>/`: main, wiring only
- `internal/http/`: handlers, routing, middleware
- `internal/store/`: persistence behind the `Store` interface
- `internal/<domain>/`: business logic, no HTTP or SQL here
- Flow: router → handler → domain service → store
- More detail: docs/architecture.md (read when changing structure)

## Conventions
- Errors: wrap with `fmt.Errorf("doing x: %w", err)`; compare with `errors.Is/As`, never strings.
- Handlers return errors; `internal/http/respond.go` maps them to status codes.
- No global state. Pass dependencies via constructors.
- Time and randomness are injected (`internal/clock`) so tests are deterministic.
- Prefer stdlib. Ask before adding a dependency.
- Simplest solution that works. No new abstractions unless asked.
- Deep modules: small exported API, behaviour hidden behind it. Don't export something just to test it.

## Testing
- Table-driven tests with `t.Run`. HTTP via `httptest`.
- Test through the public API (`package foo_test`). Fakes only at external edges (DB, network, time).
- New behaviour → tests first (see /tdd skill).
- Never modify or skip existing tests to make them pass. Fix the code or ask.

## Definition of done
1. `gofmt -l .` prints nothing
2. `go vet ./...` clean
3. `go test ./... -race` passes
4. No TODOs/stubs left unless explicitly agreed
5. Summary lists what changed and how it was verified

## Workflow
- Work on a branch; one commit per logical step; conventional commit messages.
- Non-trivial work: plan first (plan mode), wait for approval.
- Specs live in docs/specs/, plans in docs/plans/.

## Gotchas
<!-- Add a line each time the agent makes a mistake that will recur. Delete lines that no longer apply. -->
- <e.g. Integration tests need `docker compose up -d db` first.>
- <e.g. `internal/legacy/` is frozen. Bug fixes only, no refactors.>
