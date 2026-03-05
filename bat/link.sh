FROM=~/Code/config-set/bat/config
TO=~/.config/bat/config

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
