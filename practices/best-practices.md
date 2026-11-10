# Best Practices Cheat Sheet

The most common practices in AI-assisted development, grouped by the core loop. Each one links to the level that explains it.

```mermaid
flowchart LR
    C[Context] --> G[Goal] --> A[Agent] --> V[Verify] --> S[Ship]
```

## Context

| # | Practice | Level |
|---|---|---|
| 1 | Every repo has a short, committed `CLAUDE.md` with exact commands and a definition of done | [L2](../levels/02-project-memory.md) |
| 2 | When the agent repeats a mistake, add one line to `CLAUDE.md` | [L2](../levels/02-project-memory.md) |
| 3 | Point to files with `@path` and to examples to imitate ("like `X`") | [L1](../levels/01-prompt-verify.md) |
| 4 | One task per session. `/clear` between unrelated tasks. | [L0](../levels/00-foundations.md) |
| 5 | Link deep docs. Don't paste them. | [L2](../levels/02-project-memory.md) |
| 6 | Use subagents for wide searches to keep the main context clean | [L6](../levels/06-scale.md) |
| 7 | Keep plans and specs in files so they survive `/clear` and compaction | [L3](../levels/03-spec-plan-code.md) |

## Goal

| # | Practice | Level |
|---|---|---|
| 8 | Prompts state *what, where, constraints, done-when* | [L1](../levels/01-prompt-verify.md) |
| 9 | Small tasks: if you can't review the diff in a few minutes, split the task | [L1](../levels/01-prompt-verify.md) |
| 10 | Say what NOT to do (no new deps, don't touch tests, don't refactor X) | [L1](../levels/01-prompt-verify.md) |
| 11 | For non-trivial work: spec → plan mode → review plan → implement | [L3](../levels/03-spec-plan-code.md) |
| 12 | Let the agent interview you to sharpen vague requirements. Optional: let it grill you to harden the spec and plan before you approve. | [L3](../levels/03-spec-plan-code.md) |
| 13 | Write non-goals explicitly to prevent scope creep | [L3](../levels/03-spec-plan-code.md) |

## Agent works

| # | Practice | Level |
|---|---|---|
| 14 | Start from a clean git tree. Commit before every session. | [L0](../levels/00-foundations.md) |
| 15 | Choose the permission mode by risk. Pre-allow safe commands, deny dangerous ones. | [L0](../levels/00-foundations.md) |
| 16 | Stop early (`Esc`) when it's going the wrong way | [L1](../levels/01-prompt-verify.md) |
| 17 | Two failed corrections → `/rewind` or `/clear` and re-prompt | [L1](../levels/01-prompt-verify.md) |
| 18 | Implement plans step by step, one commit per step | [L3](../levels/03-spec-plan-code.md) |
| 19 | Parallel work only in separate worktrees, only for independent tasks | [L6](../levels/06-scale.md) |

## Verify

| # | Practice | Level |
|---|---|---|
| 20 | Read every diff. You own every line. | [L1](../levels/01-prompt-verify.md) |
| 21 | Give the agent a way to check itself: build, vet, tests, running app | [L4](../levels/04-test-first.md) |
| 22 | Tests first for new behaviour. Review the tests harder than the code. | [L4](../levels/04-test-first.md) |
| 23 | Commit tests before implementing so any test tampering shows up | [L4](../levels/04-test-first.md) |
| 24 | Demand evidence: "show me the output", not just "done" | [L1](../levels/01-prompt-verify.md) |
| 25 | Independent review in fresh context (subagent / second session / CI) | [L6](../levels/06-scale.md) |
| 26 | Enforce what must always happen with hooks (format, guards) | [L5](../levels/05-extend.md) |

## Ship

| # | Practice | Level |
|---|---|---|
| 27 | Branch + PR even when solo. Self-review on GitHub. | [L3](../levels/03-spec-plan-code.md) |
| 28 | CI runs tests/lint and an automated review. A human merges. | [L7](../levels/07-automate.md) |
| 29 | Automation gets least privilege, bounded turns, sandboxing | [L7](../levels/07-automate.md) |
| 30 | Encode repeated workflows as skills, and share them as plugins | [L5](../levels/05-extend.md) |

## Always

- **Never paste secrets** into prompts. Deny-list `.env` and credential files. → [Security](security.md)
- **Watch context, not just cost.** A bloated context gives worse answers. → [Context & cost](context-and-cost.md)
- **Understand what you merge.** If you couldn't explain it in a code review, don't merge it. → [Staying sharp](staying-sharp.md)
- **Know the failure modes** so you notice them early. → [Anti-patterns](anti-patterns.md)
