# Working in a Team

Everything in this guide still applies in a team. The one new thing: the agent's **setup** and its **output** are
now shared. Your `CLAUDE.md` steers your teammates' sessions, and your AI-written PR takes up their review time.

Keep it simple: share the setup through the repo, keep personal stuff local, and keep a human in every merge.

---

## Shared vs. personal

| Shared (commit it) | Personal (gitignored or in your home dir) |
|---|---|
| `CLAUDE.md` | `CLAUDE.local.md`, `~/.claude/CLAUDE.md` |
| `.claude/settings.json` (permissions, hooks) | `.claude/settings.local.json` |
| `.claude/skills/`, `.claude/agents/` | `~/.claude/skills/`, `~/.claude/agents/` |
| `.mcp.json` (project-scope MCP servers) | User-scope MCP servers |

**Rule:** if it changes how the agent behaves for everyone, it goes through a PR. Everything else stays local.
File locations change between versions, so check the [docs](https://code.claude.com/docs) if one doesn't match.

---

## `CLAUDE.md` is team code

- Changes go through a PR and get reviewed like code.
- Keep it short and factual ([L2](../levels/02-project-memory.md#only-what-the-agent-cant-know-by-itself)). Every line costs every teammate context in every session.
- Anyone can add a line when the agent repeats a mistake. Put it in the same PR as the fix.
- Personal taste ("explain before big refactors", "I like short answers") goes into `CLAUDE.local.md` or `~/.claude/CLAUDE.md`, not the shared file.

---

## Work items and handoff

- GitHub issues stay the single source of truth ([where work lives](best-practices.md#where-work-lives)).
- **One owner per issue and branch.** Assign yourself before you (or an AFK loop) start, so two agents never work on the same thing.
- `.scratch/` is personal and gitignored. Anything a teammate needs (decisions, open questions, what's left) goes into the issue or PR.
- Handing over half-done work? Push the branch and write a short status comment on the issue. Don't hand over a chat session.

---

## PRs and review

- **The author owns AI-written code.** Read your own diff before you ask anyone else to.
- Keep PRs small: reviewable in a few minutes ([L1](../levels/01-prompt-verify.md)). Split big agent output into several PRs.
- In the PR description, say **how it was verified**: tests added, commands run, output checked.
- AI review in CI is a first pass ([L7](../levels/07-automate.md)). **A human approves every merge.**
- Reviewers: read the tests first, then the code ([L4](../levels/04-test-first.md)).

---

## Agree on a few rules

Talk once, write it down (in `CLAUDE.md` or the shared settings), then move on:

- [ ] Default permission mode, and which commands are allowed/denied (in `.claude/settings.json`)
- [ ] Who reviews changes to `CLAUDE.md` and `.claude/`
- [ ] Which skills, agents and MCP servers are team standard
- [ ] Secrets policy: deny-listed files, nothing secret in prompts ([Security](security.md))
- [ ] How AFK/CI agent work is labelled, and who merges it
- [ ] Do PRs say when they're mostly AI-written? (Pick one answer and stick to it.)

---

## Team anti-patterns

| Anti-pattern | Fix |
|---|---|
| "Works with my setup": local config nobody else has | Move what matters into the shared `.claude/` via a PR |
| Huge AI-written PR dumped on a reviewer | Split it. Author reviews first. |
| Personal preferences in the shared `CLAUDE.md` | Move them to `CLAUDE.local.md` |
| Two people (or agents) on the same issue | One owner per issue. Assign before starting. |
| Merging because "the AI review passed" | A human approves every merge |
