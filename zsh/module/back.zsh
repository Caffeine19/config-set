# Backup a file or folder by renaming it with a .back suffix
# Usage: backup <file-or-folder>
#
# Examples:
#   backup ./notes.md       -> ./notes.back.md
#   backup ./config.json    -> ./config.back.json
#   backup ./my-folder      -> ./my-folder.back
#   backup ./archive        -> ./archive.back (if .back already exists, appends timestamp)

backup() {
  if [[ -z "$1" ]]; then
    echo "Usage: backup <file-or-folder>"
    return 1
  fi

  local target="${1%/}"  # strip trailing slash

  if [[ ! -e "$target" ]]; then
    echo "⚠️ Not found: $target"
    return 1
  fi

  local dir
  local base
  dir="$(dirname "$target")"
  base="$(basename "$target")"

  local backup_name
  if [[ -f "$target" && "$base" == *.* ]]; then
    # file with extension: insert .back before extension
    local stem="${base%.*}"
    local ext="${base##*.}"
    backup_name="${stem}.back.${ext}"
  else
    # folder or file without extension
    backup_name="${base}.back"
  fi

  local backup_path="${dir}/${backup_name}"

  # if backup target already exists, append timestamp to avoid collision
  if [[ -e "$backup_path" ]]; then
    local ts
    ts="$(date +%Y%m%d_%H%M%S)"
    if [[ -f "$target" && "$base" == *.* ]]; then
      local stem="${base%.*}"
      local ext="${base##*.}"
      backup_name="${stem}.back_${ts}.${ext}"
    else
      backup_name="${base}.back_${ts}"
    fi
    backup_path="${dir}/${backup_name}"
  fi

  mv "$target" "$backup_path"
  echo "📦 backup $target -> $backup_path"
}

echo "[oh-my-zsh] module back.zsh loaded"
