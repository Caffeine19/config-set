-- Blacklist and CenterList configuration for Window Manager
local utils = require("utils")

local blacklist = {}

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

blacklist.blacklist = utils.merge(systemApps, baseList, launchers, games)

-- Apps that should be centered instead of maximized
blacklist.centerList = {
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
function blacklist.isBlacklisted(appName)
    return utils.includes(blacklist.blacklist, appName)
end

-- Check if application should be centered instead of maximized
function blacklist.shouldCenterInsteadOfMax(appName)
    return utils.includes(blacklist.centerList, appName)
end

return blacklist
