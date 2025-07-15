-- The Raycast Hammerspoon extension need this to be enabled
hs.allowAppleScript(true)

-- Import modules
local windowManager = require("windowManager")

-- Initialize window management functionality
windowManager.init()

-- Function to be called from Apple Shortcuts
function handleCallMaximizeAllWindowFromShortcut()
    -- When create an Apple Shortcut, this function will be called
    windowManager.maximizeAllWindows()
    return "Maximized all windows successfully"
end

-- Function to handle maximizing all windows across all spaces
function handleCallMaximizeAllWindowFromAllSpacesFromShortcut()
    -- This function can be used to maximize all windows across all spaces
    windowManager.maximizeAllWindowsFromAllSpaces()
    return "Maximized all windows across all spaces successfully"
end

-- Make the function globally accessible
_G.handleCallMaximizeAllWindowFromShortcut = handleCallMaximizeAllWindowFromShortcut
-- Make the function globally accessible for all spaces
_G.handleCallMaximizeAllWindowFromAllSpacesFromShortcut = handleCallMaximizeAllWindowFromAllSpacesFromShortcut
