-- The Raycast Hammerspoon extension need this to be enabled
hs.allowAppleScript(true)

-- Import utility functions
local utils = require("utils")

local launchers = {"Raycast", "Alfred", "Hammerspoon"}

-- Blacklist of applications that should not be maximized
local blacklist = utils.mergeArrays({"Calculator", "System Preferences", "System Settings", "Hammerspoon", "Loop"},
    launchers)

-- Function to check if an application is blacklisted
local function isBlacklisted(appName)
    return utils.includes(blacklist, appName)
end

-- Subscribe to window creation events
hs.window.filter.default:subscribe(hs.window.filter.windowCreated, function(win)
    local appName = win:application():name()

    -- Skip blacklisted applications
    if isBlacklisted(appName) then
        print("[SKIP] " .. appName .. " is blacklisted")
        return
    end

    print("[AUTO-MAXIMIZE] Processing " .. appName)

    -- 1. Check if Window/Fill menu item exists
    local app = win:application()
    local menuItem = app:findMenuItem({"Window", "Fill"})

    if menuItem then
        -- Window/Fill menu exists, use select menu item to maximize the window
        local success = app:selectMenuItem({"Window", "Fill"})
        if success then
            print("[SUCCESS] Window/Fill menu selected for " .. appName)
        else
            print("[FAILED] Could not select Window/Fill for " .. appName)
        end
    else
        -- Window/Fill menu not available, use Raycast maximize command
        print("[FALLBACK] Using Raycast for " .. appName .. " (no Window/Fill menu)")
        hs.execute("open -g raycast://extensions/raycast/window-management/maximize")
    end

end)

