export NVM_DIR="$HOME/.nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

case "$(uname)" in
  Darwin) alias ls='ls -G'; alias ll='ls -lG' ;;
  Linux)  alias ls='ls --color=auto'; alias ll='ls -lh --color=auto' ;;
esac
alias p8='ping 8.8.8.8'
alias clauded='claude --dangerously-skip-permissions'

command -v navi >/dev/null 2>&1 && source <(navi widget zsh)

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

# Keep shell-only secrets and machine-specific overrides out of git.
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

# Kill words but stop at directory markers.
autoload -U select-word-style
select-word-style bash

DISABLE_AUTO_TITLE="true"
