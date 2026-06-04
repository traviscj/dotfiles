#!/bin/bash

git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:relative)|%(contents:subject)' | \
while IFS='|' read branch date message; do
    # Get ahead/behind counts
    ahead_behind=$(git rev-list --left-right --count origin/master...$branch 2>/dev/null | tr '\t' '|' || echo "0|0")
    
    # Get changed lines stats
    changed_lines=$(git diff --shortstat master...$branch 2>/dev/null || echo "0 files changed")
    
    # Format the output with colors and padding
    printf "\033[34m%-30s\033[0m |\033[33m %15s\033[0m | \033[36m%s\033[0m | %s | %s\n" \
        "$branch" \
        "$date" \
        "$ahead_behind" \
        "$changed_lines" \
        "$message"
done | fzf \
    --height=30% \
    --reverse \
    --info=inline \
    --ansi \
    --header="BRANCH | LAST COMMIT | AHEAD|BEHIND | CHANGES | COMMIT MESSAGE" \
    --preview 'git log --oneline --graph --date=relative --pretty="format:%C(auto)%h %C(green)%ad%C(auto) %s" $(echo {} | cut -d"|" -f1)' \
    --preview-window=right:50% \
    | cut -d'|' -f1 | xargs git checkout