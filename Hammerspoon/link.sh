FROM=~/Code/config-set/Hammerspoon/src
TO=~/.hammerspoon

rm -rf "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"