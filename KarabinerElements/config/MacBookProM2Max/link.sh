FROM=~/Code/config-set/KarabinerElements/config/MacBookProM2Max/karabiner.json
TO=~/.config/karabiner/karabiner.json

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
