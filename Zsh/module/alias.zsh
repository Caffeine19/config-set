alias cls="clear"
alias lg="lazygit"
alias id="open -na 'Intellij IDEA.app'"
alias th="theme"
alias ff="fastfetch"
alias cat="bat"

alias ls="lsd --group-dirs first"
alias ll="lsd -1 --group-dirs first"
alias la="lsd -la --group-dirs first"
alias lt='ls --tree --group-dirs first'

alias cz="pnpm czg"
alias czw="pnpm -w czg"

# git yesterday commits and copy to clipboard
alias yw='git log --oneline --no-merges  --author="$(git config user.name)" --since=yesterday.midnight --until=midnight | pbcopy'
# today work
alias tw='git log --oneline --no-merges  --author="$(git config user.name)" --since=midnight | pbcopy'

echo "module alias.zsh loaded"
