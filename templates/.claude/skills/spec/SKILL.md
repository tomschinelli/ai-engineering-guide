---
name: spec
description: Turn a feature idea into a written spec by interviewing the user. Use when starting a new feature or when requirements are vague. Writes docs/specs/<feature>.md and no code.
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
4. Write `docs/specs/<feature-slug>.md` using the structure:
   Problem/goal · Scope · Non-goals · Behaviour (table of examples) · Acceptance criteria (checkboxes) · Constraints · Open questions
5. Acceptance criteria must be checkable. Each one should map to a test.
6. STOP. Show the spec path and a 3-line summary. Don't plan or implement until the user approves.
