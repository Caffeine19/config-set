FROM=~/Code/config-set/skhd/skhdrc
TO=~/.config/skhd/skhdrc

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
