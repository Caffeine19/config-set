alias cls="clear"
alias lg="lazygit"
alias id="open -na 'Intellij IDEA.app'"
alias th="theme"
alias ff="fastfetch"
alias cat="bat"

alias ls="lsd --group-dirs first"
alias ll="lsd -alF --group-dirs first"
alias la="lsd -A --group-dirs first"
alias lt='ls --tree --group-dirs first'

alias cz="pnpm czg"
alias czw="pnpm -w czg"

# git yesterday commits and copy to clipboard
alias yw='(git --no-pager log --oneline --no-merges --author="$(git config user.name)" --since=yesterday.midnight --until=midnight | pbcopy) && echo "Yesterday commits copied to clipboard"'
# today work
alias tw='(git --no-pager log --oneline --no-merges  --author="$(git config user.name)" --since=midnight | pbcopy) && echo "Today commits copied to clipboard"'

echo "module alias.zsh loaded"
