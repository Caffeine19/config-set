#!/bin/bash
# link karabiner
# Remove existing file/symlink if it exists
if [ -e ~/.config/karabiner/karabiner.json ] || [ -L ~/.config/karabiner/karabiner.json ]; then
    echo "Removing existing ~/.config/karabiner/karabiner.json"
    rm ~/.config/karabiner/karabiner.json
fi

# Ensure directory exists
mkdir -p ~/.config/karabiner

# Create new symlink
ln -s ~/Code/config-set/KarabinerElements/config/MacBookProM2Max/karabiner.json ~/.config/karabiner/karabiner.json
echo "Created symlink: ~/.config/karabiner/karabiner.json -> ~/Code/config-set/KarabinerElements/config/MacBookProM2Max/karabiner.json"
