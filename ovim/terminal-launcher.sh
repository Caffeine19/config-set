#!/bin/bash
# ovim custom launcher script for Alacritty
# This script allows custom window decorations (Buttonless title bar)

# Set up PATH to include common locations
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Log file
LOG_FILE="$HOME/Library/Logs/ovim/terminal-launcher.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log "=== Terminal launcher started ==="
log "OVIM_CLI: $OVIM_CLI"
log "OVIM_SESSION_ID: $OVIM_SESSION_ID"
log "OVIM_FILE: $OVIM_FILE"
log "OVIM_EDITOR: $OVIM_EDITOR"
log "OVIM_SOCKET: $OVIM_SOCKET"
log "OVIM_WIDTH: $OVIM_WIDTH"
log "OVIM_HEIGHT: $OVIM_HEIGHT"

# Calculate columns and rows from pixel dimensions (with defaults)
WIDTH=${OVIM_WIDTH:-800}
HEIGHT=${OVIM_HEIGHT:-600}
COLS=$((WIDTH / 40))
ROWS=$((HEIGHT / 16))
[ "$COLS" -lt 20 ] && COLS=20
[ "$ROWS" -lt 10 ] && ROWS=10

log "Calculated: COLS=$COLS, ROWS=$ROWS"

# Signal that we're handling the spawn
log "Calling launcher-handled..."
ovim launcher-handled --session "$OVIM_SESSION_ID"
log "launcher-handled returned: $?"

# Launch Alacritty with Buttonless decorations
log "Launching Alacritty..."
log "Command: /Applications/Alacritty.app/Contents/MacOS/alacritty -o 'window.decorations=\"Buttonless\"' -o \"window.dimensions.columns=$COLS\" -o \"window.dimensions.lines=$ROWS\" -e $EDITOR_PATH --listen $OVIM_SOCKET $OVIM_FILE"

/Applications/Alacritty.app/Contents/MacOS/alacritty \
    -o 'window.decorations="Buttonless"' \
    -o "window.dimensions.columns=120" \
    -o "window.dimensions.lines=$ROWS" \
    -e /opt/homebrew/bin/nvim --listen "$OVIM_SOCKET" "$OVIM_FILE" 

log "Alacritty exited with: $?"
log "=== Terminal launcher finished ==="

