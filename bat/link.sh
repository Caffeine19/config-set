# link bat
# Remove existing file/symlink if it exists
if [ -e ~/.config/bat/config ] || [ -L ~/.config/bat/config ]; then
    echo "Removing existing ~/.config/bat/config"
    rm ~/.config/bat/config
fi

# Ensure directory exists
mkdir -p ~/.config/bat

# Create new symlink
ln -s ~/Code/config-set/bat/config ~/.config/bat/config
echo "Created symlink: ~/.config/bat/config -> ~/Code/config-set/bat/config"
