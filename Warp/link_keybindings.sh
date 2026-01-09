# link warp keybindings
# Remove existing file/symlink if it exists
if [ -e /Users/caffeinecat/.warp/keybindings.yaml ] || [ -L /Users/caffeinecat/.warp/keybindings.yaml ]; then
    echo "Removing existing /Users/caffeinecat/.warp/keybindings.yaml"
    rm -f /Users/caffeinecat/.warp/keybindings.yaml
fi

# Create new symlink
ln -s /Users/caffeinecat/Code/config-set/Warp/keybindings/keybindings.yaml /Users/caffeinecat/.warp/keybindings.yaml
echo "Created symlink: /Users/caffeinecat/.warp/keybindings.yaml -> /Users/caffeinecat/Code/config-set/Warp/keybindings/keybindings.yaml"
