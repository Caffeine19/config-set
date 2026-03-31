FROM=~/Code/config-set/VSCode/keybindings/build/dist.json
TO=~/Library/Application\ Support/Code/User/keybindings.json

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
