#!/bin/bash

# Link Alacritty configuration
# Config location: ~/.config/alacritty/alacritty.toml

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/alacritty"
SOURCE_FILE="$SCRIPT_DIR/alacritty.toml"
TARGET_FILE="$CONFIG_DIR/alacritty.toml"

# Create config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating config directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

# Check if target already exists
if [ -L "$TARGET_FILE" ]; then
    echo "Symlink already exists: $TARGET_FILE"
    echo "Current link: $(readlink "$TARGET_FILE")"
elif [ -f "$TARGET_FILE" ]; then
    echo "File already exists (not a symlink): $TARGET_FILE"
    echo "Backing up to: $TARGET_FILE.backup"
    mv "$TARGET_FILE" "$TARGET_FILE.backup"
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
    echo "Created symlink: $TARGET_FILE -> $SOURCE_FILE"
else
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
    echo "Created symlink: $TARGET_FILE -> $SOURCE_FILE"
fi
