-- Config for Window Manager
local js = require("utils.js")

local config = {}

-- Application blacklist - windows from these apps will not be auto-maximized
-- Organized by category for easier maintenance
local systemApps = {
    "System Preferences",
    "Control Center",
    "UASharedPasteboardProgressUI"
}

local launchers = {
    "Raycast",
    "Alfred",
}

local games = {
    "Hearthstone",
}

local baseList = {
    "Hammerspoon",
    "Loop",
    "Mouseposé",
    "Shottr",
    "AutoSwitchInput Pro",
    "Endel"
}

config.blacklist = js.merge(systemApps, baseList, launchers, games)

-- Apps that should be centered instead of maximized
config.centerList = {
    -- system apps
    "Calculator",
    "iPhone Mirroring",

    -- third-party apps

    -- it can be filled, but looked wired, so use center
    "Pictogram",
    "Alacritty",
    "Xiaomi Home",
}

-- Check if application is in the blacklist
function config.isBlacklisted(appName)
    return js.includes(config.blacklist, appName)
end

-- Check if application should be centered instead of maximized
function config.shouldCenterInsteadOfMax(appName)
    return js.includes(config.centerList, appName)
end

return config
