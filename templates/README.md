# Templates

Copy into a Go project and adapt. Each file is introduced in a level of the guide.

```bash
PROJECT=~/repos/my-project
cp templates/CLAUDE.md               "$PROJECT/CLAUDE.md"          # L2: then trim/adapt!
mkdir -p "$PROJECT/docs/specs" "$PROJECT/docs/plans"
cp templates/spec.md                 "$PROJECT/docs/specs/TEMPLATE.md"   # L3
cp templates/plan.md                 "$PROJECT/docs/plans/TEMPLATE.md"   # L3
cp templates/review-checklist.md     "$PROJECT/docs/review-checklist.md" # L1/L4
cp -r templates/.claude              "$PROJECT/"                         # L5/L6: settings, hooks, skills, agents
chmod +x "$PROJECT"/.claude/hooks/*.sh
mkdir -p "$PROJECT/.github/workflows"
cp templates/.github/workflows/claude.yml "$PROJECT/.github/workflows/"  # L7
```

| Path | Level | Purpose |
|---|---|---|
| `CLAUDE.md` | L2 | Project memory: commands, architecture, conventions, definition of done |
| `spec.md` | L3 | What & why, with acceptance criteria |
| `plan.md` | L3 | Step-by-step implementation plan |
| `review-checklist.md` | L1, L4 | Review every AI diff |
| `.claude/settings.json` | L0, L5 | Permissions allow/ask/deny + hooks |
| `.claude/hooks/gofmt.sh` | L5 | Format Go files after each edit |
| `.claude/hooks/protect-files.sh` | L5 | Block edits to secrets, go.sum, generated/vendored files |
| `.claude/hooks/vet-on-stop.sh` | L5 | Agent can't finish while `go vet` fails |
| `.claude/skills/spec/` | L5 | `/spec`: interview → spec |
| `.claude/skills/grill-me/` + `grilling/` | L3, L5 | `/grill-me`: harden spec + plan before you approve ([source](https://claudemarketplaces.com/skills/mattpocock/skills/grill-me), copied verbatim) |
| `.claude/skills/improve-codebase-architecture/` | L4 | `/improve-codebase-architecture`: find shallow modules, design a deeper interface, write a refactor RFC to `issues/` (vendored verbatim) |
| `.claude/skills/tdd/` | L5 | `/tdd`: test-first implementation with a review stop |
| `.claude/skills/ship/` | L5 | `/ship`: verify, self-review, open PR |
| `.claude/agents/go-reviewer.md` | L6 | Independent fresh-context reviewer |
| `.claude/agents/test-writer.md` | L6 | Tests / characterisation tests |
| `.github/workflows/claude.yml` | L7 | PR auto-review + `@claude` mentions |

Requirements for the hooks: `jq`, `gofmt`/`go` on PATH.

Introduce these **gradually**, at the level where they're explained. Dropping everything into a project on day one
is a reliable way to get overwhelmed.
