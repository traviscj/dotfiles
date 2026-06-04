# dotfiles tasks. `just` to list. Brewfiles compose as: common + one profile.
# Profiles live in Brewfiles/ (common is always included). Work/Square tooling is
# intentionally NOT here — it stays in the Square config_files / babushka repo.

set shell := ["bash", "-uc"]

profile := "personal"
brewfiles := "Brewfiles"

# list recipes
default:
    @just --list

# install common + the given profile (default: personal)
install profile=profile:
    brew bundle --file=<(cat {{brewfiles}}/common {{brewfiles}}/{{profile}})

# install ONLY the portable common baseline
common:
    brew bundle --file={{brewfiles}}/common

# check whether everything in common+profile is installed (no changes made)
check profile=profile:
    brew bundle check --verbose --file=<(cat {{brewfiles}}/common {{brewfiles}}/{{profile}})

# drift: brew leaves installed on this machine but tracked in NO Brewfile
untracked:
    @comm -23 \
      <(brew leaves | sort -u) \
      <(grep -h '^brew ' {{brewfiles}}/* | sed -E 's/^brew "([^"]+)".*/\1/; s#.*/##' | sort -u) \
      | sed 's/^/  /' ; echo "(^ installed leaves not in any Brewfile)"

# drift: entries tracked in common+profile but not installed here
missing profile=profile:
    @brew bundle check --file=<(cat {{brewfiles}}/common {{brewfiles}}/{{profile}}) >/dev/null 2>&1 \
      && echo "all tracked packages installed" \
      || brew bundle check --verbose --file=<(cat {{brewfiles}}/common {{brewfiles}}/{{profile}})

# append currently-installed-but-untracked leaves to a scratch file for triage
triage:
    @just untracked | grep '^  ' | sed -E 's/^  /brew "/; s/$/"/' > Brewfiles/.untracked-scratch \
      && echo "wrote Brewfiles/.untracked-scratch — move lines into common/ or personal/, then delete it"
