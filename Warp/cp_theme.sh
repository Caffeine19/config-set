FROM=~/Code/config-set/Warp/themes/*
TO=~/.warp/themes/

mkdir -p "$TO"
cp $FROM "$TO"
echo "📋 copy $FROM -> $TO"
