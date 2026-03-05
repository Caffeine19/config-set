FROM=~/Code/config-set/Warp/launch_configurations
TO=~/.warp/launch_configurations

rm -rf "$TO"
ln -s "$FROM" "$TO"
echo "🔗 link $FROM -> $TO"
