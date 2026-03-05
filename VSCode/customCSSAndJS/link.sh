TO_DIR=~/.config/vscode-custom-css-and-js

rm -rf "$TO_DIR"
mkdir -p "$TO_DIR"
for FROM in ~/Code/config-set/VSCode/customCSSAndJS/css/*.css; do
    TO="$TO_DIR/$(basename "$FROM")"
    ln -s "$FROM" "$TO"
    echo "🔗 link $FROM -> $TO"
done
