#!/bin/bash

# Create ~/.hammerspoon directory if it doesn't exist
mkdir -p ~/.hammerspoon

# Remove existing files if they exist
rm -f ~/.hammerspoon/init.lua
rm -f ~/.hammerspoon/utils.lua
rm -f ~/.hammerspoon/windowManager.lua
rm -f ~/.hammerspoon/callInShortcut.lua
rm -f ~/.hammerspoon/space.lua
rm -f ~/.hammerspoon/toggleEdgeTabsPane.lua

# Create symlinks from src directory
ln -s ~/Code/config-set/Hammerspoon/src/init.lua ~/.hammerspoon/init.lua
ln -s ~/Code/config-set/Hammerspoon/src/utils.lua ~/.hammerspoon/utils.lua
ln -s ~/Code/config-set/Hammerspoon/src/windowManager.lua ~/.hammerspoon/windowManager.lua
ln -s ~/Code/config-set/Hammerspoon/src/callInShortcut.lua ~/.hammerspoon/callInShortcut.lua
ln -s ~/Code/config-set/Hammerspoon/src/space.lua ~/.hammerspoon/space.lua
ln -s ~/Code/config-set/Hammerspoon/src/toggleEdgeTabsPane.lua ~/.hammerspoon/toggleEdgeTabsPane.lua

echo "Hammerspoon configuration linked successfully!"
echo "init.lua -> ~/.hammerspoon/init.lua"
echo "utils.lua -> ~/.hammerspoon/utils.lua"
echo "windowManager.lua -> ~/.hammerspoon/windowManager.lua"
echo "callInShortcut.lua -> ~/.hammerspoon/callInShortcut.lua"
echo "space.lua -> ~/.hammerspoon/space.lua"
echo "toggleEdgeTabsPane.lua -> ~/.hammerspoon/toggleEdgeTabsPane.lua"
