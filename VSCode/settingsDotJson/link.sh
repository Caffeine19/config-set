FROM=~/Code/config-set/VSCode/settingsDotJson/build/dist.json
TO=~/Library/Application\ Support/Code/User/settings.json

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
