# dotfiles

Portable baseline from my personal MacBook.

## Included

- Shell config: `.zshrc`, `.zprofile`, `.zshenv`, `.profile`, `.zsh/traviscj.zsh`
- Git and Jujutsu config: `.gitconfig`, `.config/git/ignore`, `.config/jj/config.toml`
- Terminal/editor config: `.tmux.conf`, `.emacs.d/init.el`
- Tool config: `.claude/settings.json`, `.config/gh/config.yml`, `.config/goose/config.yaml`, `.taskrc`
- Small CLI helpers: `.config/bin/` (e.g. `enhanced-git-branch.sh`, `ghmarkdown`)
- Shell tip-of-the-day nudge: `.zsh/motd.zsh` + `.zsh/tips.txt`
- Package inventory: `Brewfiles/` (see below)

Work / Square-specific config is intentionally **not** here — it lives in the separate Square `config_files` repo. This repo is public.

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

## Homebrew

Packages are split into composable profiles under `Brewfiles/`:

- `Brewfiles/common` — portable baseline, safe on any machine
- `Brewfiles/personal` — personal-mac-only (GUI apps, DBs, media, local-LLM, build deps)

Apply via `just` (always installs `common` + one profile):

```bash
just install            # common + personal (default)
just common             # only the portable baseline
just untracked          # brew leaves installed here but in no Brewfile
just missing            # tracked packages not yet installed
just triage             # stage untracked leaves for sorting into a profile
```

No `work` profile lives here on purpose — work/Square packages stay in the Square `config_files` repo.

## Tip-of-the-day

`.zsh/motd.zsh` prints one tip from `.zsh/tips.txt` on the first interactive shell of each
half-day (and on demand via `tip` / `tip -r` / `tip all`). Add tips with:

```bash
tip-add NUDGE "fzf: pipe long lists to fzf instead of copy-pasting slugs"
./script/suggest-tips    # mine shell history for under-used tools -> proposed tip-add lines
```

Tags: `NUDGE` (installed but ignored), `FLAG` (option for a tool you already use), `NEW` (worth installing).
