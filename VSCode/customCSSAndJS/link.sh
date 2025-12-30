# link all custom css files
mkdir -p ~/.config/vscode-custom-css-and-js
for cssfile in ~/Code/config-set/VSCode/customCSSAndJS/css/*.css; do
    ln -s "$cssfile" ~/.config/vscode-custom-css-and-js/$(basename "$cssfile")
done
