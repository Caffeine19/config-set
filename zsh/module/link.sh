# link all modules into oh-my-zsh custom dir
# https://github.com/ohmyzsh/ohmyzsh/wiki/Customization
TO_DIR=~/.oh-my-zsh/custom

for FROM in ~/Code/config-set/zsh/module/*.zsh; do
    TO="$TO_DIR/$(basename "$FROM")"
    rm -f "$TO"
    ln -s "$FROM" "$TO"
    echo "🔗 link $FROM -> $TO"
done
