# tip-of-the-day MOTD nudge.
# Shows one tip on the first interactive shell of each half-day (first shell of the
# morning, and first after noon). Tips live in tips.txt next to this file.
# Manual: `tip` shows the next one on demand; `tip -r` a random one; `tip all` dumps all.

# Resolve the real dir even though this file is symlinked into ~/.zsh/ (:A resolves symlinks).
_TIP_DIR="${${(%):-%x}:A:h}"
_TIP_FILE="$_TIP_DIR/tips.txt"
_TIP_STATE="${XDG_CACHE_HOME:-$HOME/.cache}/tip-of-day"

# Print the tip at a given 0-based index (modulo count). Args: <index>
_tip_show() {
  [ -r "$_TIP_FILE" ] || return
  local -a tips
  tips=("${(@f)$(grep -vE '^\s*(#|$)' "$_TIP_FILE")}")
  local n=$#tips
  (( n > 0 )) || return
  local i=$(( ($1 % n + n) % n ))
  local line="${tips[$((i+1))]}"          # zsh arrays are 1-based
  local tag="${line%%	*}"               # text before first TAB
  local text="${line#*	}"               # text after first TAB
  # NB: real ESC chars via $'...'; never use `print -P` here — PROMPT_SUBST would
  # execute the backticks in the hint line and recurse through tip()/_tip_show().
  local reset=$'\e[0m' dim=$'\e[90m' color
  case "$tag" in
    NUDGE) color=$'\e[33m' ;;             # yellow: installed, you ignore it
    FLAG)  color=$'\e[36m' ;;             # cyan: option for a tool you use
    NEW)   color=$'\e[35m' ;;             # magenta: worth installing
    *)     color=$'\e[37m' ;;
  esac
  print -r -- ""
  print -r -- "${color}● ${tag}${reset}  ${text}"
  print -r -- "${dim}  (\`tip\` next · \`tip -r\` random · \`tip all\` · edit ${_TIP_FILE/#$HOME/~})${reset}"
}

# Manual command.
tip() {
  mkdir -p "${_TIP_STATE:h}"
  local idx=0
  [ -r "$_TIP_STATE" ] && idx="$(<"$_TIP_STATE")"
  case "$1" in
    all)  grep -vE '^\s*(#|$)' "$_TIP_FILE" | sed $'s/\t/  —  /' ;;
    -r|--random)
          local -a tips; tips=("${(@f)$(grep -vE '^\s*(#|$)' "$_TIP_FILE")}")
          _tip_show $(( RANDOM % $#tips )) ;;
    *)    idx=$(( idx + 1 )); _tip_show "$idx"; print -r -- "$idx" >| "$_TIP_STATE" ;;
  esac
}

# Append a new tip:  tip-add NUDGE "fzf: stop copy-pasting slugs, pipe to fzf"
# Validates the tag, refuses obvious dups. Edit tips.txt directly for bulk changes.
tip-add() {
  local tag="$1"; shift
  local text="$*"
  case "$tag" in
    NUDGE|FLAG|NEW) ;;
    *) print -u2 "tip-add: tag must be NUDGE | FLAG | NEW (got '${tag:-<empty>}')"; return 1 ;;
  esac
  [ -n "$text" ] || { print -u2 "tip-add: missing tip text"; return 1 }
  if cut -f2- "$_TIP_FILE" 2>/dev/null | grep -qiF -- "$text"; then
    print -u2 "tip-add: a tip with this text already exists — not adding"; return 1
  fi
  printf '%s\t%s\n' "$tag" "$text" >> "$_TIP_FILE"
  print -r -- "added [$tag] ($(grep -cvE '^[[:space:]]*(#|$)' "$_TIP_FILE") tips total)"
}

# Auto-show once per half-day on interactive shells. Anonymous function keeps the
# locals from leaking into the user's shell.
if [[ -o interactive ]]; then
  () {
    local slot="$(date +%Y%m%d)-$([ "$(date +%H)" -lt 12 ] && echo am || echo pm)"
    local last=""
    [ -r "$_TIP_STATE.slot" ] && last="$(<"$_TIP_STATE.slot")"
    [[ "$slot" == "$last" ]] && return
    mkdir -p "${_TIP_STATE:h}"
    local idx=0
    [ -r "$_TIP_STATE" ] && idx="$(<"$_TIP_STATE")"
    idx=$(( idx + 1 ))
    _tip_show "$idx"
    print -r -- "$idx"  >| "$_TIP_STATE"
    print -r -- "$slot" >| "$_TIP_STATE.slot"
  }
fi
