# link warp launch configurations
# Remove existing file/symlink if it exists
if [ -e /Users/caffeinecat/.warp/launch_configurations ] || [ -L /Users/caffeinecat/.warp/launch_configurations ]; then
    echo "Removing existing /Users/caffeinecat/.warp/launch_configurations"
    rm -rf /Users/caffeinecat/.warp/launch_configurations
fi

# Create new symlink
ln -s /Users/caffeinecat/Code/config-set/Warp/launch_configurations /Users/caffeinecat/.warp/launch_configurations
echo "Created symlink: /Users/caffeinecat/.warp/launch_configurations -> /Users/caffeinecat/Code/config-set/Warp/launch_configurations"
