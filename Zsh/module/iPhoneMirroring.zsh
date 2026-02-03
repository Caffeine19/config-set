replace_iPhone_mirroring_icon() {
    cd /Applications && mkdir "iPhone Mirrored.app" && cd iPhone\ Mirrored.app && ln -s /System/Applications/iPhone\ Mirroring.app/Contents && echo "[Done] iPhone Mirrored.app created in /Applications"
}
