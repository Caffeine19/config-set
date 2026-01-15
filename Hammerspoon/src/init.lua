hs.console.maxOutputHistory(100000000)
hs.console.darkMode(true)

hs.console.consoleCommandColor(
    { red = 0.667, green = 0.627, blue = 0.98, alpha = 1.0 }
)

-- hs.console.outputBackgroundColor({ red = 0.1, green = 0.1, blue = 0.1, alpha = 1 })

-- jetbrains fleet theme entity.other.attribute-name
-- purple
-- rgba(66.7%, 62.7%, 98%, 1)
hs.console.consolePrintColor({ red = 0.667, green = 0.627, blue = 0.98, alpha = 1.0 })

-- jetbrains fleet theme constant.other.symbol
-- white
-- rgba(83.9%, 83.9%, 86.7%, 1)
-- hs.console.consolePrintColor({ red = 0.839, green = 0.839, blue = 0.867, alpha = 1.0 })

hs.console.consoleFont({ name = "JetBrainsMono Nerd Font Propo", size = 14 })

-- The Raycast Hammerspoon extension need this to be enabled
hs.allowAppleScript(true)

local windowManager = require("feats.windowManager.windowManager")

windowManager.init()

local function handleCallTidyAllScreens()
    windowManager.tidyAllScreens()
    return "Tidied all screens successfully"
end
_G.handleCallTidyAllScreens = handleCallTidyAllScreens

local function handleCallTidyAllSpaces()
    -- This function can be used to tidy all windows across all spaces
    windowManager.tidyAllSpaces()
    return "Tidied all spaces successfully"
end
_G.handleCallTidyAllSpaces = handleCallTidyAllSpaces

local function handleCallTidyMainScreen()
    -- This function can be used to tidy the main screen by maximizing all windows
    windowManager.tidyMainScreen()
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
    local result = toggleEdgeTabsPane.pin()
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
    local result = picEdge.setEdgeIcon()
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
    endel.setMode(mode)
    return "Set Endel mode to " .. mode .. " successfully"
end
_G.handleCallSetEndelMode = handleCallSetEndelMode
