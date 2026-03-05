FROM=~/Code/config-set/zsh/Mac/MacBookAirM3/.zshrc
TO=~/.zshrc

rm -f "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
