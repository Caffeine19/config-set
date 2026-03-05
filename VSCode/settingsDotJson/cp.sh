FROM=~/Code/config-set/VSCode/settingsDotJson/build/dist.json
TO=~/Library/Application\ Support/Code/User/settings.json

cp "$FROM" "$TO"
echo "📋 copy $FROM -> $TO"
