# Spec: <feature name>

- **Status:** draft | approved | done
- **Date:** YYYY-MM-DD
- **Related:** <issue link, ADRs>

## Problem / goal
<Why are we doing this? What's the pain or the opportunity? 2–4 sentences.>

## Scope
- <what's included>

## Non-goals
- <what we deliberately do NOT do in this change. Prevents scope creep.>

## Behaviour
<Concrete examples. Inputs → outputs. Prefer tables and examples over prose.>

| Case | Input | Expected |
|---|---|---|
| happy path | `POST /links {"url":"https://go.dev"}` | 201, `{"code":"abc123"}` |
| invalid url | `{"url":"ftp://x"}` | 400, `{"error":"invalid url"}` |
| <edge case> | | |

## Acceptance criteria
<Checkable statements. Each one should become one or more tests.>
- [ ] <criterion 1>
- [ ] <criterion 2>

## Constraints
- <performance, compatibility, dependencies, security>

## Open questions
- <unresolved points. Resolve them before approving.>
