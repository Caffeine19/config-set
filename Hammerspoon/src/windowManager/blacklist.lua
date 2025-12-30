-- Blacklist and CenterList configuration for Window Manager
local utils = require("utils")

local blacklist = {}

-- Application blacklist - windows from these apps will not be auto-maximized
-- Organized by category for easier maintenance
local systemApps = {
    "Calculator", "System Preferences", "Control Center"
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
    "Pictogram",
    "AutoSwitchInput Pro",
}

blacklist.blacklist = utils.merge(systemApps, baseList, launchers, games)

-- Apps that should be centered instead of maximized
blacklist.centerList = {
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
