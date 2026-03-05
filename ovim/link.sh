FROM=~/Code/config-set/ovim/terminal-launcher.sh
TO=~/Library/Application\ Support/ovim/terminal-launcher.sh

mkdir -p "$(dirname "$TO")"
rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"

# Make sure the script is executable
chmod +x "$FROM"
echo "Made script executable: $FROM"


