FROM=~/Code/config-set/yabai/yabairc
TO=~/.config/yabai/yabairc

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
