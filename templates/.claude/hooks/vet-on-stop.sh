#!/usr/bin/env bash
# Stop hook: when the agent wants to finish, make sure `go vet` is clean.
# Exit code 2 blocks stopping and feeds the vet output back so the agent fixes it.
input=$(cat)

# Avoid infinite loops: if we're already continuing because of this hook, let it stop.
if [[ "$(jq -r '.stop_hook_active // false' <<<"$input")" == "true" ]]; then
  exit 0
fi

# Only check when Go files changed.
if ! git status --porcelain | grep -q '\.go$'; then
  exit 0
fi

if ! out=$(go vet ./... 2>&1); then
  echo "go vet failed. Fix these before finishing:" >&2
  echo "$out" | tail -40 >&2
  exit 2
fi
exit 0
