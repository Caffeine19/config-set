copy_file() {
  if [ -z "$1" ]; then
    echo "Usage: copyfile <file-path>"
    return 1
  fi

  local filepath
  filepath="$(realpath "$1" 2>/dev/null)"

  if [ ! -e "$filepath" ]; then
    echo "File not found: $1"
    return 1
  fi

  osascript -e "set the clipboard to (POSIX file \"$filepath\")"
  echo "Copied to Finder clipboard: $filepath"
}

echo "[oh-my-zsh] module copyFile.zsh loaded"
