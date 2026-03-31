FROM=~/Code/config-set/VSCode/keybindings/build/dist.json
TO=~/Library/Application\ Support/Code/User/keybindings.json

cp "$FROM" "$TO"
echo "copy $FROM -> $TO"
