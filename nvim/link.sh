# link ideavimrc
FROM=~/Code/config-set/nvim/.ideavimrc
TO=~/.ideavimrc

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"

# link neovim
FROM=~/Code/config-set/nvim
TO=~/.config/nvim

rm -rf "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
