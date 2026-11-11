<!--
Only what the agent would get wrong, or would waste effort finding out again every session:
commands, boundaries, gotchas, definition of done, a short map of what isn't obvious from the code.
Leave out what's in go.mod, folder listings, generic advice, and style the linter enforces.
Reference deep docs by plain path + "read when…". Don't @-import them (imports load in full every session).
-->
# <Project name>

<One or two sentences: what this is and who uses it.>

## Commands
- Build: `go build ./...`
- Run locally: `go run ./cmd/<app>` (listens on :8080)
- Test all: `go test ./... -race`
- Integration (needs Docker): `go test -tags=integration ./... -race`
- Test one: `go test ./internal/<pkg> -run TestName -v`
- Lint: `go vet ./... && golangci-lint run`
- Format: `gofmt -w .` (a hook runs this after edits)

## Architecture
- Flow: router → handler (`internal/http`) → domain service (`internal/<domain>`) → `Store` interface (`internal/store`)
- `cmd/<app>/` is wiring only. Domain packages never import HTTP or SQL.
- docs/architecture.md: read before adding a package or changing how packages depend on each other

## Conventions
- Errors: wrap with `fmt.Errorf("doing x: %w", err)`; compare with `errors.Is/As`, never strings.
- Handlers return errors; `internal/http/respond.go` maps them to status codes.
- No global state. Pass dependencies via constructors.
- Time and randomness are injected (`internal/clock`) so tests are deterministic.
- Prefer stdlib.
- Simplest solution that works. No new abstractions unless asked.
- Deep modules: small exported API, behaviour hidden behind it. Don't export something just to test it.

## Testing
- Table-driven tests with `t.Run`. HTTP via `httptest`.
- Test through the public API (`package foo_test`). Fakes only at external edges (DB, network, time).
- Every fake passes the same contract suite as the real adapter (testcontainers). Every endpoint has an `httptest` e2e test.
- Tests that need Docker (testcontainers) go in `*_integration_test.go` with `//go:build integration`. Everything else stays untagged and fast.
- New behaviour → tests first (see /tdd skill).
- Never modify or skip existing tests to make them pass. Fix the code or ask.

## Definition of done
1. `gofmt -l .` prints nothing
2. `go vet ./...` clean
3. `go test ./... -race` passes
   - Touched a store, client or handler? Also `go test -tags=integration ./... -race`
4. No TODOs/stubs left unless explicitly agreed
5. Summary lists what changed and how it was verified

## Workflow
- Work on a branch; one commit per logical step.
- Conventional Commits: `type(scope): summary` (feat, fix, perf, refactor, test, docs, chore, ci, build).
  The squash-merged PR title decides the next version.
- Breaking = an existing client or deployment breaks without changing anything (API field/endpoint/status code,
  env var, required config, incompatible migration). Mark with `!` + a `BREAKING CHANGE:` footer. Unsure? Ask.
- Non-trivial work: plan first (plan mode), wait for approval.
- Work items (backlog, tickets, TODOs) live in GitHub issues, never as files in the repo.
- Specs and plans are working files in .scratch/specs/ and .scratch/plans/ (gitignored). Never commit them, and don't
  treat an old one as current: the code, tests and docs/ win. Templates: docs/templates/.

## Boundaries
- Ask before adding a dependency.
- Never edit an applied migration in `migrations/`; add a new one.
- <e.g. `internal/legacy/` is frozen. Bug fixes only, no refactors.>

## Gotchas
<!-- Add a line each time the agent makes a mistake that will recur. Delete lines that no longer apply. -->
- <e.g. Integration tests need Docker running (testcontainers).>
