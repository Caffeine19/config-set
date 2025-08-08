#!/usr/bin/env bash
set -euo pipefail

SOURCE_FILE="$HOME/Code/config-set/VSCode/settingsDotJson/build/dist.json"

# Stable VS Code only
STABLE_DIR="$HOME/Library/Application Support/Code/User"
STABLE_TARGET="$STABLE_DIR/settings.json"

copy_settings() {
    local target="$1"
    local source="$2"
    local dir
    dir="$(dirname "$target")"

    mkdir -p "$dir"

    if [ -e "$target" ]; then
        rm -f "$target"
    fi

    cp "$source" "$target"
    echo "Copied $source -> $target"
}

copy_settings "$STABLE_TARGET" "$SOURCE_FILE"
