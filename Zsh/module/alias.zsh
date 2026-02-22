alias cls="clear"
alias lg="lazygit"
alias id="open -na 'Intellij IDEA.app'"
alias th="theme"
alias ff="fastfetch"
alias cat="bat"

alias codei="code-insiders"

alias ls="lsd --group-dirs first"
alias ll="lsd -alF --group-dirs first"
alias la="lsd -A --group-dirs first"
alias lt='ls --tree --group-dirs first'

alias czg="pnpm czg"
alias czgw="pnpm -w czg"
alias cz="pnpm cz"
alias czw="pnpm -w cz"

# yesterday work
alias yw='git --no-pager log --oneline --no-merges --author="$(git config user.name)" --since=yesterday.midnight --until=midnight | tr "()" "  " | pbcopy && echo "Yesterday commits copied to clipboard"'
# today work
alias tw='git --no-pager log --oneline --no-merges  --author="$(git config user.name)" --since=midnight | tr "()" "  " | pbcopy && echo "Today commits copied to clipboard"'

# git: initial commit with tada emoji
alias init_repo='git commit -m ":tada: init project"'

alias run_fn='fn=$(print -l ${(k)functions} | grep -v "^_" | fzf) && [ -n "$fn" ] && echo "Running >> $fn" && eval "$fn"'

echo "[oh-my-zsh] module alias.zsh loaded"
