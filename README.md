# dotfiles

Portable baseline from my personal MacBook.

## Included

- Shell config: `.zshrc`, `.zprofile`, `.zshenv`, `.profile`
- Git and Jujutsu config: `.gitconfig`, `.config/git/ignore`, `.config/jj/config.toml`
- Terminal/editor config: `.tmux.conf`, `.emacs.d/init.el`
- Tool config: `.claude/settings.json`, `.config/gh/config.yml`, `.config/goose/config.yaml`
- Package inventory: `Brewfile`

## Excluded on purpose

- Secrets and tokens like `OPENAI_API_KEY`
- Host-specific auth files like `.config/gh/hosts.yml`
- Local history, caches, sessions, and machine-specific state
- Personal app data like `.config/rrcli/config.json`

## Bootstrap

Clone the repo, then run:

```bash
./script/bootstrap
```

The script symlinks tracked files into `$HOME` and moves existing non-symlink files aside with a `.pre-dotfiles-backup` suffix.

## Local-only shell config

Copy `.zshrc.local.example` to `.zshrc.local` and put machine-local exports there.

## Homebrew restore

Install packages from the current machine baseline with:

```bash
brew bundle --file Brewfile
```
