# Personal shell extras, sourced from .zshrc.
# (select-word-style, ls aliases, and p8 live in .zshrc to avoid duplication.)

export EDITOR="mate -w"

# Lazy-load autojump: defers ~0.09s until first use of j/jc/jo.
_lazy_load_autojump() {
  unset -f j jc jo
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
}
j()  { _lazy_load_autojump; j "$@"; }
jc() { _lazy_load_autojump; jc "$@"; }
jo() { _lazy_load_autojump; jo "$@"; }

# syntax-highlighted `less`
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -R -XF '

alias p1='ping 1.1.1.1'
alias gbr='~/.config/bin/enhanced-git-branch.sh'
