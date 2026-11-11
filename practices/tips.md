# Tips

Small, general tweaks that make day-to-day work with the agent smoother. Not tied to a level.

---

## Short reports

Add one line to your personal `~/.claude/CLAUDE.md` (all projects) to shorten the agent's long reports:

```markdown
- When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision
```

| Effect | Why it helps |
|---|---|
| Shorter summaries and status updates | Less to read, faster to scan |
| Fewer output tokens | Lower cost, less context used |

It only changes how the agent **reports to you**. Code, docs and commit messages are unaffected.
