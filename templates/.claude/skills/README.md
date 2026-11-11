# Skills

Own skills (`spec`, `tdd`, `ship`): copy them into your project's `.claude/skills/`.

## Matt Pocock's skills: install from his repo, not from here

`grill-me`, `grilling`, `prd-to-issues` and `improve-codebase-architecture` come from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT). The copies here are only so you can **read** them
alongside the guide. They're pinned snapshots and won't get his updates.

Install them globally (all your projects) from his repo:

```sh
npx -y skills add mattpocock/skills --skill grill-me --agent claude-code -g
npx -y skills add mattpocock/skills --skill improve-codebase-architecture --agent claude-code -g
```

Flags change; check `npx skills add --help`. Upstream names and contents may differ from the copies here
(e.g. `prd-to-issues` is no longer in his repo). Each folder's `SOURCE.md` says which upstream version was copied.
