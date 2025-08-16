# link skhd
# Remove existing file/symlink if it exists
if [ -e ~/.config/skhd/skhdrc ] || [ -L ~/.config/skhd/skhdrc ]; then
    echo "Removing existing ~/.config/skhd/skhdrc"
    rm ~/.config/skhd/skhdrc
fi

# Ensure directory exists
mkdir -p ~/.config/skhd

# Create new symlink
ln -s ~/Code/config-set/skhd/skhdrc ~/.config/skhd/skhdrc
echo "Created symlink: ~/.config/skhd/skhdrc -> ~/Code/config-set/skhd/skhdrc"
