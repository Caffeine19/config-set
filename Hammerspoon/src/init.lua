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

local windowManager = require("windowManager")

windowManager.init()

local function handleCallTidyAllScreensFromShortcut()
    -- When create an Apple Shortcut, this function will be called
    windowManager.tidyAllScreens()
    return "Tidied all screens successfully"
end
_G.handleCallTidyAllScreensFromShortcut = handleCallTidyAllScreensFromShortcut

local function handleCallTidyAllSpacesFromShortcut()
    -- This function can be used to tidy all windows across all spaces
    windowManager.tidyAllSpaces()
    return "Tidied all spaces successfully"
end
_G.handleCallTidyAllSpacesFromShortcut = handleCallTidyAllSpacesFromShortcut

local function handleCallTidyMainScreenFromShortcut()
    -- This function can be used to tidy the main screen by maximizing all windows
    windowManager.tidyMainScreen()
    return "Tidied main screen successfully"
end
_G.handleCallTidyMainScreenFromShortcut = handleCallTidyMainScreenFromShortcut


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

local function handleCallToggleEdgeTabsFromShortcut()
    -- This function can be used to toggle Edge tabs
    local result = toggleEdgeTabsPane.toggle()
    return result or "Toggled Edge tabs successfully"
end
_G.handleCallToggleEdgeTabsFromShortcut = handleCallToggleEdgeTabsFromShortcut
