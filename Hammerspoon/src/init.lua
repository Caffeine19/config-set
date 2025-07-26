hs.console.maxOutputHistory(100000000)
hs.console.outputBackgroundColor({ red = 0.1, green = 0.1, blue = 0.1, alpha = 1 })

-- The Raycast Hammerspoon extension need this to be enabled
hs.allowAppleScript(true)

local windowManager = require("windowManager")

windowManager.init()

local function handleCallMaximizeAllWindowFromShortcut()
    -- When create an Apple Shortcut, this function will be called
    windowManager.maximizeAllWindows()
    return "Maximized all windows successfully"
end
_G.handleCallMaximizeAllWindowFromShortcut = handleCallMaximizeAllWindowFromShortcut

local function handleCallMaximizeAllWindowFromAllSpacesFromShortcut()
    -- This function can be used to maximize all windows across all spaces
    windowManager.maximizeAllWindowsFromAllSpaces()
    return "Maximized all windows across all spaces successfully"
end
_G.handleCallMaximizeAllWindowFromAllSpacesFromShortcut = handleCallMaximizeAllWindowFromAllSpacesFromShortcut


-- local space = require("space")
-- function handleCallRemoveCurrentSpaceFromShortcut()
--     space.removeCurrentSpace()
--     return "Removed current space successfully"
-- end
-- _G.handleCallRemoveCurrentSpaceFromShortcut = handleCallRemoveCurrentSpaceFromShortcut

local toggleEdgeTabsPane = require("toggleEdgeTabsPane")
local function handleCallCollapseEdgeTabsFromShortcut()
    -- This function can be used to toggle Edge tabs
    local result = toggleEdgeTabsPane.collapse()
    return result or "Toggled Edge tabs successfully"
end

_G.handleCallCollapseEdgeTabsFromShortcut = handleCallCollapseEdgeTabsFromShortcut
local function handleCallPinEdgeTabsFromShortcut()
    local result = toggleEdgeTabsPane.pin()
    return result or "Pinned Edge tabs successfully"
end
_G.handleCallPinEdgeTabsFromShortcut = handleCallPinEdgeTabsFromShortcut
