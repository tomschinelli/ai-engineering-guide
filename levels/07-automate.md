# L7 — Automate

**Goal:** Run the agent **without you at the keyboard**: in scripts, in CI, on a schedule, or inside your own tools.
The same principles apply. Only the trigger changes.

> Automation multiplies whatever your process already is. Automate after the manual workflow is reliable, not before.

---

## 1. The automation ladder

```mermaid
flowchart LR
    H[Headless CLI<br/>claude -p] --> CI[CI / GitHub Actions<br/>review, @claude] --> SCH[Scheduled agents<br/>routines, cron] --> SDK[Agent SDK<br/>your own agents]
```

| Rung | Trigger | Typical use |
|---|---|---|
| Headless `claude -p` | You / a script | Fan-out, batch edits, pre-commit checks |
| GitHub Actions | PR, issue, `@claude` comment | Automated PR review, issue → PR |
| Scheduled | Cron / schedule | Nightly dependency check, weekly tech-debt report |
| Agent SDK | Your code | Custom internal agents and tools |

---

## 2. Headless mode

`-p` (print mode) runs one task non-interactively and exits.

```bash
# simple question
claude -p "Summarise what changed on this branch vs main" 

# machine-readable, restricted tools, bounded
claude -p "Run go vet ./... and fix any issues" \
  --allowedTools "Read,Edit,Bash(go vet:*),Bash(go build:*)" \
  --permission-mode acceptEdits \
  --max-turns 15 \
  --output-format json > result.json

# pipe input
git diff main...HEAD | claude -p "Review this diff for bugs. Output a markdown list."
```

Fan-out from a script (pattern from L6):

```bash
#!/usr/bin/env bash
set -euo pipefail
for f in $(grep -rl 'errors.New("not found")' --include='*.go' internal/); do
  claude -p "In $f, replace ad-hoc not-found errors with store.ErrNotFound \
following the pattern in internal/store/errors.go. Run go build ./... after." \
    --allowedTools "Read,Edit,Bash(go build:*)" --max-turns 10 \
  || echo "FAILED: $f" >> failed.txt
done
go test ./...
```

**Headless rules:**

- **Always restrict tools** with `--allowedTools`. Never use broad permissions in automation.
- **Bound it:** `--max-turns`, timeouts in CI.
- **Verify outside the agent:** the script runs the tests, not just the agent's word.
- **Run in a sandbox/container** when it can execute commands on untrusted input.

> Once a script needs real logic (branching on results, custom tools, approval callbacks, structured output),
> switch from bash + `claude -p` to the **Agent SDK** (section 5).

---

## 3. GitHub Actions

Set it up from a session with `/install-github-app` (installs the GitHub app and adds the API key secret),
or by hand with [`templates/.github/workflows/claude.yml`](../templates/.github/workflows/claude.yml).

```mermaid
sequenceDiagram
    participant You
    participant GH as GitHub
    participant CI as Action (claude-code-action)
    You->>GH: open PR / comment "@claude fix the failing test"
    GH->>CI: trigger workflow
    CI->>CI: checkout, run Claude with repo CLAUDE.md
    CI->>GH: review comments / commits / PR
    GH-->>You: notification
    You->>GH: review + merge (human gate)
```

Two workflows that pay off for a solo developer:

| Workflow | Trigger | What it does |
|---|---|---|
| **Auto review** | `pull_request` opened/synchronised | Reviews the diff against your checklist, comments inline |
| **@claude** | Comment containing `@claude` on issue/PR | Implements small fixes, answers questions, pushes to a branch |

Keep a **human merge gate**: CI may comment and push to branches, but **you** merge.
Branch protection on `main` (required status checks: `go test`, `go vet`, lint) makes that enforceable.

---

## 4. Scheduled agents

For recurring work, run the agent on a schedule:

- **Cloud routines** (`/schedule` in Claude Code): an agent runs on a cron in the cloud against your repo.
- **GitHub Actions `schedule:`** with the action from above.
- **`/loop`** inside a session for short-lived polling ("check the deploy every 5 min").

Good scheduled jobs produce **reports or PRs, never direct changes to main**:

- Weekly: "Check `go list -m -u all` for outdated deps. Open a PR for patch/minor updates if tests pass."
- Nightly: "Run `govulncheck ./...`. If anything is found, open an issue with details."
- Weekly: "Find TODOs older than 90 days (git blame) and post a summary issue."

---

## 5. Claude Agent SDK: build your own agents

The Agent SDK is Claude Code packaged as a **library**: the same agent loop, built-in tools (Read, Edit, Bash, Grep, …),
permissions, hooks, subagents, MCP, sessions, and your project's `.claude/` skills and `CLAUDE.md`, driven from your own code.
It's the recommended way to build custom agents. Use it when a bash loop around `claude -p` isn't enough anymore.

```mermaid
flowchart LR
    APP[Your agent program<br/>TypeScript] -->|"query({ prompt, options })"| SDK[Agent SDK<br/>Claude Code harness]
    SDK --> TOOLS[Built-in tools<br/>+ your custom tools]
    SDK --> GATE[Permissions /<br/>canUseTool / hooks]
    SDK --> REPO[(Target repo<br/>e.g. shorty in Go)]
    SDK -->|message stream| APP
```

### Choosing a language: TypeScript for the agent, any language for the project

The SDK exists for **TypeScript** and **Python**. The agent you build is a separate tool from the project it works on:
a TypeScript agent can maintain a Go codebase. Recommendation:

| | Recommended | Why |
|---|---|---|
| Agent tooling | **TypeScript** (Python is just as good if you prefer it) | Most complete SDK surface (some options are TS-only); Zod gives typed tool inputs |
| Target project | Whatever you build (Go for shorty) | The agent runs `go test`, `go vet` etc. like you would |
| Other languages (e.g. Go programs) | `claude -p --output-format json` as a subprocess | The official route when you can't use TS/Python |

Keep agents in their own folder or repo (e.g. `tools/agents/`) with their own `package.json`, tests, and README.

### Setup

```bash
mkdir -p tools/agents && cd tools/agents
npm init -y && npm pkg set type=module
npm install @anthropic-ai/claude-agent-sdk zod
npm install --save-dev tsx typescript
export ANTHROPIC_API_KEY=...        # the SDK does not read .env files by itself
```

### Example 1: a read-only test triage agent

```typescript
// tools/agents/triage.ts — usage: npx tsx triage.ts ../../shorty
import { query } from "@anthropic-ai/claude-agent-sdk";

const repo = process.argv[2] ?? ".";

for await (const message of query({
  prompt: "Run `go test ./... 2>&1 | tail -80`. For each failure, explain the likely cause with file:line. Do not edit files.",
  options: {
    cwd: repo,
    allowedTools: ["Read", "Grep", "Glob", "Bash(go test:*)"], // pre-approved
    disallowedTools: ["Edit", "Write"],                         // removed entirely: read-only agent
    permissionMode: "default",
    maxTurns: 20,
  },
})) {
  if (message.type === "result") {
    console.log(message.subtype === "success" ? message.result : `Agent stopped: ${message.subtype}`);
  }
}
```

### Example 2: custom tools and an approval gate

Custom tools are plain functions exposed through an in-process MCP server. Use them to give the agent
**narrow, safe capabilities** instead of broad shell access.

```typescript
// tools/agents/coverage.ts
import { query, tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const run = promisify(execFile);
const repo = process.argv[2] ?? ".";

// A narrow tool: coverage for ONE package, nothing else.
const coverage = tool(
  "package_coverage",
  "Run Go tests with coverage for a single package and return the coverage summary",
  { pkg: z.string().regex(/^\.\/[\w\/.-]+$/).describe("Go package path, e.g. ./internal/store") },
  async ({ pkg }) => {
    try {
      const { stdout } = await run("go", ["test", "-cover", pkg], { cwd: repo });
      return { content: [{ type: "text", text: stdout }] };
    } catch (err: any) {
      return { content: [{ type: "text", text: `go test failed:\n${err.stdout ?? err.message}` }], isError: true };
    }
  },
  { annotations: { readOnlyHint: true } },
);

const goTools = createSdkMcpServer({ name: "go", version: "1.0.0", tools: [coverage] });

for await (const message of query({
  prompt: "Find the 3 packages with the lowest coverage and write missing table-driven tests for the most important one.",
  options: {
    cwd: repo,
    mcpServers: { go: goTools },
    allowedTools: ["Read", "Grep", "Glob", "mcp__go__package_coverage"],
    // Everything not pre-approved (e.g. Edit, Write) goes through this callback: your approval gate.
    canUseTool: async (toolName, input) => {
      const path = String((input as any).file_path ?? "");
      if ((toolName === "Edit" || toolName === "Write") && path.endsWith("_test.go")) {
        return { behavior: "allow", updatedInput: input };
      }
      return { behavior: "deny", message: "This agent may only write *_test.go files." };
    },
    maxTurns: 40,
  },
})) {
  if (message.type === "result") console.log(message.subtype === "success" ? message.result : message.subtype);
}
```

<details>
<summary>Python equivalent (minimal)</summary>

```python
# pip install claude-agent-sdk
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage

async def main():
    options = ClaudeAgentOptions(
        cwd="../../shorty",
        allowed_tools=["Read", "Grep", "Glob", "Bash(go test:*)"],
        disallowed_tools=["Edit", "Write"],
        max_turns=20,
    )
    async for message in query(prompt="Run go test ./... and explain failures with file:line.", options=options):
        if isinstance(message, ResultMessage):
            print(message.result)

asyncio.run(main())
```
</details>

*(API as of writing. Check the [Agent SDK docs](https://code.claude.com/docs/en/agent-sdk/overview) and changelogs for the current interface.)*

### Agent SDK best practices

```mermaid
flowchart TD
    J[1 · Define ONE job<br/>with a clear done-criterion] --> T[2 · Minimal tools<br/>narrow custom tools > raw Bash]
    T --> P[3 · Permissions<br/>allowlist + canUseTool gate]
    P --> B[4 · Bounds<br/>maxTurns, timeouts, budget]
    B --> V[5 · Verify outside the agent<br/>tests / checks in your code]
    V --> O[6 · Observe<br/>log messages + result + cost]
    O --> E[7 · Evaluate<br/>run on known cases before trusting it]
```

| Practice | Why |
|---|---|
| **One agent, one job** ("triage failing tests", "write missing tests") | Focused prompts and tools beat general-purpose agents |
| **Narrow custom tools over raw `Bash`** | Validated inputs (Zod), predictable outputs, much smaller attack surface |
| **Allowlist + `canUseTool`** as the approval gate | Encodes your rules ("only `_test.go` files") in code, not in the prompt |
| **Read-only by default** (`disallowedTools: ["Edit","Write"]`) | Add write access only for agents whose job needs it |
| **Bound every run** (`maxTurns`, process timeout) | No runaway loops or surprise bills |
| **Reuse the project's `.claude/`** (CLAUDE.md, skills) | The SDK loads them like Claude Code does, so one source of truth for conventions |
| **Verify in code after the run** (`go test ./...` yourself) | Don't rely on the agent's own "success" |
| **Log the message stream and the final result** (including cost/usage) | Debugging and cost tracking |
| **Write output to a branch/PR, never main** | Same human gate as everywhere else |
| **Keep a small eval set** (repos/cases with known answers) and rerun it after changing prompts or tools | Agents regress silently |
| **Secrets via env/secret manager, never in prompts** | Prompt-injection safety ([Security](../practices/security.md)) |

**When to use which:**

| Need | Use |
|---|---|
| One-off or scripted coding tasks | `claude -p` |
| PR/issue automation | GitHub Action |
| Your own internal tool that needs a coding/filesystem agent (triage bot, test writer, migration assistant) | **Agent SDK (TypeScript)** |
| A program in another language that needs a coding agent | `claude -p --output-format json` as a subprocess |
| A product feature that calls Claude with your own tools (no filesystem agent) | Claude API + tool use (Anthropic client SDK for your language, e.g. Go) |
| Anthropic should host the agent and its sandbox | Managed Agents (Claude API) |

---

## 6. Guardrails for unattended agents

```mermaid
flowchart TD
    IN[Untrusted input<br/>issues, PR text, web pages] --> AG[Agent]
    AG --> SB[Sandbox / container<br/>no prod creds]
    SB --> OUT[Output: comment, branch, PR]
    OUT --> HG{Human gate<br/>review + merge}
    HG --> MAIN[main]
```

- **Least privilege:** scoped tokens, `--allowedTools` allowlist, read-only where possible.
- **Prompt injection is real:** issue text, PR descriptions, web pages, and dependency READMEs can contain instructions. Don't give an agent that reads untrusted input access to secrets or the ability to push to main.
- **Bounded:** max turns, timeouts, budget alerts.
- **Observable:** keep logs and JSON output, and review what automated runs actually did.
- **Human gate before production.** Always.

More in [Security & permissions](../practices/security.md).

---

## 7. Exercise

1. Write a headless script that runs `/code-review`-style review on `git diff main...HEAD` and saves it as `review.md`.
2. Add [`templates/.github/workflows/claude.yml`](../templates/.github/workflows/claude.yml) to shorty, open a PR, see the review, and try an `@claude` comment.
3. Set up one scheduled job (govulncheck or dependency updates) that opens an issue or PR.
4. Build the TypeScript triage agent (Example 1) in `tools/agents/`, run it against shorty with a deliberately broken test,
   then extend it with one narrow custom tool and a `canUseTool` gate (Example 2).

---

## Level up when… (you're there)

- [ ] Every PR gets an automated review before you look at it
- [ ] Repetitive maintenance runs on a schedule and reports through issues/PRs
- [ ] All automation runs with least privilege, bounded turns, and a human merge gate
- [ ] You can choose between `claude -p`, Actions, routines, Agent SDK and the raw API for a given problem
- [ ] You keep improving the loop: memory, skills, and hooks evolve from what automation runs show you

→ Keep going: [Best practices](../practices/best-practices.md) · [Anti-patterns](../practices/anti-patterns.md) · [Staying sharp](../practices/staying-sharp.md)
