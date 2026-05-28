export NVM_DIR="$HOME/.nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Prompt — Spaceship (cloned by script/bootstrap).
[ -f "$HOME/.zsh/spaceship-prompt/spaceship.zsh-theme" ] && \
  source "$HOME/.zsh/spaceship-prompt/spaceship.zsh-theme"

case "$(uname)" in
  Darwin) alias ls='ls -G'; alias ll='ls -lG' ;;
  Linux)  alias ls='ls --color=auto'; alias ll='ls -lh --color=auto' ;;
esac
alias p8='ping 8.8.8.8'
alias clauded='claude --dangerously-skip-permissions'

command -v navi >/dev/null 2>&1 && source <(navi widget zsh)

# fzf keybindings + completion if installed.
[[ -o zle ]] && [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -o zle ]] && [ -f /usr/share/doc/fzf/examples/completion.zsh ]   && source /usr/share/doc/fzf/examples/completion.zsh
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

# Personal shell extras (autojump lazy-load, less highlighting, aliases).
[ -f "$HOME/.zsh/traviscj.zsh" ] && source "$HOME/.zsh/traviscj.zsh"

# Tip-of-the-day nudge: surfaces underused tools / flags once per half-day.
[ -f "$HOME/.zsh/motd.zsh" ] && source "$HOME/.zsh/motd.zsh"

# Keep shell-only secrets and machine-specific overrides out of git.
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

# Kill words but stop at directory markers.
autoload -U select-word-style
select-word-style bash

# Auto-escape ? & * etc. when typing/pasting URLs, so quotes aren't needed.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Completion: case-insensitive + minor typo correction (e.g. dev<TAB> -> Development).
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:approximate:*' max-errors 1 numeric

DISABLE_AUTO_TITLE="true"
