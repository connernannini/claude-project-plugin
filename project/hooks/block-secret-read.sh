#!/bin/bash
# PreToolUse hook (Read): blocks the Read tool from opening API-key / secret files,
# so secret VALUES never enter the conversation context.
#
# Protected location is whatever the user configured at /project-onboard, recorded
# as a path or glob (one line) in ~/.claude/project-secrets-path. If that pointer is
# absent (onboarding not run yet), it falls back to the common ~/.config/<system>/.env
# convention so there is sensible protection out of the box.
#
# Companion to block-secret-bash-read.sh (which guards the Bash tool).

FILE_PATH=$(jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

GLOB=""
PTR="$HOME/.claude/project-secrets-path"
if [ -f "$PTR" ]; then
  GLOB=$(sed -n '1p' "$PTR" | sed 's/[[:space:]]*$//')
fi
[ -z "$GLOB" ] && GLOB="$HOME/.config/*/.env*"

# Expand a leading ~ to the home directory.
case "$GLOB" in
  "~/"*) GLOB="$HOME/${GLOB#\~/}" ;;
  "~")   GLOB="$HOME" ;;
esac

# Unquoted $GLOB on the right of [[ == ]] is treated as a pattern (so * is a wildcard).
# First clause: the path matches the secrets glob directly. Second: the path lives under
# a configured secrets directory.
if [[ "$FILE_PATH" == $GLOB ]] || [[ "$FILE_PATH" == $GLOB/* ]]; then
  echo '{"decision": "block", "reason": "This matches your configured secrets location, so it looks like an API-key / secret file. Secret files must be sourced in Bash (source <your .env>), not read directly, so their values never enter conversation context. To change which location is protected, re-run /project-onboard."}'
  exit 2
fi

exit 0
