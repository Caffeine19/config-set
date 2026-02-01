-- Config for Window Manager
local js = require("utils.js")

local config = {}

-- Application blacklist - windows from these apps will not be auto-maximized
-- Supports two formats:
--   1. Simple string: "AppName" - blocks all windows from the app
--   2. Table with callback: {"AppName", function(win) return condition end}
--      - Only blocks when callback returns true
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

-- Apps with conditional blacklist rules (callback must return true to skip)
local conditionalList = {
    {
        "Notion",
        function(win)
            return win:title() == "Notion - Command Search"
        end
    },
    {
        "迅雷",
        function(win)
            local title = win:title()
            return title == "新建任务" or title == "新建下载任务"
        end
    },
    {
        "夸克网盘",
        function(win)
            return win:title() == "通知"
        end
    },
    {
        "Transmission",
        function(win)
            return win:title() ~= "Transmission"
        end
    },
}

config.blacklist = js.merge(systemApps, baseList, launchers, games, conditionalList)

-- Check if window should be blacklisted
-- Returns: shouldSkip (boolean), reason (string or nil)
function config.isBlacklisted(appName, win)
    for _, item in ipairs(config.blacklist) do
        if type(item) == "string" then
            -- Simple string match
            if item == appName then
                return true, appName .. " is blacklisted"
            end
        elseif type(item) == "table" then
            -- Conditional match: {appName, callback}
            local blacklistAppName = item[1]
            local callback = item[2]
            if blacklistAppName == appName and callback and callback(win) then
                return true, appName .. " - conditional blacklist matched"
            end
        end
    end
    return false, nil
end

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

-- Check if application should be centered instead of maximized
function config.shouldCenterInsteadOfMax(appName)
    return js.includes(config.centerList, appName)
end

return config
