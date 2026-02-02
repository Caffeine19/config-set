-- Console configuration
local console = require("console")
console.init()

-- Load SpoonInstall for managing Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true -- Install synchronously to avoid race conditions

-- Install and load EmmyLua for IDE autocompletion (provides hs.* type hints)
spoon.SpoonInstall:andUse("EmmyLua")

-- The Raycast Hammerspoon extension need this to be enabled
hs.allowAppleScript(true)

local windowManager = require("feats.windowManager.windowManager")

windowManager.init()

local function handleCallTidyAllScreens()
    windowManager.tidyAllScreens_async()
    return "Tidied all screens successfully"
end
_G.handleCallTidyAllScreens = handleCallTidyAllScreens

local function handleCallTidyAllSpaces()
    -- This function can be used to tidy all windows across all spaces
    windowManager.tidyAllSpaces_async()
    return "Tidied all spaces successfully"
end
_G.handleCallTidyAllSpaces = handleCallTidyAllSpaces

local function handleCallTidyMainScreen()
    -- This function can be used to tidy the main screen by maximizing all windows
    windowManager.tidyMainScreen_async()
    return "Tidied main screen successfully"
end
_G.handleCallTidyMainScreen = handleCallTidyMainScreen

local function handleCallMessUpAllWindows()
    -- This function can be used to randomly position and size all windows (chaos mode!)
    windowManager.messUpAllWindows()
    return "Messed up all windows successfully"
end
_G.handleCallMessUpAllWindows = handleCallMessUpAllWindows


-- local space = require("space")
-- function handleCallRemoveCurrentSpace()
--     space.removeCurrentSpace()
--     return "Removed current space successfully"
-- end
-- _G.handleCallRemoveCurrentSpace = handleCallRemoveCurrentSpace

local toggleEdgeTabsPane = require("feats.toggleEdgeTabsPane")

local function handleCallCollapseEdgeTabs()
    -- This function can be used to toggle Edge tabs
    local result = toggleEdgeTabsPane.collapse()
    return result or "Toggled Edge tabs successfully"
end
_G.handleCallCollapseEdgeTabs = handleCallCollapseEdgeTabs

local function handleCallPinEdgeTabs()
    local result = toggleEdgeTabsPane.pin_async()
    return result or "Pinned Edge tabs successfully"
end
_G.handleCallPinEdgeTabs = handleCallPinEdgeTabs

local function handleCallToggleEdgeTabs()
    -- This function can be used to toggle Edge tabs
    local result = toggleEdgeTabsPane.toggle()
    return result or "Toggled Edge tabs successfully"
end
_G.handleCallToggleEdgeTabs = handleCallToggleEdgeTabs

local picEdge = require("feats.picEdge")

local function handleCallSetEdgeIcon()
    local result = picEdge.setEdgeIcon_async()
    return result and "Edge icon set successfully" or "Failed to set Edge icon"
end
_G.handleCallSetEdgeIcon = handleCallSetEdgeIcon

-- local macMouseFix = require("macMouseFix")


local endel = require("feats.endel")

local function handleCallToggleEndelPlayPause()
    endel.togglePlayOrPause()
    return "Toggled Endel play/pause successfully"
end
_G.handleCallToggleEndelPlayPause = handleCallToggleEndelPlayPause


local function handleCallSetEndelMode(mode)
    endel.setMode_async(mode)
    return "Set Endel mode to " .. mode .. " successfully"
end
_G.handleCallSetEndelMode = handleCallSetEndelMode


local portChats = require("feats.windowManager.portChats")

-- Expose portChats globally for console access
_G.portChats = portChats

local function handleCallListDisplays()
    portChats.listDisplays()
    return "Listed all displays"
end
_G.handleCallListDisplays = handleCallListDisplays


local function handleCallMoveChatsToDisplay(displayIndex)
    portChats.moveChatsToDisplay(displayIndex)
    return "Moved chat windows to display " .. displayIndex
end
_G.handleCallMoveChatsToDisplay = handleCallMoveChatsToDisplay
