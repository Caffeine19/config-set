FROM=~/Code/config-set/Warp/keybindings/keybindings.yaml
TO=~/.warp/keybindings.yaml

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
