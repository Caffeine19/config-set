mkdir -p ~/Library/Application\ Support/ovim
rm -f ~/Library/Application\ Support/ovim/terminal-launcher.sh
ln -s ~/Code/config-set/ovim/terminal-launcher.sh ~/Library/Application\ Support/ovim/terminal-launcher.sh

# Make sure the script is executable
chmod +x "$SOURCE_FILE"
echo "Made script executable: $SOURCE_FILE"


