delete_warp_icon() {
    # this would only take effect after restart
    rm -rf /Applications/Warp.app/Contents/PlugIns/WarpDockTilePlugin.docktileplugin && osascript -e 'tell application "System Events" to restart'
}

echo "[oh-my-zsh] module warp.zsh loaded"
