# link all modules into oh-my-zsh custom dir
# https://github.com/ohmyzsh/ohmyzsh/wiki/Customization
for module in ~/Code/config-set/zsh/module/*.zsh; do
    rm -f ~/.oh-my-zsh/custom/$(basename "$module")
    ln -s "$module" ~/.oh-my-zsh/custom/$(basename "$module")
done
