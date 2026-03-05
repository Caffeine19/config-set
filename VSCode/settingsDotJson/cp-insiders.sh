FROM=~/Code/config-set/VSCode/settingsDotJson/build/dist.insiders.json
TO=~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json

cp "$FROM" "$TO"
echo "📋 copy $FROM -> $TO"
