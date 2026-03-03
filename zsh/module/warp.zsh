delete_warp_icon() {
    # this would only take effect after restart
    rm -rf /Applications/Warp.app/Contents/PlugIns/WarpDockTilePlugin.docktileplugin
    echo "Warp icon deleted. Please restart your terminal to see the effect."
}

echo "[oh-my-zsh] module warp.zsh loaded"
