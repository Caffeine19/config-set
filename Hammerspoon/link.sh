#!/bin/bash

# Create ~/.hammerspoon directory if it doesn't exist
mkdir -p ~/.hammerspoon

# Remove existing files if they exist
rm -f ~/.hammerspoon/init.lua
rm -f ~/.hammerspoon/utils.lua
rm -f ~/.hammerspoon/windowManager.lua

# Create symlinks
ln -s ~/Code/config-set/Hammerspoon/init.lua ~/.hammerspoon/init.lua
ln -s ~/Code/config-set/Hammerspoon/utils.lua ~/.hammerspoon/utils.lua
ln -s ~/Code/config-set/Hammerspoon/windowManager.lua ~/.hammerspoon/windowManager.lua

echo "Hammerspoon configuration linked successfully!"
echo "init.lua -> ~/.hammerspoon/init.lua"
echo "utils.lua -> ~/.hammerspoon/utils.lua"
echo "windowManager.lua -> ~/.hammerspoon/windowManager.lua"
