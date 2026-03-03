rm -rf ~/.config/vscode-custom-css-and-js
mkdir -p ~/.config/vscode-custom-css-and-js
for cssFile in ~/Code/config-set/VSCode/customCSSAndJS/css/*.css; do
    ln -s "$cssFile" ~/.config/vscode-custom-css-and-js/$(basename "$cssFile")
done
