#!/bin/bash
# Pre-Bash hook: blocks reading the CONTENTS of API-key / secret files via shell commands.
# Companion to block-secret-read.sh (which guards the Read tool).
#
# Policy: the ONLY sanctioned way to use a secret .env file is to `source` it. A command
# that opens the file as INPUT to a reader/interpreter (cat, grep, sed, awk, head, tail,
# less, xxd, strings, an inline python/perl, or a `<` redirection) is blocked so secret
# VALUES never reach output or conversation context.
#
# Protected location is whatever the user configured at /project-onboard, recorded as a
# path or glob (one line) in ~/.claude/project-secrets-path. If that pointer is absent,
# it falls back to the common ~/.config/<system>/.env convention.
#
# Heuristic, designed to MINIMIZE false positives on doc-writing / heredocs / echo:
#   * The command is split into simple-command segments (on ; && || | newline and
#     command-substitution boundaries $( ) and backticks).
#   * The protected-path pattern must appear in the segment.
#   * Rule 1 (read-as-argument): the segment, after optional VAR=val env-prefixes, STARTS
#     with a reader/interpreter, and the path follows with NO `<`/`>` redirection operator
#     in between. The "no redirection between" test is what lets `cat >> file <<EOF ...env...`
#     (a WRITE whose heredoc body merely mentions a path) through, while blocking
#     `cat <secret path>` (a READ).
#   * Rule 2 (redirection-read): `cmd < <secret path>`.
#   * Writers/formatters (echo, printf, tee, dd) are intentionally NOT readers -- they
#     are how docs get written and would otherwise false-positive constantly.
#
# Known gap (accepted, same as the Read hook): variable indirection
# (X=<secret path>; cat "$X"). Guards accidental/casual reads, not a determined actor.

CMD=$(jq -r '.tool_input.command // empty')
[ -z "$CMD" ] && exit 0

# --- Resolve the protected-path pattern (an ERE matched anywhere in a segment) ---------
# Default: the common ~/.config/<system>/.env convention.
DEFAULT_ENVPATH='\.config/[^[:space:]'\'';&|`)<>]*/\.env'
ENVPATH="$DEFAULT_ENVPATH"
PTR="$HOME/.claude/project-secrets-path"
if [ -f "$PTR" ]; then
  RAW=$(sed -n '1p' "$PTR" | sed 's/[[:space:]]*$//')
  if [ -n "$RAW" ]; then
    # Reduce to a path TAIL (strip leading ~/ , $HOME/ ) so it matches no matter how the
    # home portion is written in the command (~ vs absolute path).
    TAIL="$RAW"
    TAIL="${TAIL#\~/}"
    TAIL="${TAIL#"$HOME"/}"
    # Escape ERE metacharacters EXCEPT '*'; then turn each glob '*' into a no-space run.
    TAIL=$(printf '%s' "$TAIL" | sed -E 's/[][(){}.^$+?|\\]/\\&/g')
    TAIL=$(printf '%s' "$TAIL" | sed -E 's/\*/[^[:space:]]*/g')
    [ -n "$TAIL" ] && ENVPATH="$TAIL"
  fi
fi

READERS='cat|tac|nl|grep|egrep|fgrep|rg|ag|sed|awk|gawk|head|tail|less|more|most|view|vi|vim|nano|emacs|xxd|od|hexdump|strings|cut|rev|fold|column|bat|base64'
INTERP='python|python3|perl|ruby|node|php|jq'
ENVPREFIX='([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*'

block() {
  echo '{"decision": "block", "reason": "Reading the contents of your secrets file is not allowed -- it holds API secrets. Source it instead (source <your .env>) so values load into the environment without printing. To check whether a var is set/exported, introspect the environment after sourcing (e.g. env | grep -c NAME), do not read the file."}'
  exit 2
}

# Split into simple-command segments.
SEGMENTS=$(printf '%s' "$CMD" | tr ';|&`' '\n\n\n\n' | sed -E 's/\$\(/\n/g; s/\)/\n/g')

while IFS= read -r seg; do
  [ -z "$seg" ] && continue
  echo "$seg" | grep -Eq "$ENVPATH" || continue   # need the protected path in this segment
  # Rule 1: reader/interpreter at command position, path as input (no >/< between).
  if echo "$seg" | grep -Eq "^[[:space:]]*${ENVPREFIX}(${READERS}|${INTERP})\b[^<>]*${ENVPATH}"; then
    block
  fi
  # Rule 2: redirection feeds the path into a command.
  if echo "$seg" | grep -Eq "<[[:space:]]*[^[:space:]]*${ENVPATH}"; then
    block
  fi
done <<< "$SEGMENTS"

exit 0
