# Skills

Own skills (`spec`, `tdd`, `ship`): copy them into your project's `.claude/skills/`.

## Matt Pocock's skills: install from his repo, not from here

`grill-me`, `grilling`, `to-tickets` and `improve-codebase-architecture` come from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT). The copies here are only so you can **read** them
alongside the guide. They're pinned snapshots and won't get his updates.

Easiest: install his whole set as a Claude Code plugin (updates itself), then run `/setup-matt-pocock-skills`
once per repo:

```sh
claude plugin install mattpocock-skills@claude-plugins-official
```

That gives you the [fast-track workflow](../../../practices/pocock-workflow.md): `setup-matt-pocock-skills`,
`grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `code-review` (plus `tdd`, `grilling`, … they call).
Pick the plugin **or** the single installs below, not both, or you get every skill twice.

Or install single skills globally (all your projects) from his repo:

```sh
npx -y skills add mattpocock/skills --skill grill-me --agent claude-code -g
npx -y skills add mattpocock/skills --skill improve-codebase-architecture --agent claude-code -g
npx -y skills add mattpocock/skills --skill to-tickets --agent claude-code -g
npx -y skills add mattpocock/skills --skill setup-matt-pocock-skills --agent claude-code -g
```

Flags change; check `npx skills add --help`. Upstream names and contents may differ from the copies here
(e.g. `prd-to-issues` became `to-tickets`).
`to-tickets` reads its tracker and labels from `/setup-matt-pocock-skills`: run that once per project first. Each folder's `SOURCE.md` says which upstream version was copied.
