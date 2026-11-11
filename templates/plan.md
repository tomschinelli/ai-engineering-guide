# Plan: <feature name>

- **Idea:** .scratch/ideas/<feature>.md or issue #<N>
- **Spec:** .scratch/specs/<feature>.md

> Working file in `.scratch/plans/` (gitignored). Don't commit it. After merge, move lasting decisions into the
> PR/issue (or an ADR in docs/decisions/) and delete this file.
- **Branch:** feat/<feature>
- **Status:** proposed | approved | in progress (step N) | done

## Approach
<3–6 sentences: the design in short, and why this option over alternatives.>

## Steps
<Each step is small, verifiable, and gets its own commit.
Slice vertically: each step is a thin end-to-end path (migration → store → handler → test) you can demo on its own,
not "all the models", then "all the handlers". Every acceptance criterion should be covered by a step. Note blockers if steps could run in parallel: "Blocked by: 1".>

### 1. <step title>
- Covers: <acceptance criteria from the spec>
- Interface: <optional: agreed public API, filled in L4 step 1>
- Files: `internal/...`
- Changes: <what>
- Tests: <which tests are added/changed>
- Verify: `go test ./internal/... -run ...`
- [ ] done

### 2. <step title>
- Covers:
- Interface:
- Files:
- Changes:
- Tests:
- Verify:
- [ ] done

## Risks / open questions
- <data migration, backwards compatibility, performance, unclear requirements>

## Out of scope
- <copied from spec non-goals + anything discovered while planning>

## Log
<Agent/you append notes when reality differs from the plan.>
- YYYY-MM-DD: <deviation and why>
