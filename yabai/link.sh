# link yabai
# Remove existing file/symlink if it exists
if [ -e ~/.config/yabai/yabairc ] || [ -L ~/.config/yabai/yabairc ]; then
    echo "Removing existing ~/.config/yabai/yabairc"
    rm ~/.config/yabai/yabairc
fi

# Ensure directory exists
mkdir -p ~/.config/yabai

# Create new symlink
ln -s ~/Code/config-set/yabai/yabairc ~/.config/yabai/yabairc
echo "Created symlink: ~/.config/yabai/yabairc -> ~/Code/config-set/yabai/yabairc"
