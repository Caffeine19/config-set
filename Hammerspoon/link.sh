#!/bin/bash

# Create ~/.hammerspoon directory if it doesn't exist
mkdir -p ~/.hammerspoon


# Recursively link all .lua files from src (including subfolders) to ~/.hammerspoon, preserving directory structure
find ~/Code/config-set/Hammerspoon/src -type f -name '*.lua' | while read -r lua_file; do
    # Compute relative path from src
    rel_path="${lua_file#~/Code/config-set/Hammerspoon/src/}"
    target_file=~/.hammerspoon/$rel_path

    # Create target directory if needed
    mkdir -p "$(dirname "$target_file")"

    # Check if the link already exists
    if [ -L "$target_file" ]; then
        echo "Link already exists, skipping $rel_path"
        continue
    fi

    # Remove existing file if it's not a symlink
    if [ -f "$target_file" ]; then
        echo "Removing existing file $rel_path"
        rm -f "$target_file"
    fi

    echo "Linking $rel_path"
    ln -s "$lua_file" "$target_file"
done

echo "Hammerspoon configuration linked successfully!"
