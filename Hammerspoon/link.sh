#!/bin/bash

# Create ~/.hammerspoon directory if it doesn't exist
mkdir -p ~/.hammerspoon

# Link all Lua modules from src directory
for lua_file in ~/Code/config-set/Hammerspoon/src/*.lua; do
    target_file=~/.hammerspoon/$(basename "$lua_file")

    # Check if the link already exists
    if [ -L "$target_file" ]; then
        echo "Link already exists, skipping $(basename "$lua_file")"
        continue
    fi

    # Remove existing file if it's not a symlink
    if [ -f "$target_file" ]; then
        echo "Removing existing file $(basename "$lua_file")"
        rm -f "$target_file"
    fi

    echo "Linking $(basename "$lua_file")"
    ln -s "$lua_file" "$target_file"
done

echo "Hammerspoon configuration linked successfully!"
