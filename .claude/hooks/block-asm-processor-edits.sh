#!/usr/bin/env bash
set -euo pipefail

# stdin: JSON with tool_input containing .file_path for Write/Edit tools,
# or .command for Bash tools.
input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

message="Blocked: do not modify tools/asm-processor for project-specific compile flags. If an object needs different compiler behavior, add a target-specific override in the repo Makefile instead, e.g. set C_OPT and IDO_CC for that object."

if [[ "$file_path" == */tools/asm-processor/* || "$file_path" == tools/asm-processor/* ]]; then
  echo "$message" 1>&2
  exit 2
fi

if [[ -n "$command" ]] && echo "$command" | grep -Eq '(>|>>|tee |sed -i|perl -[0-9A-Za-z]*i|apply_patch|rm |mv |cp |chmod |git checkout|git restore).*(tools/asm-processor|tools/asm-processor/)'; then
  echo "$message" 1>&2
  exit 2
fi

exit 0
