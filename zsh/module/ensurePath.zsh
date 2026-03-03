# Ensure directories exist
# Usage: ensure_path

ensure_path() {
    local path_list=(
        "$HOME/Work"
        "$HOME/Code"
        "$HOME/Code/Raycast/CustomExtensions"
        "$HOME/Code/Raycast/ForkedExtensions"
        "$HOME/Movies/QuickRecorder"
        "$HOME/Pictures/Screenshots"
    )

    for dir in "${path_list[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            echo "📁 Created: $dir"
        fi
    done
}

echo "[oh-my-zsh] module ensurePath.zsh loaded"