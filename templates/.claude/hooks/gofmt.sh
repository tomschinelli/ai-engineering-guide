#!/usr/bin/env bash
# PostToolUse hook: format Go files right after the agent edits them.
# Hook input is JSON on stdin; requires jq.
f=$(jq -r '.tool_input.file_path // empty')
if [[ "$f" == *.go && -f "$f" ]]; then
  gofmt -w "$f"
fi
exit 0
