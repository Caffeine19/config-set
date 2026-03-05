FROM=~/Code/config-set/zsh/Mac/MacBookProM2Max/.zshrc
TO=~/.zshrc

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
