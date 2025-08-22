#!/usr/bin/env bash
set -euo pipefail

SOURCE_FILE="$HOME/Code/config-set/VSCode/settingsDotJson/build/dist.json"

# Stable VS Code only
STABLE_DIR="$HOME/Library/Application Support/Code/User"
STABLE_TARGET="$STABLE_DIR/settings.json"

link_settings() {
    local target="$1"
    local source="$2"
    local dir
    dir="$(dirname "$target")"

    mkdir -p "$dir"

    if [ -L "$target" ]; then
        echo "Removing existing symlink: $target"
        rm -f "$target"
    elif [ -e "$target" ]; then
        echo "Backing up existing file: $target -> $target.backup"
        mv "$target" "$target.backup"
    fi

    ln -s "$source" "$target"
    echo "Linked $source -> $target"
}

if [ -f "$SOURCE_FILE" ]; then
    link_settings "$STABLE_TARGET" "$SOURCE_FILE"
else
    echo "Source file $SOURCE_FILE not found. Please build first with 'pnpm run build'."
    exit 1
fi
