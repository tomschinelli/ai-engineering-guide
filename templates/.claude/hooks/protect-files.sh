#!/usr/bin/env bash
# PreToolUse hook: block edits to files the agent must not touch.
# Exit code 2 blocks the action; stderr is shown to the agent so it can adjust.
f=$(jq -r '.tool_input.file_path // empty')

case "$f" in
  *.env|*.env.*|*/secrets/*)
    echo "Blocked: $f contains secrets. Do not edit it." >&2; exit 2 ;;
  */go.sum)
    echo "Blocked: don't hand-edit go.sum. Run 'go mod tidy' instead." >&2; exit 2 ;;
  */vendor/*|*_gen.go|*.pb.go)
    echo "Blocked: $f is generated/vendored. Change the source and regenerate." >&2; exit 2 ;;
esac
exit 0
