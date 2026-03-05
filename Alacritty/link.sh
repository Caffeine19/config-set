FROM=~/Code/config-set/Alacritty/alacritty.toml
TO=~/.config/alacritty/alacritty.toml

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
