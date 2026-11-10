---
name: spec
description: Turn a feature idea into a written spec by interviewing the user. Use when starting a new feature or when requirements are vague. Writes .scratch/specs/<feature>.md (gitignored) and no code.
disable-model-invocation: true
---

# Write a spec

Goal: a short, concrete spec the user approves before any planning or code.

1. Read CLAUDE.md and skim related code (read-only) so your questions are informed.
2. Interview the user. Ask 2–4 focused questions per round about:
   - the problem and who it's for
   - scope and **non-goals**
   - concrete behaviour: inputs → outputs, error cases, edge cases
   - constraints (performance, compatibility, dependencies, security)
   Propose sensible defaults instead of asking open-ended questions where you can.
3. Repeat until there are no open questions that would change the design.
4. Write `.scratch/specs/<feature-slug>.md` (gitignored working file, never committed) using the structure:
   Problem/goal · Scope · Non-goals · Behaviour (table of examples) · Acceptance criteria (checkboxes) · Constraints · Open questions
   Advanced setup, only if the user asks for the spec as an issue: use the same structure as the issue body, show it, and after
   confirmation create it with `gh issue create --title "Spec: <feature>" --body-file <tmp file>`.
5. Acceptance criteria must be checkable. Each one should map to a test.
6. If there's no GitHub issue tracking this feature yet, offer to open one (title, 3 lines: idea, why, scope).
   Show it and create it only after confirmation.
7. STOP. Show the spec path (or issue URL) and a 3-line summary. Don't plan or implement until the user approves.
